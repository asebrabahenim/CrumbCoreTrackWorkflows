import Combine
import Foundation
import SwiftUI

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    return formatter
}()

@available(iOS 14.0, *)
struct AuditLogEntryAddTextField: View {
    let title: String
    let iconName: String
    @Binding var text: String
    var isRequired: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading, 4)
                .opacity(0.9)
                .padding(.bottom, 2) 
            
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .foregroundColor(text.isEmpty && isRequired ? .red : .blue)
                
                TextField("Enter \(title.lowercased())", text: $text)
                    .foregroundColor(.primary)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if isRequired && text.isEmpty {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
            .padding(.vertical, 8)
            
            Divider()
                .background(text.isEmpty && isRequired ? Color.red : Color.blue)
        }
        .padding(.vertical, 6)
    }
}


@available(iOS 14.0, *)
struct AuditLogEntryAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(.top, 5)
            
            DatePicker("", selection: $date)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
        }
    }
}

@available(iOS 14.0, *)
struct AuditLogEntryAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundColor(.white)
                .padding(8)
                .background(Color.orange)
                .cornerRadius(8)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.leading, 5)
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

@available(iOS 14.0, *)
struct AuditLogEntryListSearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            TextField("Search by Actor or Action...", text: $searchText)
                .padding(.vertical, 10)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding([.horizontal, .bottom])
        .animation(.easeOut, value: searchText.isEmpty)
    }
}

@available(iOS 14.0, *)
struct AuditLogEntryDetailFieldRow: View {
    let title: String
    let value: String
    let iconName: String
    let accentColor: Color
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: iconName)
                .foregroundColor(accentColor)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
            }
            Spacer()
        }
        .padding(.vertical, 5)
    }
}

