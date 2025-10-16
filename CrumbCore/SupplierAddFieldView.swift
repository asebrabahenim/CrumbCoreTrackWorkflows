import SwiftUI
import Combine

@available(iOS 14.0, *)
struct SupplierAddFieldView: View {
    let title: String
    let iconName: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isRequired: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title + (isRequired ? " *" : ""))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(text.isEmpty ? .secondary : .accentColor)
                .offset(y: -25)
                .scaleEffect( 0.85, anchor: .leading)
                .animation(.easeInOut(duration: 0.2), value: text.isEmpty)

            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.secondary)
                    .frame(width: 20)

                TextField("", text: $text)
                    .keyboardType(keyboardType)
                    .disableAutocorrection(true)
            }
            .padding(.top, -8)

            Divider()
                .background(text.isEmpty ? Color.gray.opacity(0.5) : Color.accentColor)
        }
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct SupplierAddNumericFieldView: View {
    let title: String
    let iconName: String
    @Binding var value: String
    var unit: String = ""
    var isRequired: Bool = false

    var body: some View {
        SupplierAddFieldView(
            title: title,
            iconName: iconName,
            text: $value,
            keyboardType: .decimalPad,
            isRequired: isRequired
        )
    }
}

@available(iOS 14.0, *)
struct SupplierAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date
    var isRequired: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title + (isRequired ? " *" : ""))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.accentColor)
                .scaleEffect(0.85, anchor: .leading)

            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.secondary)
                    .frame(width: 20)

                DatePicker(
                    title,
                    selection: $date,
                    displayedComponents: [.date]
                )
                .labelsHidden()
                .padding(.vertical, -4)
                
            }
            
            Divider()
                .background(Color.accentColor)
        }
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct SupplierAddToggleView: View {
    let title: String
    let iconName: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.secondary)
                .frame(width: 20)

            Text(title)
                .font(.body)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .accentColor(Color.accentColor)
        }
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct SupplierAddSectionHeaderView: View {
    let title: String
    let iconName: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(color)
            Text(title)
                .font(.headline)
                .foregroundColor(color)
            Spacer()
        }
        .padding(.top, 15)
        .padding(.bottom, 5)
    }
}

