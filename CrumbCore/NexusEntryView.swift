
import SwiftUI

@available(iOS 14.0, *)
struct NexusEntryView: View {
    
    @StateObject private var manager = NexusAccessManager()
    @State private var grantedURL: URL?
    @State private var isBusy = true
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            if grantedURL == nil && !isBusy {
                DashboardView().ignoresSafeArea()
            }
            if let url = grantedURL {
                NexusWebContainer(url: url, loading: $isBusy)
                    .edgesIgnoringSafeArea(.all)
                    .statusBar(hidden: true)
            }
            if isBusy {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.8)
                    )
            }
        }
        .onReceive(manager.$state) { state in
            switch state {
            case .checking:
                isBusy = true
            case .allowed(_, let url):
                grantedURL = url
                isBusy = false
            case .fallback:
                grantedURL = nil
                isBusy = false
            case .idle:
                break
            }
        }
        .onAppear {
            isBusy = true
            manager.start()
        }
    }
}