@available(iOS 14.0, *)
struct AuditLogEntryNoDataView: View {
    var body: some View {
        VStack {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()
            
            Text("No Audit Logs Found")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Try refining your search or add a new entry to the system.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(50)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding()
    }
}
@available(iOS 14.0, *)
struct AuditLogEntryListRowView: View {
    let log: AuditLogEntry
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .top) {
                let icon = log.success ? "checkmark.seal.fill" : "xmark.octagon.fill"
                let color = log.success ? Color.green : Color.red
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .padding(8)
                    .background(color.opacity(0.15))
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(log.action)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text("\(log.affectedModule) • \(log.category)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    VStack(spacing: 6) {
                        Label(log.severity, systemImage: "flame.fill")
                            .font(.caption2)
                            .padding(4)
                            .background(Color.orange.opacity(0.15))
                            .cornerRadius(5)
                        Label(log.changeType, systemImage: "arrow.triangle.2.circlepath")
                            .font(.caption2)
                            .padding(4)
                            .background(Color.blue.opacity(0.15))
                            .cornerRadius(5)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(dateFormatter.string(from: log.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    if log.archived {
                        Label("Archived", systemImage: "archivebox.fill")
                            .font(.caption2)
                            .padding(4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                    }
                }
            }
            
            Divider()
            
            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.blue)
                        Text("**Actor:** \(log.actor)")
                            .font(.footnote)
                    }
                    HStack {
                        Image(systemName: "briefcase.fill")
                            .foregroundColor(.purple)
                        Text("**Role:** \(log.role)")
                            .font(.footnote)
                    }
                    HStack {
                        Image(systemName: "desktopcomputer")
                            .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.6))
                        Text("**Device:** \(log.deviceName)")
                            .font(.footnote)
                    }
                    HStack {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.orange)
                        Text("**OS:** \(log.osVersion)")
                            .font(.footnote)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "network")
                            .foregroundColor(.green)
                        Text("**IP:** \(log.ipAddress)")
                            .font(.footnote)
                    }
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.pink)
                        Text("**Location:** \(log.location)")
                            .font(.footnote)
                    }
                    HStack {
                        Image(systemName: "number.square.fill")
                            .foregroundColor(.red)
                        Text("**Ref ID:** \(log.referenceID)")
                            .font(.footnote)
                    }
                    HStack {
                        Image(systemName: "cpu.fill")
                            .foregroundColor(.blue)
                        Text("**Device ID:** \(log.deviceID)")
                            .font(.footnote)
                    }
                }
            }
            
            Divider()
            
            HStack(spacing: 14) {
                AuditLogMetricView(icon: "arrow.left.arrow.right", label: "Change", value: log.changeType, color: .blue)
                AuditLogMetricView(icon: "clock.arrow.circlepath", label: "Duration", value: "\(log.durationMs) ms", color: Color(red: 0.0, green: 0.6, blue: 0.6))
                AuditLogMetricView(icon: "externaldrive.fill", label: "Data", value: "\(log.dataSizeBytes) bytes", color: .purple)
                AuditLogMetricView(icon: "checkmark.circle.fill", label: "Code", value: log.resultCode, color: .green)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Label("App: \(log.appVersion)", systemImage: "app.fill")
                    Spacer()
                    Label("Source: \(log.logSource)", systemImage: "folder.fill")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
                
                HStack {
                    Label("Reviewed by \(log.reviewedBy)", systemImage: "person.text.rectangle")
                    Spacer()
                    Text("on \(dateFormatter.string(from: log.reviewDate))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .font(.caption2)
            }
            
            Divider()
            
            HStack {
                Label("Backup: \(log.backupStatus)", systemImage: "arrow.triangle.2.circlepath.circle.fill")
                Spacer()
                Label("Export: \(log.exportStatus)", systemImage: "square.and.arrow.up.fill")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
            
            Divider()
            
            HStack {
                Label("Session ID: \(log.sessionID)", systemImage: "rectangle.connected.to.line.below.fill")
                Spacer()
                Label("Request ID: \(log.requestID)", systemImage: "link.circle.fill")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 4) {
                if !log.description.isEmpty {
                    Text("Description: \(log.description)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                if !log.comments.isEmpty {
                    Text("Comments: \(log.comments)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                if !log.errorMessage.isEmpty && !log.success {
                    Text("Error: \(log.errorMessage)")
                        .font(.caption2)
                        .foregroundColor(.red)
                        .lineLimit(2)
                }
            }
            
            Divider()
            
            if !log.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(log.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(6)
                        }
                    }
                }
            }
            
            Divider()
            
            HStack {
                Text("Created: \(dateFormatter.string(from: log.createdAt))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Updated: \(dateFormatter.string(from: log.updatedAt))")
                    .font(.caption2)
                    .foregroundColor(.accentColor)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
}

@available(iOS 14.0, *)
struct AuditLogMetricView: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption2)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
    }
}