@available(iOS 14.0, *)
struct SupplierAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataStore: BiscuitFactoryDataStore

    @State private var supplierCode: String = ""
    @State private var name: String = ""
    @State private var contactPerson: String = ""
    @State private var contactNumber: String = ""
    @State private var email: String = ""
    @State private var address: String = ""
    @State private var city: String = ""
    @State private var region: String = ""
    @State private var postalCode: String = ""
    @State private var country: String = ""
    @State private var paymentTerms: String = "30 Days"
    @State private var deliveryTimeDaysString: String = ""
    @State private var preferred: Bool = false
    @State private var website: String = ""
    @State private var taxID: String = ""
    @State private var bankName: String = ""
    @State private var accountNumber: String = ""
    @State private var branchCode: String = ""
    @State private var swiftCode: String = ""
    @State private var creditLimitString: String = ""
    @State private var outstandingBalanceString: String = ""
    @State private var notes: String = ""
    @State private var reliabilityScoreString: String = ""

    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSuccess = false

    private func validateAndSave() {
        var errors: [String] = []

        if supplierCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Supplier Code is required.") }
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Name is required.") }
        if contactPerson.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Contact Person is required.") }
        if contactNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Contact Number is required.") }
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Email is required.") }
        if address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Address is required.") }
        if city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("City is required.") }
        if country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Country is required.") }
        
        let deliveryTime = Int(deliveryTimeDaysString) ?? -1
        if deliveryTime < 0 { errors.append("Delivery Time must be a valid number.") }
        
        let creditLimit = Double(creditLimitString) ?? -1.0
        if creditLimit < 0.0 { errors.append("Credit Limit must be a valid amount.") }
        
        let outstandingBalance = Double(outstandingBalanceString) ?? -1.0
        if outstandingBalance < 0.0 { errors.append("Outstanding Balance must be a valid amount.") }
        
        let reliabilityScore = Int(reliabilityScoreString) ?? -1
        if reliabilityScore < 0 || reliabilityScore > 100 { errors.append("Reliability Score must be between 0 and 100.") }


        if errors.isEmpty {
            let newSupplier = Supplier(
                supplierCode: supplierCode,
                name: name,
                contactPerson: contactPerson,
                contactNumber: contactNumber,
                email: email,
                address: address,
                city: city,
                region: region,
                postalCode: postalCode,
                country: country,
                materialsSupplied: ["Flour", "Sugar"],
                rating: 5.0,
                paymentTerms: paymentTerms,
                deliveryTimeDays: deliveryTime,
                preferred: preferred,
                lastDeliveryDate: Date(),
                nextExpectedDelivery: Calendar.current.date(byAdding: .day, value: deliveryTime, to: Date())!,
                notes: notes,
                website: website,
                taxID: taxID,
                bankName: bankName,
                accountNumber: accountNumber,
                branchCode: branchCode,
                swiftCode: swiftCode,
                creditLimit: creditLimit,
                outstandingBalance: outstandingBalance,
                createdAt: Date(),
                updatedAt: Date(),
                createdBy: "Current User",
                lastContacted: Date(),
                tags: ["new", "added"],
                documents: ["NDA.pdf"],
                imageName: "building.2.crop.circle.fill",
                activeStatus: true,
                reliabilityScore: reliabilityScore
            )
            dataStore.addSupplier(newSupplier)
            isSuccess = true
            alertMessage = "New Supplier **\(name)** (\(supplierCode)) has been successfully added to the system."
        } else {
            isSuccess = false
            alertMessage = "Failed to add supplier due to the following errors:\n\n- " + errors.joined(separator: "\n- ")
        }

        showAlert = true
    }
    
    private func handleDismissal() {
        if isSuccess {
            presentationMode.wrappedValue.dismiss()
        } else {
            showAlert = false
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    SupplierAddSectionHeaderView(
                        title: "Primary Details",
                        iconName: "building.fill",
                        color: .blue
                    )
                    .padding(.horizontal)

                    VStack(spacing: 15) {
                        SupplierAddFieldView(title: "Supplier Code", iconName: "key.fill", text: $supplierCode, isRequired: true)
                        SupplierAddFieldView(title: "Supplier Name", iconName: "bag.fill", text: $name, isRequired: true)
                        SupplierAddFieldView(title: "Website", iconName: "link", text: $website)
                        SupplierAddFieldView(title: "Tax ID", iconName: "doc.text.fill", text: $taxID)
                    }
                    .padding(.horizontal)
                    
                    SupplierAddSectionHeaderView(
                        title: "Contact Information",
                        iconName: "phone.fill.badge.checkmark",
                        color: .green
                    )
                    .padding(.horizontal)

                    VStack(spacing: 15) {
                        SupplierAddFieldView(title: "Contact Person", iconName: "person.crop.circle.fill", text: $contactPerson, isRequired: true)
                        SupplierAddFieldView(title: "Contact Number", iconName: "phone.fill", text: $contactNumber, keyboardType: .phonePad, isRequired: true)
                        SupplierAddFieldView(title: "Email", iconName: "envelope.fill", text: $email, keyboardType: .emailAddress, isRequired: true)
                    }
                    .padding(.horizontal)
                    
                    SupplierAddSectionHeaderView(
                        title: "Address & Location",
                        iconName: "map.fill",
                        color: .orange
                    )
                    .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        SupplierAddFieldView(title: "Street Address", iconName: "house.fill", text: $address, isRequired: true)
                        HStack {
                            SupplierAddFieldView(title: "City", iconName: "location.fill", text: $city, isRequired: true)
                            SupplierAddFieldView(title: "Region", iconName: "globe", text: $region, isRequired: false)
                        }
                        HStack {
                            SupplierAddFieldView(title: "Postal Code", iconName: "mappin.and.ellipse", text: $postalCode, isRequired: false)
                            SupplierAddFieldView(title: "Country", iconName: "flag.fill", text: $country, isRequired: true)
                        }
                    }
                    .padding(.horizontal)
                    
                    SupplierAddSectionHeaderView(
                        title: "Financial & Terms",
                        iconName: "banknote.fill",
                        color: .purple
                    )
                    .padding(.horizontal)

                    VStack(spacing: 15) {
                        
                        Picker("Payment Terms", selection: $paymentTerms) {
                            Text("7 Days").tag("7 Days")
                            Text("15 Days").tag("15 Days")
                            Text("30 Days").tag("30 Days")
                            Text("60 Days").tag("60 Days")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)

                        HStack {
                            SupplierAddNumericFieldView(title: "Credit Limit (PKR)", iconName: "dollarsign.circle.fill", value: $creditLimitString, isRequired: true)
                            SupplierAddNumericFieldView(title: "Outstanding Balance (PKR)", iconName: "arrow.up.circle.fill", value: $outstandingBalanceString, isRequired: true)
                        }
                        
                        HStack {
                            SupplierAddNumericFieldView(title: "Delivery Time (Days)", iconName: "truck.box.fill", value: $deliveryTimeDaysString, isRequired: true)
                            SupplierAddNumericFieldView(title: "Reliability Score (0-100)", iconName: "checkmark.seal.fill", value: $reliabilityScoreString, isRequired: true)
                        }
                        
                        HStack {
                            SupplierAddFieldView(title: "Bank Name", iconName: "banknote.fill", text: $bankName)
                            SupplierAddFieldView(title: "Account Number", iconName: "number.circle.fill", text: $accountNumber)
                        }
                        HStack {
                            SupplierAddFieldView(title: "Branch Code", iconName: "building.columns.fill", text: $branchCode)
                            SupplierAddFieldView(title: "Swift Code", iconName: "doc.text.magnifyingglass", text: $swiftCode)
                        }
                        
                        SupplierAddToggleView(title: "Preferred Supplier", iconName: "heart.fill", isOn: $preferred)
                            .padding(.horizontal)

                        SupplierAddFieldView(title: "Internal Notes", iconName: "pencil.and.outline", text: $notes)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    
                    Button(action: validateAndSave) {
                        Text("Save New Supplier")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                            .shadow(color: Color.accentColor.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .padding()
                    .padding(.top, 20)


                }
                .padding(.bottom, 50)
            }
            .navigationTitle("New Supplier Setup")
            .background(Color(.systemGroupedBackground))
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(isSuccess ? "Success" : "Validation Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"), action: handleDismissal)
                )
            }

        }
    }
}