@available(iOS 14.0, *)
struct AuditLogEntryAddView: View {
    @ObservedObject var dataStore: BiscuitFactoryDataStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var timestamp: Date = Date()
    @State private var actor: String = ""
    @State private var role: String = ""
    @State private var action: String = ""
    @State private var affectedModule: String = ""
    @State private var referenceID: String = ""
    @State private var description: String = ""
    @State private var deviceName: String = ""
    @State private var osVersion: String = ""
    @State private var appVersion: String = ""
    @State private var location: String = ""
    @State private var ipAddress: String = ""
    @State private var changeType: String = ""
    @State private var oldValue: String = ""
    @State private var newValue: String = ""
    @State private var success: Bool = true
    @State private var errorMessage: String = ""
    @State private var reviewedBy: String = "System"
    @State private var reviewDate: Date = Date()
    @State private var category: String = ""
    @State private var severity: String = ""
    @State private var logSource: String = ""
    @State private var comments: String = ""
    @State private var tags: String = "" 
    @State private var archived: Bool = false
    @State private var sessionID: String = ""
    @State private var requestID: String = ""
    @State private var deviceID: String = ""
    @State private var dataSizeBytes: String = ""
    @State private var durationMs: String = ""
    @State private var resultCode: String = "200"
    @State private var backupStatus: String = "Pending"
    @State private var exportStatus: String = "Pending"
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    private func validateAndSave() {
        var errors: [String] = []
        
        let requiredFields = [
            ("Actor", actor), ("Role", role), ("Action", action), ("Affected Module", affectedModule), 
            ("Reference ID", referenceID), ("Description", description), ("Device Name", deviceName), 
            ("OS Version", osVersion), ("App Version", appVersion), ("Location", location), 
            ("IP Address", ipAddress), ("Change Type", changeType), ("Category", category), 
            ("Severity", severity), ("Log Source", logSource), ("Session ID", sessionID), 
            ("Request ID", requestID), ("Device ID", deviceID), ("Result Code", resultCode),
            ("Backup Status", backupStatus), ("Export Status", exportStatus)
        ]
        
        for (name, value) in requiredFields {
            if value.isEmpty {
                errors.append("\(name) is required.")
            }
        }
        
        if (dataSizeBytes.isEmpty || Int(dataSizeBytes) == nil) { errors.append("Data Size must be a number.") }
        if (durationMs.isEmpty || Int(durationMs) == nil) { errors.append("Duration (ms) must be a number.") }
        
        if errors.isEmpty {
            let newLog = AuditLogEntry(
                timestamp: timestamp,
                actor: actor,
                role: role,
                action: action,
                affectedModule: affectedModule,
                referenceID: referenceID,
                description: description,
                deviceName: deviceName,
                osVersion: osVersion,
                appVersion: appVersion,
                location: location,
                ipAddress: ipAddress,
                changeType: changeType,
                oldValue: oldValue,
                newValue: newValue,
                success: success,
                errorMessage: errorMessage,
                reviewedBy: reviewedBy,
                reviewDate: reviewDate,
                category: category,
                severity: severity,
                logSource: logSource,
                comments: comments,
                tags: tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                createdAt: Date(),
                updatedAt: Date(),
                archived: archived,
                sessionID: sessionID,
                requestID: requestID,
                deviceID: deviceID,
                dataSizeBytes: Int(dataSizeBytes) ?? 0,
                durationMs: Int(durationMs) ?? 0,
                resultCode: resultCode,
                backupStatus: backupStatus,
                exportStatus: exportStatus
            )
            dataStore.addAuditLog(newLog)
            alertMessage = "✅ Success!\n\nNew log for '\(action)' by \(actor) has been recorded."
            showAlert = true
            
        } else {
            alertMessage = "❌ Validation Failed:\n\n" + errors.joined(separator: "\n")
            showAlert = true
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                AuditLogEntryAddSectionHeaderView(title: "Event Details", iconName: "bolt.fill")
                
                VStack(spacing: 20) {
                    AuditLogEntryAddDatePickerView(title: "Event Timestamp", iconName: "calendar.badge.clock", date: $timestamp)
                    
                    HStack(spacing: 20) {
                        AuditLogEntryAddTextField(title: "Actor", iconName: "person.text.rectangle.fill", text: $actor)
                        AuditLogEntryAddTextField(title: "Role", iconName: "briefcase.fill", text: $role)
                    }
                    
                    HStack(spacing: 20) {
                        AuditLogEntryAddTextField(title: "Action Performed", iconName: "hammer.fill", text: $action)
                        AuditLogEntryAddTextField(title: "Affected Module", iconName: "puzzlepiece.fill", text: $affectedModule)
                    }
                    
                    HStack(spacing: 20) {
                        AuditLogEntryAddTextField(title: "Reference ID", iconName: "number.square.fill", text: $referenceID)
                        AuditLogEntryAddTextField(title: "Change Type", iconName: "arrow.up.arrow.down.circle.fill", text: $changeType)
                    }
                    
                    AuditLogEntryAddTextField(title: "Description", iconName: "text.alignleft", text: $description)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                AuditLogEntryAddSectionHeaderView(title: "Technical Context", iconName: "gearshape.fill")
                
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        AuditLogEntryAddTextField(title: "Device Name", iconName: "laptopcomputer", text: $deviceName)
                        AuditLogEntryAddTextField(title: "OS Version", iconName: "iphone.homebutton", text: $osVersion)
                    }
                    
                    HStack(spacing: 20) {
                        AuditLogEntryAddTextField(title: "App Version", iconName: "app.fill", text: $appVersion)
                        AuditLogEntryAddTextField(title: "IP Address", iconName: "network", text: $ipAddress)
                    }
                    
                    HStack(spacing: 20) {
                        AuditLogEntryAddTextField(title: "Session ID", iconName: "key.fill", text: $sessionID)
                        AuditLogEntryAddTextField(title: "Request ID", iconName: "arrow.right.to.line", text: $requestID)
                    }
                    
                    AuditLogEntryAddTextField(title: "Device ID", iconName: "qrcode.viewfinder", text: $deviceID)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                AuditLogEntryAddSectionHeaderView(title: "Data & Classification", iconName: "flowchart.fill")
                
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        AuditLogEntryAddTextField(title: "Category", iconName: "folder.fill", text: $category)
                        AuditLogEntryAddTextField(title: "Severity", iconName: "flame.fill", text: $severity)
                    }
                    
                    HStack(spacing: 20) {
                        AuditLogEntryAddTextField(title: "Log Source", iconName: "cloud.fill", text: $logSource)
                        AuditLogEntryAddTextField(title: "Result Code", iconName: "terminal.fill", text: $resultCode)
                    }
                    
                    HStack(spacing: 20) {
                        AuditLogEntryAddTextField(title: "Data Size (Bytes)", iconName: "leaf.arrow.triangle.circlepath", text: $dataSizeBytes)
                            .keyboardType(.numberPad)
                        AuditLogEntryAddTextField(title: "Duration (ms)", iconName: "timer", text: $durationMs)
                            .keyboardType(.numberPad)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                AuditLogEntryAddSectionHeaderView(title: "Review & Status", iconName: "checkmark.shield.fill")
                
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        AuditLogEntryAddTextField(title: "Old Value", iconName: "arrow.left.square", text: $oldValue, isRequired: false)
                        AuditLogEntryAddTextField(title: "New Value", iconName: "arrow.right.square", text: $newValue, isRequired: false)
                    }
                    
                    HStack(spacing: 20) {
                        AuditLogEntryAddTextField(title: "Reviewed By", iconName: "eye.fill", text: $reviewedBy)
                        AuditLogEntryAddDatePickerView(title: "Review Date", iconName: "calendar.badge.checkmark", date: $reviewDate)
                    }
                    
                    HStack(spacing: 20) {
                        AuditLogEntryAddTextField(title: "Backup Status", iconName: "square.stack.3d.up.fill", text: $backupStatus)
                        AuditLogEntryAddTextField(title: "Export Status", iconName: "square.and.arrow.up.fill", text: $exportStatus)
                    }
                    
                    AuditLogEntryAddTextField(title: "Comments", iconName: "bubble.left.and.bubble.right.fill", text: $comments, isRequired: false)
                    AuditLogEntryAddTextField(title: "Tags (comma separated)", iconName: "paperclip", text: $tags, isRequired: false)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Success Status")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Toggle(isOn: $success) {
                                Text(success ? "Success" : "Failure")
                                    .fontWeight(.medium)
                                    .foregroundColor(success ? .green : .red)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: success ? .green : .red))
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Archived Status")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Toggle(isOn: $archived) {
                                Text(archived ? "Archived" : "Active")
                                    .fontWeight(.medium)
                                    .foregroundColor(archived ? .gray : .green)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: archived ? .gray : .green))
                        }
                    }
                    
                    if !success {
                        AuditLogEntryAddTextField(title: "Error Message", iconName: "ant.fill", text: $errorMessage, isRequired: false)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Button(action: validateAndSave) {
                    Text("Record Audit Log")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.blue.opacity(0.4), radius: 5, x: 0, y: 5)
                }
                .padding(.top, 10)
                
            }
            .padding()
        }
        .navigationTitle("New Audit Log Entry")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertMessage.contains("✅") ? "Log Recorded" : "Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if alertMessage.contains("✅") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
}

@available(iOS 14.0, *)
struct AuditLogEntryListView: View {
    @ObservedObject var dataStore: BiscuitFactoryDataStore
    @State private var searchText: String = ""
    @State private var showAddView: Bool = false
    
    private var filteredLogs: [AuditLogEntry] {
        if searchText.isEmpty {
            return dataStore.auditLogs
        } else {
            return dataStore.auditLogs.filter { log in
                log.actor.localizedCaseInsensitiveContains(searchText) ||
                log.action.localizedCaseInsensitiveContains(searchText) ||
                log.affectedModule.localizedCaseInsensitiveContains(searchText) ||
                log.referenceID.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack {
                AuditLogEntryListSearchBarView(searchText: $searchText)
                
                if filteredLogs.isEmpty {
                    Spacer()
                    AuditLogEntryNoDataView()
                    Spacer()
                } else {
                    List {
                        ForEach(filteredLogs) { log in
                            NavigationLink(destination: AuditLogEntryDetailView(log: log)) {
                                AuditLogEntryListRowView(log: log)
                                    .listRowInsets(EdgeInsets())
                                    .background(Color(.systemGroupedBackground))
                                    .contentShape(Rectangle())
                            }
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteLogs)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Audit Logs")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        showAddView = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
            )
            .sheet(isPresented: $showAddView) {
                NavigationView {
                    AuditLogEntryAddView(dataStore: dataStore)
                }
            }
        
    }
    
    private func deleteLogs(at offsets: IndexSet) {
        for index in offsets {
            if let logToDelete = filteredLogs[safe: index] {
                if let originalIndex = dataStore.auditLogs.firstIndex(where: { $0.id == logToDelete.id }) {
                    dataStore.auditLogs.remove(at: originalIndex)
                }
            }
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

@available(iOS 14.0, *)
struct AuditLogEntryDetailView: View {
    let log: AuditLogEntry
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        let successIcon = log.success ? "lock.open.fill" : "lock.slash.fill"
                        let successColor = log.success ? Color.green : Color.red
                        
                        Image(systemName: successIcon)
                            .font(.largeTitle)
                            .foregroundColor(successColor)
                            .padding(10)
                            .background(successColor.opacity(0.1))
                            .cornerRadius(10)
                        
                        VStack(alignment: .leading) {
                            Text(log.action)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            Text(log.affectedModule)
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    
                    Text(log.description)
                        .font(.body)
                        .italic()
                        .padding(.top, 5)
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "clock.fill").foregroundColor(.orange)
                        Text("Logged: \(log.timestamp, formatter: dateFormatter)")
                            .font(.callout)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("User & Transaction")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 10) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 10) {
                                AuditLogEntryDetailFieldRow(title: "Actor", value: log.actor, iconName: "person.fill", accentColor: .blue)
                                AuditLogEntryDetailFieldRow(title: "Role", value: log.role, iconName: "briefcase.fill", accentColor: .blue)
                                AuditLogEntryDetailFieldRow(title: "Change Type", value: log.changeType, iconName: "shuffle", accentColor: .blue)
                                AuditLogEntryDetailFieldRow(title: "Reference ID", value: log.referenceID, iconName: "number.square.fill", accentColor: .blue)
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                AuditLogEntryDetailFieldRow(title: "Old Value", value: log.oldValue.isEmpty ? "N/A" : log.oldValue, iconName: "arrow.left.square", accentColor: Color(red: 0.3, green: 0.3, blue: 0.9))
                                AuditLogEntryDetailFieldRow(title: "New Value", value: log.newValue.isEmpty ? "N/A" : log.newValue, iconName: "arrow.right.square", accentColor: Color(red: 0.3, green: 0.3, blue: 0.9))
                                AuditLogEntryDetailFieldRow(title: "Session ID", value: log.sessionID, iconName: "key.fill", accentColor: .blue)
                                AuditLogEntryDetailFieldRow(title: "Request ID", value: log.requestID, iconName: "arrow.right.to.line", accentColor: .blue)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("System Context")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 10) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 10) {
                                AuditLogEntryDetailFieldRow(title: "Device Name", value: log.deviceName, iconName: "laptopcomputer", accentColor: .purple)
                                AuditLogEntryDetailFieldRow(title: "OS Version", value: log.osVersion, iconName: "gearshape.fill", accentColor: .purple)
                                AuditLogEntryDetailFieldRow(title: "App Version", value: log.appVersion, iconName: "app.fill", accentColor: .purple)
                                AuditLogEntryDetailFieldRow(title: "Device ID", value: log.deviceID, iconName: "qrcode.viewfinder", accentColor: .purple)
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                AuditLogEntryDetailFieldRow(title: "Location", value: log.location, iconName: "mappin.and.ellipse", accentColor: .purple)
                                AuditLogEntryDetailFieldRow(title: "IP Address", value: log.ipAddress, iconName: "network", accentColor: .purple)
                                AuditLogEntryDetailFieldRow(title: "Log Source", value: log.logSource, iconName: "cloud.fill", accentColor: .purple)
                                AuditLogEntryDetailFieldRow(title: "Result Code", value: log.resultCode, iconName: "terminal.fill", accentColor: .purple)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Performance & Classification")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 10) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 10) {
                                AuditLogEntryDetailFieldRow(title: "Data Size", value: "\(log.dataSizeBytes) Bytes", iconName: "doc.fill", accentColor: Color(red: 0.0, green: 0.6, blue: 0.6))
                                AuditLogEntryDetailFieldRow(title: "Duration", value: "\(log.durationMs) ms", iconName: "timer", accentColor: Color(red: 0.0, green: 0.6, blue: 0.6))
                                AuditLogEntryDetailFieldRow(title: "Category", value: log.category, iconName: "folder.fill", accentColor: Color(red: 0.0, green: 0.6, blue: 0.6))
                                AuditLogEntryDetailFieldRow(title: "Severity", value: log.severity, iconName: "flame.fill", accentColor: Color(red: 0.0, green: 0.6, blue: 0.6))
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                AuditLogEntryDetailFieldRow(title: "Status", value: log.success ? "SUCCESS" : "FAILURE", iconName: "star.fill", accentColor: log.success ? .green : .red)
                                AuditLogEntryDetailFieldRow(title: "Backup", value: log.backupStatus, iconName: "square.stack.3d.up.fill", accentColor: Color(.systemBrown))
                                AuditLogEntryDetailFieldRow(title: "Export", value: log.exportStatus, iconName: "square.and.arrow.up.fill", accentColor: Color(.systemBrown))
                                AuditLogEntryDetailFieldRow(title: "Archived", value: log.archived ? "YES" : "NO", iconName: "archivebox.fill", accentColor: log.archived ? .gray : .green)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        if !log.errorMessage.isEmpty {
                            AuditLogEntryDetailFieldRow(title: "Error Message", value: log.errorMessage, iconName: "exclamationmark.triangle.fill", accentColor: .red)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Review and Comments")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 10) {
                        AuditLogEntryDetailFieldRow(title: "Reviewed By", value: log.reviewedBy, iconName: "eye.fill", accentColor: .orange)
                        AuditLogEntryDetailFieldRow(title: "Review Date", value: log.reviewDate, iconName: "calendar.badge.checkmark", accentColor: .orange)
                        AuditLogEntryDetailFieldRow(title: "Comments", value: log.comments.isEmpty ? "N/A" : log.comments, iconName: "bubble.left.and.bubble.right.fill", accentColor: .orange)
                        AuditLogEntryDetailFieldRow(title: "Tags", value: log.tags.isEmpty ? "N/A" : log.tags.joined(separator: ", "), iconName: "paperclip", accentColor: .orange)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Log Details")
        }
    }
}

@available(iOS 14.0, *)
extension AuditLogEntryDetailFieldRow {
    init(title: String, value: Date, iconName: String, accentColor: Color) {
        self.title = title
        self.value = dateFormatter.string(from: value)
        self.iconName = iconName
        self.accentColor = accentColor
    }
}