@available(iOS 14.0, *)
struct SupplierListRowView: View {
    let supplier: Supplier
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: supplier.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
                    .foregroundColor(supplier.preferred ? .red : .blue)
                    .padding(10)
                    .background(supplier.preferred ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(supplier.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Text("\(supplier.city), \(supplier.country)")
                        .font(.caption)
                        .foregroundColor(.orange)
                    
                    HStack(spacing: 4) {
                        Text(supplier.supplierCode)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(4)
                        
                        if supplier.preferred {
                            Label("Preferred", systemImage: "heart.fill")
                                .font(.caption2)
                                .padding(4)
                                .background(Color.pink.opacity(0.15))
                                .cornerRadius(5)
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", supplier.rating))
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    
                    Text(supplier.activeStatus ? "Active" : "Inactive")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(supplier.activeStatus ? Color.green : Color.red)
                        .cornerRadius(8)
                }
            }
            
            Divider()
            
            // MARK: Key Metrics
            HStack(spacing: 12) {
                SupplierListAttributeView(icon: "banknote.fill", label: "Credit", value: "PKR \(String(format: "%.0f", supplier.creditLimit))", color: .purple)
                SupplierListAttributeView(icon: "exclamationmark.triangle.fill", label: "Balance", value: "PKR \(String(format: "%.0f", supplier.outstandingBalance))", color: .orange)
                SupplierListAttributeView(icon: "clock.fill", label: "Delivery", value: "\(supplier.deliveryTimeDays) days", color: Color(red: 0.0, green: 0.6, blue: 0.6))
                SupplierListAttributeView(icon: "checkmark.seal.fill", label: "Reliability", value: "\(supplier.reliabilityScore)%", color: .green)
            }
            .padding(.horizontal, 4)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Label(supplier.contactPerson, systemImage: "person.crop.circle.fill")
                    Spacer()
                    Label(supplier.contactNumber, systemImage: "phone.fill")
                }
                .font(.caption)
                
                if !supplier.email.isEmpty {
                    Label(supplier.email, systemImage: "envelope.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if !supplier.website.isEmpty {
                    Label(supplier.website, systemImage: "globe")
                        .font(.caption2)
                        .foregroundColor(.blue)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(supplier.address)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Label(supplier.bankName, systemImage: "building.columns")
                    Spacer()
                    Text("Acct: \(supplier.accountNumber)")
                        .font(.caption2)
                }
                .font(.caption2)
                
                HStack {
                    Text("Branch: \(supplier.branchCode)")
                    Spacer()
                    Text("SWIFT: \(supplier.swiftCode)")
                }
                .font(.caption2)
                .foregroundColor(.gray)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Label("Last Delivery: \(dateFormatter.string(from: supplier.lastDeliveryDate))", systemImage: "truck.box.fill")
                    Spacer()
                    Label("Next: \(dateFormatter.string(from: supplier.nextExpectedDelivery))", systemImage: "calendar")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
                
                HStack {
                    Label("Last Contact: \(dateFormatter.string(from: supplier.lastContacted))", systemImage: "bubble.left.fill")
                    Spacer()
                    Text("Created by \(supplier.createdBy)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            if !supplier.tags.isEmpty || !supplier.materialsSupplied.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    if !supplier.materialsSupplied.isEmpty {
                        Text("Materials: \(supplier.materialsSupplied.joined(separator: ", "))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    if !supplier.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(supplier.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption2)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(5)
                                }
                            }
                        }
                    }
                }
            }
            
            if !supplier.notes.isEmpty {
                Divider()
                Text("Note: \(supplier.notes)")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Divider()
            HStack {
                Text("Created: \(dateFormatter.string(from: supplier.createdAt))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Updated: \(dateFormatter.string(from: supplier.updatedAt))")
                    .font(.caption2)
                    .foregroundColor(.accentColor)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}


@available(iOS 14.0, *)
struct SupplierListAttributeView: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
    }
}

@available(iOS 14.0, *)
struct SupplierSearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? .secondary : .accentColor)
                .padding(.leading, 8)
                .animation(.linear(duration: 0.1), value: searchText.isEmpty)
            
            TextField("Search by Name or Code...", text: $searchText)
                .foregroundColor(.primary)
                .padding(.vertical, 10)
            
            if !searchText.isEmpty {
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct SupplierNoDataView: View {
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "truck.box.badgeless")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.secondary)
                .opacity(0.6)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
        }
        .padding(.top, 50)
    }
}

@available(iOS 14.0, *)
struct SupplierListView: View {
    @ObservedObject var dataStore: BiscuitFactoryDataStore
    @State private var searchText = ""
    @State private var showingAddSupplier = false
    
    var filteredSuppliers: [Supplier] {
        if searchText.isEmpty {
            return dataStore.suppliers
        } else {
            return dataStore.suppliers.filter { supplier in
                supplier.name.localizedCaseInsensitiveContains(searchText) ||
                supplier.supplierCode.localizedCaseInsensitiveContains(searchText) ||
                supplier.city.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func deleteSupplier(at offsets: IndexSet) {
        dataStore.deleteSupplier(at: offsets)
    }

    var body: some View {
            VStack {
                SupplierSearchBarView(searchText: $searchText)
                
                if filteredSuppliers.isEmpty {
                    SupplierNoDataView(
                        title: "No Suppliers Found",
                        message: searchText.isEmpty ? "Tap '+' to add your first supplier." : "Try a different search term or add a new supplier."
                    )
                } else {
                    List {
                        ForEach(filteredSuppliers) { supplier in
                            NavigationLink(destination: SupplierDetailView(supplier: supplier)) {
                                SupplierListRowView(supplier: supplier)
                                    .padding(.vertical, 5)
                            }
                            .listRowInsets(EdgeInsets())
                            .background(Color(.systemGroupedBackground))
                        }
                        .onDelete(perform: deleteSupplier)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Suppliers")
            .navigationBarItems(trailing:
                Button(action: {
                    showingAddSupplier = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                }
            )
            .sheet(isPresented: $showingAddSupplier) {
                SupplierAddView( dataStore: dataStore)
            }
        
    }
}

@available(iOS 14.0, *)
struct SupplierDetailFieldRow: View {
    let icon: String
    let label: String
    let value: String
    var iconColor: Color = .blue
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundColor(iconColor)
            
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding(.vertical, 5)
    }
}

@available(iOS 14.0, *)
struct SupplierDetailHeader: View {
    let title: String
    let iconName: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(color)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Rectangle()
                .frame(height: 1)
                .foregroundColor(color.opacity(0.3))
        }
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct SupplierDetailView: View {
    let supplier: Supplier
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formattedDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: supplier.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .padding(15)
                            .background(supplier.preferred ? Color.red : Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5, x: 0, y: 3)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(supplier.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Text(supplier.supplierCode)
                                    .font(.title3)
                                    .fontWeight(.light)
                                    .foregroundColor(.secondary)
                                
                                Text("R:\(supplier.reliabilityScore)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.yellow.opacity(0.2))
                                    .cornerRadius(6)
                                
                                Image(systemName: supplier.preferred ? "heart.fill" : "heart")
                                    .foregroundColor(.red)
                            }
                        }
                        Spacer()
                    }
                    
                    Text(supplier.address + ", " + supplier.city + ", " + supplier.country)
                        .font(.callout)
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                }
                .padding(.horizontal)
                
                Divider()
                
                SupplierDetailHeader(title: "Contact & Location", iconName: "mappin.and.ellipse", color: .green)
                    .padding(.horizontal)
                
                VStack(spacing: 10) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 10) {
                            SupplierDetailFieldRow(icon: "person.text.rectangle.fill", label: "Contact Person", value: supplier.contactPerson, iconColor: .green)
                            SupplierDetailFieldRow(icon: "phone.fill", label: "Contact Number", value: supplier.contactNumber, iconColor: .green)
                            SupplierDetailFieldRow(icon: "envelope.fill", label: "Email", value: supplier.email, iconColor: .green)
                            SupplierDetailFieldRow(icon: "link", label: "Website", value: supplier.website.isEmpty ? "N/A" : supplier.website, iconColor: .green)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            SupplierDetailFieldRow(icon: "location.fill", label: "City", value: supplier.city, iconColor: .green)
                            SupplierDetailFieldRow(icon: "globe", label: "Region", value: supplier.region, iconColor: .green)
                            SupplierDetailFieldRow(icon: "flag.fill", label: "Country", value: supplier.country, iconColor: .green)
                            SupplierDetailFieldRow(icon: "mappin.circle.fill", label: "Postal Code", value: supplier.postalCode, iconColor: .green)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                SupplierDetailHeader(title: "Financial & Supply Terms", iconName: "creditcard.fill", color: .purple)
                    .padding(.horizontal)
                
                VStack(spacing: 10) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 10) {
                            SupplierDetailFieldRow(icon: "dollarsign.circle.fill", label: "Credit Limit", value: "PKR \(String(format: "%.2f", supplier.creditLimit))", iconColor: .purple)
                            SupplierDetailFieldRow(icon: "arrow.down.left.circle.fill", label: "Outstanding Balance", value: "PKR \(String(format: "%.2f", supplier.outstandingBalance))", iconColor: .purple)
                            SupplierDetailFieldRow(icon: "doc.text.fill", label: "Payment Terms", value: supplier.paymentTerms, iconColor: .purple)
                            SupplierDetailFieldRow(icon: "clock.fill", label: "Delivery Time", value: "\(supplier.deliveryTimeDays) Days", iconColor: .purple)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            SupplierDetailFieldRow(icon: "banknote.fill", label: "Bank Name", value: supplier.bankName.isEmpty ? "N/A" : supplier.bankName, iconColor: .purple)
                            SupplierDetailFieldRow(icon: "number.circle.fill", label: "Account Number", value: supplier.accountNumber.isEmpty ? "N/A" : supplier.accountNumber, iconColor: .purple)
                            SupplierDetailFieldRow(icon: "building.columns.fill", label: "Branch Code", value: supplier.branchCode.isEmpty ? "N/A" : supplier.branchCode, iconColor: .purple)
                            SupplierDetailFieldRow(icon: "doc.text.magnifyingglass", label: "SWIFT Code", value: supplier.swiftCode.isEmpty ? "N/A" : supplier.swiftCode, iconColor: .purple)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                SupplierDetailHeader(title: "Timeline & Metadata", iconName: "calendar.badge.clock", color: .orange)
                    .padding(.horizontal)
                
                VStack(spacing: 10) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 10) {
                            SupplierDetailFieldRow(icon: "calendar.badge.clock", label: "Last Delivery Date", value: formattedDate(supplier.lastDeliveryDate), iconColor: .orange)
                            SupplierDetailFieldRow(icon: "calendar.badge.plus", label: "Next Expected Delivery", value: formattedDate(supplier.nextExpectedDelivery), iconColor: .orange)
                            SupplierDetailFieldRow(icon: "calendar", label: "Last Contacted", value: formattedDate(supplier.lastContacted), iconColor: .orange)
                            SupplierDetailFieldRow(icon: "person.fill", label: "Created By", value: supplier.createdBy, iconColor: .orange)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            SupplierDetailFieldRow(icon: "tag.circle.fill", label: "Tags", value: supplier.tags.joined(separator: ", ").isEmpty ? "None" : supplier.tags.joined(separator: ", "), iconColor: .orange)
                            SupplierDetailFieldRow(icon: "list.bullet.rectangle.fill", label: "Materials Supplied", value: supplier.materialsSupplied.joined(separator: ", ").isEmpty ? "None" : supplier.materialsSupplied.joined(separator: ", "), iconColor: .orange)
                            SupplierDetailFieldRow(icon: "note.text.badge.plus", label: "Documents", value: supplier.documents.joined(separator: ", ").isEmpty ? "None" : supplier.documents.joined(separator: ", "), iconColor: .orange)
                            SupplierDetailFieldRow(icon: "pin.fill", label: "Created At", value: formattedDateTime(supplier.createdAt), iconColor: .orange)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Divider()
                    SupplierDetailFieldRow(icon: "text.bubble.fill", label: "Notes", value: supplier.notes.isEmpty ? "None" : supplier.notes, iconColor: .gray)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                
            }
            .padding(.bottom, 40)
        }
        .navigationTitle(supplier.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


