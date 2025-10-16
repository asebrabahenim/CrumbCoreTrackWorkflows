

import SwiftUI
import Combine




@available(iOS 14.0, *)
struct InventoryItemAddFieldView: View {
    let title: String
    let iconName: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.blue)
                    .frame(width: 20)
            
            }
            .offset(y: 0)
            
            TextField(title, text: $text)
                .padding(.top, 0)
                .padding(.bottom, 5)
                .keyboardType(title.contains("Number") || title.contains("Price") || title.contains("Level") || title.contains("Quantity") || title.contains("Grams") || title.contains("Liters") ? .numbersAndPunctuation : .default)
            
            Divider()
                .background(text.isEmpty ? Color.gray.opacity(0.3) : Color.blue)
        }
        .padding(.top, 10)
        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
    }
}

@available(iOS 14.0, *)
struct InventoryItemAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date

    var body: some View {
        HStack(spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.top, -10)
        }
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct InventoryItemAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.white)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Color.orange.opacity(0.8))
        .cornerRadius(10)
        .padding(.top, 15)
    }
}

// MARK: - InventoryItemAddView

@available(iOS 14.0, *)
struct InventoryItemAddView: View {
    @ObservedObject var dataStore: BiscuitFactoryDataStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var itemCode: String = ""
    @State private var name: String = ""
    @State private var category: String = ""
    @State private var subCategory: String = ""
    @State private var unit: String = ""
    @State private var quantity: String = ""
    @State private var minStockLevel: String = ""
    @State private var maxStockLevel: String = ""
    @State private var reorderQuantity: String = ""
    @State private var supplierName: String = ""
    @State private var supplierContact: String = ""
    @State private var purchasePrice: String = ""
    @State private var batchNumber: String = ""
    @State private var location: String = ""
    @State private var storageCondition: String = ""
    @State private var status: String = ""
    @State private var notes: String = ""
    @State private var barcode: String = ""
    @State private var brand: String = ""
    @State private var weightGrams: String = ""
    @State private var volumeLiters: String = ""
    @State private var createdBy: String = ""
    @State private var unitCost: String = ""
    @State private var tags: String = ""

    // Date fields
    @State private var dateReceived: Date = Date()
    @State private var expiryDate: Date = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
    @State private var lastChecked: Date = Date()
    @State private var lastUsedDate: Date = Date()

    // Boolean fields
    @State private var isActive: Bool = true

    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    private func validateAndSave() {
        var errors: [String] = []

        let requiredText: [(String, String)] = [
            (itemCode, "Item Code"), (name, "Name"), (category, "Category"), (unit, "Unit"),
            (supplierName, "Supplier Name"), (location, "Location"), (storageCondition, "Storage Condition"),
            (brand, "Brand"), (createdBy, "Created By"), (status, "Status")
        ]
        
        for (value, fieldName) in requiredText where value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("\(fieldName) is required.")
        }

        let numericFields: [(String, String)] = [
            (quantity, "Quantity"), (minStockLevel, "Min Stock Level"), (maxStockLevel, "Max Stock Level"),
            (reorderQuantity, "Reorder Quantity"), (purchasePrice, "Purchase Price"), (weightGrams, "Weight (Grams)"),
            (volumeLiters, "Volume (Liters)"), (unitCost, "Unit Cost")
        ]

        for (value, fieldName) in numericFields {
            if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errors.append("\(fieldName) is required.")
            } else if Double(value) == nil {
                 errors.append("\(fieldName) must be a valid number.")
            }
        }
        
        if expiryDate <= dateReceived {
            errors.append("Expiry Date must be after Date Received.")
        }

        if errors.isEmpty {
            saveItem()
            alertTitle = "Success"
            alertMessage = "New Inventory Item '\(name)' added successfully."
        } else {
            alertTitle = "Validation Failed"
            alertMessage = "Please correct the following errors:\n\n• " + errors.joined(separator: "\n• ")
        }
        
        showAlert = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if alertTitle == "Success" {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func saveItem() {
        let quantityInt = Int(quantity) ?? 0
        let purchasePriceDouble = Double(purchasePrice) ?? 0.0
        let unitCostDouble = Double(unitCost) ?? 0.0
        
        let newItem = InventoryItem(
            itemCode: itemCode,
            name: name,
            category: category,
            subCategory: subCategory,
            unit: unit,
            quantity: quantityInt,
            minStockLevel: Int(minStockLevel) ?? 0,
            maxStockLevel: Int(maxStockLevel) ?? 0,
            reorderQuantity: Int(reorderQuantity) ?? 0,
            supplierName: supplierName,
            supplierContact: supplierContact,
            purchasePrice: purchasePriceDouble,
            totalValue: purchasePriceDouble * Double(quantityInt),
            batchNumber: batchNumber.isEmpty ? "AUTO-\(UUID().uuidString.prefix(4))" : batchNumber,
            dateReceived: dateReceived,
            expiryDate: expiryDate,
            location: location,
            storageCondition: storageCondition,
            status: status,
            notes: notes,
            imageName: "box.truck.fill",
            barcode: barcode,
            brand: brand,
            weightGrams: Int(weightGrams) ?? 0,
            volumeLiters: Double(volumeLiters) ?? 0.0,
            lastChecked: lastChecked,
            isActive: isActive,
            createdBy: createdBy,
            createdAt: Date(),
            updatedAt: Date(),
            tags: tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
            usageFrequency: 0,
            unitCost: unitCostDouble,
            lastUsedDate: lastUsedDate
        )
        
        dataStore.addInventoryItem(newItem)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    
                    InventoryItemAddSectionHeaderView(title: "General Item Details", iconName: "info.circle.fill")
                    
                    VStack(alignment: .leading, spacing: 20) {
                        InventoryItemAddFieldView(title: "Item Code (SKU)", iconName: "barcode", text: $itemCode)
                        InventoryItemAddFieldView(title: "Item Name", iconName: "tag.fill", text: $name)
                        InventoryItemAddFieldView(title: "Category", iconName: "folder.fill", text: $category)
                        InventoryItemAddFieldView(title: "Sub Category", iconName: "doc.text.fill", text: $subCategory)
                        InventoryItemAddFieldView(title: "Brand Name", iconName: "building.2.fill", text: $brand)
                        InventoryItemAddFieldView(title: "Unit (e.g., kg, L)", iconName: "ruler.fill", text: $unit)
                        InventoryItemAddFieldView(title: "Barcode", iconName: "qrcode.viewfinder", text: $barcode)
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 20)

                    InventoryItemAddSectionHeaderView(title: "Stock & Logistics", iconName: "cube.box.fill")
                        .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 20) {
                            InventoryItemAddFieldView(title: "Quantity", iconName: "number", text: $quantity)
                            InventoryItemAddFieldView(title: "Batch Number", iconName: "shippingbox.fill", text: $batchNumber)
                        }
                        
                        InventoryItemAddFieldView(title: "Location", iconName: "mappin.and.ellipse", text: $location)
                        InventoryItemAddFieldView(title: "Storage Condition", iconName: "thermometer.sun.fill", text: $storageCondition)
                        InventoryItemAddFieldView(title: "Status (e.g., Available)", iconName: "checkmark.circle.fill", text: $status)
                        
                        HStack(spacing: 20) {
                            InventoryItemAddFieldView(title: "Min Stock Level", iconName: "arrow.down.square.fill", text: $minStockLevel)
                            InventoryItemAddFieldView(title: "Max Stock Level", iconName: "arrow.up.square.fill", text: $maxStockLevel)
                        }
                        
                        InventoryItemAddFieldView(title: "Reorder Quantity", iconName: "arrow.clockwise.square.fill", text: $reorderQuantity)
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 20)

                    InventoryItemAddSectionHeaderView(title: "Financials & Supplier", iconName: "truck.box.fill")
                        .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        InventoryItemAddFieldView(title: "Supplier Name", iconName: "person.3.fill", text: $supplierName)
                        InventoryItemAddFieldView(title: "Supplier Contact", iconName: "phone.fill", text: $supplierContact)
                        HStack(spacing: 20) {
                            InventoryItemAddFieldView(title: "Purchase Price (Total)", iconName: "dollarsign.circle.fill", text: $purchasePrice)
                            InventoryItemAddFieldView(title: "Unit Cost", iconName: "dollarsign.square.fill", text: $unitCost)
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 20)

                    InventoryItemAddSectionHeaderView(title: "Physical Details & Notes", iconName: "scalemass.fill")
                        .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 20) {
                            InventoryItemAddFieldView(title: "Weight (Grams)", iconName: "scalemass.fill", text: $weightGrams)
                            InventoryItemAddFieldView(title: "Volume (Liters)", iconName: "drop.fill", text: $volumeLiters)
                        }
                        InventoryItemAddFieldView(title: "Notes", iconName: "note.text", text: $notes)
                        InventoryItemAddFieldView(title: "Tags (comma separated)", iconName: "list.bullet.indent", text: $tags)
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 20)
                    
                    InventoryItemAddSectionHeaderView(title: "Date Tracking", iconName: "calendar")
                        .padding(.top, 10)

                    VStack(spacing: 15) {
                        InventoryItemAddDatePickerView(title: "Date Received", iconName: "square.and.arrow.down.fill", date: $dateReceived)
                        InventoryItemAddDatePickerView(title: "Expiry Date", iconName: "xmark.octagon.fill", date: $expiryDate)
                        InventoryItemAddDatePickerView(title: "Last Checked", iconName: "checkmark.circle.badge.questionmark.fill", date: $lastChecked)
                        InventoryItemAddDatePickerView(title: "Last Used Date", iconName: "arrow.up.left.circle.fill", date: $lastUsedDate)
                        
                        HStack {
                            Text("Item Active")
                                .foregroundColor(.secondary)
                            Spacer()
                            Toggle("", isOn: $isActive)
                                .labelsHidden()
                        }
                        .padding(.horizontal)
                        
                        InventoryItemAddFieldView(title: "Created By", iconName: "person.badge.shield.checkmark.fill", text: $createdBy)
                    }.padding(.top,10)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 40)
                    
                    Button(action: validateAndSave) {
                        Text("Save New Inventory Item")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 50)
                }
            }
            .navigationTitle("Add New Item")
            .background(Color(UIColor.systemGroupedBackground))
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    if self.alertTitle == "Success" {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
            }
        }
    }
}

// MARK: - InventoryItemListView Components

@available(iOS 14.0, *)
struct InventoryItemSearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? .gray : .blue)
                .padding(.leading, 8)
                .transition(.scale)
            
            TextField("Search by Name, Code, or Supplier...", text: $searchText)
                .foregroundColor(.primary)
                .padding(.vertical, 10)
                .padding(.trailing, 8)
            
            if !searchText.isEmpty {
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
                .transition(.opacity)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 5)
        .animation(.easeInOut(duration: 0.2), value: searchText.isEmpty)
    }
}

@available(iOS 14.0, *)
struct InventoryItemNoDataView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "archivebox.fill")
                .font(.system(size: 80))
                .foregroundColor(.gray)
                .opacity(0.6)
            
            Text("No Inventory Found")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Text("Try refining your search or add a new item to the inventory.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 100)
    }
}

@available(iOS 14.0, *)
struct InventoryItemListRowView: View {
    let item: InventoryItem
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    private func formattedCurrency(_ value: Double) -> String {
        return "$\(String(format: "%.2f", value))"
    }
    
    var body: some View {
        VStack(spacing: 12) {
            
            HStack(alignment: .top) {
                Image(systemName: item.isActive ? "checkmark.seal.fill" : "xmark.seal.fill")
                    .foregroundColor(item.isActive ? .green : .red)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                    
                    Text("\(item.category) | \(item.subCategory)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(item.itemCode)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    
                    Text(item.status)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(5)
                        .background(item.quantity > item.minStockLevel ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                        .foregroundColor(item.quantity > item.minStockLevel ? .green : .red)
                        .cornerRadius(6)
                }
            }
            .padding(.horizontal)
            .padding(.top)

            Divider()
                .padding(.horizontal)
            
            HStack(spacing: 10) {
                InventoryItemMetricView(
                    iconName: "chart.bar.fill",
                    label: "In Stock",
                    value: "\(item.quantity) \(item.unit)",
                    color: .blue
                )
                
                InventoryItemMetricView(
                    iconName: "dollarsign.square.fill",
                    label: "Unit Cost",
                    value: formattedCurrency(item.unitCost),
                    color: .green
                )
                
                InventoryItemMetricView(
                    iconName: "mappin.circle.fill",
                    label: "Location",
                    value: item.location,
                    color: .purple
                )
            }
            .padding(.horizontal)
            
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(.orange)
                    Text("Supplier: **\(item.supplierName)**")
                    Spacer()
                    Image(systemName: "scalemass.fill")
                        .foregroundColor(Color(.systemBrown))
                    Text("Weight: **\(item.weightGrams)g**")
                }
                
                HStack {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .foregroundColor(.red)
                    Text("Expiry: **\(formattedDate(item.expiryDate))**")
                    Spacer()
                    Image(systemName: "arrow.down.to.line.alt")
                        .foregroundColor(Color(red: 0.3, green: 0.9, blue: 1.0))
                    Text("Min Level: **\(item.minStockLevel)**")
                }
            }
            .font(.footnote)
            .padding(.horizontal)
            .padding(.bottom)
            .background(Color.gray.opacity(0.05))
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 5)
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct InventoryItemMetricView: View {
    let iconName: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: iconName)
                    .font(.caption)
                    .foregroundColor(color)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - InventoryItemListView

@available(iOS 14.0, *)
struct InventoryItemListView: View {
    @ObservedObject var dataStore: BiscuitFactoryDataStore
    @State private var searchText: String = ""
    @State private var isShowingAddView: Bool = false
    
    var filteredItems: [InventoryItem] {
        if searchText.isEmpty {
            return dataStore.inventoryItems
        } else {
            return dataStore.inventoryItems.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.itemCode.localizedCaseInsensitiveContains(searchText) ||
                item.supplierName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        dataStore.deleteInventoryItem(at: offsets)
    }

    var body: some View {
            VStack(spacing: 0) {
                
                InventoryItemSearchBarView(searchText: $searchText)
                
                if filteredItems.isEmpty {
                    InventoryItemNoDataView()
                        .overlay(
                            searchText.isEmpty ? nil : Text("No results for '\(searchText)'")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .offset(y: 100)
                        )
                } else {
                    List {
                        ForEach(filteredItems) { item in
                            NavigationLink(destination: InventoryItemDetailView(item: item)) {
                                InventoryItemListRowView(item: item)
                                    .listRowInsets(EdgeInsets())
                                    .listRowBackground(Color.clear)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Inventory Stock")
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarItems(trailing:
                Button(action: {
                    isShowingAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            )
            .sheet(isPresented: $isShowingAddView) {
                InventoryItemAddView(dataStore: dataStore)
            }
        
    }
}


@available(iOS 14.0, *)
struct InventoryItemDetailFieldRow: View {
    let iconName: String
    let label: String
    let value: String
    let valueColor: Color

    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                Text(label)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(value)
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(valueColor)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct InventoryItemDetailBlock<Content: View>: View {
    let title: String
    let iconName: String
    let content: Content
    
    init(title: String, iconName: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.iconName = iconName
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.white)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color(red: 0.3, green: 0.3, blue: 0.9).opacity(0.8))
            .cornerRadius(10)
            
            VStack(spacing: 0) {
                content
            }
            .padding(.horizontal, 10)
            .background(Color.white)
            .cornerRadius(10)
        }
        .padding(.vertical, 10)
    }
}


@available(iOS 14.0, *)
struct InventoryItemDetailView: View {
    let item: InventoryItem
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formattedCurrency(_ value: Double) -> String {
        return "$\(String(format: "%.2f", value))"
    }

    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "available": return .green
        case "low stock": return .orange
        case "out of stock": return .red
        default: return .blue
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .center, spacing: 15) {
                    Image(systemName: item.imageName)
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                        .padding(20)
                        .background(statusColor(item.status))
                        .clipShape(Circle())
                        .shadow(radius: 10)
                    
                    Text(item.name)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                    
                    Text("SKU: \(item.itemCode) | Status: \(item.status)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(item.notes.isEmpty ? "No specific notes." : item.notes)
                        .font(.caption)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                
                InventoryItemDetailBlock(title: "Stock & Logistics", iconName: "cube.box.fill") {
                    Group {
                        InventoryItemDetailFieldRow(iconName: "number.circle.fill", label: "Current Quantity", value: "\(item.quantity) \(item.unit)", valueColor: item.quantity > item.minStockLevel ? .green : .red)
                        Divider()
                        InventoryItemDetailFieldRow(iconName: "arrow.down.to.line.alt", label: "Min Stock Level", value: "\(item.minStockLevel) \(item.unit)", valueColor: .blue)
                        Divider()
                        InventoryItemDetailFieldRow(iconName: "arrow.up.to.line.alt", label: "Max Stock Level", value: "\(item.maxStockLevel) \(item.unit)", valueColor: .blue)
                        Divider()
                        InventoryItemDetailFieldRow(iconName: "repeat.circle.fill", label: "Reorder Quantity", value: "\(item.reorderQuantity) \(item.unit)", valueColor: .orange)
                        Divider()
                        InventoryItemDetailFieldRow(iconName: "shippingbox.fill", label: "Batch Number", value: item.batchNumber, valueColor: .primary)
                        Divider()
                        InventoryItemDetailFieldRow(iconName: "mappin.and.ellipse", label: "Location", value: item.location, valueColor: .primary)
                        Divider()
                        InventoryItemDetailFieldRow(iconName: "humidity.fill", label: "Storage Condition", value: item.storageCondition, valueColor: .primary)
                    }
                }
                .padding(.horizontal)
                
                VStack {
                    InventoryItemDetailBlock(title: "Supplier & Financials", iconName: "banknote.fill") {
                        Group {
                            InventoryItemDetailFieldRow(iconName: "person.text.rectangle.fill", label: "Supplier Name", value: item.supplierName, valueColor: .primary)
                            Divider()
                            InventoryItemDetailFieldRow(iconName: "phone.fill", label: "Supplier Contact", value: item.supplierContact.isEmpty ? "N/A" : item.supplierContact, valueColor: .primary)
                            Divider()
                            InventoryItemDetailFieldRow(iconName: "dollarsign.circle", label: "Unit Cost", value: formattedCurrency(item.unitCost), valueColor: .green)
                            Divider()
                            InventoryItemDetailFieldRow(iconName: "tag.circle.fill", label: "Purchase Price", value: formattedCurrency(item.purchasePrice), valueColor: .orange)
                            Divider()
                            InventoryItemDetailFieldRow(iconName: "chart.pie.fill", label: "Total Value", value: formattedCurrency(item.totalValue), valueColor: .green)
                        }
                    }
                    InventoryItemDetailBlock(title: "Physical Details", iconName: "ruler.fill") {
                        Group {
                            InventoryItemDetailFieldRow(iconName: "tag.circle.fill", label: "Category", value: item.category, valueColor: .primary)
                            Divider()
                            InventoryItemDetailFieldRow(iconName: "doc.text.fill", label: "Sub Category", value: item.subCategory, valueColor: .primary)
                            Divider()
                            InventoryItemDetailFieldRow(iconName: "qrcode", label: "Barcode", value: item.barcode, valueColor: .primary)
                            Divider()
                            InventoryItemDetailFieldRow(iconName: "scalemass.fill", label: "Weight (g)", value: "\(item.weightGrams)", valueColor: .primary)
                            Divider()
                            InventoryItemDetailFieldRow(iconName: "drop.fill", label: "Volume (L)", value: String(format: "%.2f", item.volumeLiters), valueColor: .primary)
                            Divider()
                            InventoryItemDetailFieldRow(iconName: "number", label: "Usage Freq.", value: "\(item.usageFrequency)", valueColor: .primary)
                        }
                    }
                }
                .padding(.horizontal)

                InventoryItemDetailBlock(title: "Date & Audit", iconName: "calendar") {
                    Group {
                        InventoryItemDetailFieldRow(iconName: "calendar.badge.clock.fill", label: "Date Received", value: formattedDate(item.dateReceived), valueColor: .primary)
                        Divider()
                        InventoryItemDetailFieldRow(iconName: "xmark.octagon.fill", label: "Expiry Date", value: formattedDate(item.expiryDate), valueColor: .red)
                        Divider()
                        InventoryItemDetailFieldRow(iconName: "calendar.badge.checkmark.rtl", label: "Last Checked", value: formattedDate(item.lastChecked), valueColor: .gray)
                        Divider()
                        InventoryItemDetailFieldRow(iconName: "arrow.up.left.circle.fill", label: "Last Used", value: formattedDate(item.lastUsedDate), valueColor: .gray)
                        Divider()
                        InventoryItemDetailFieldRow(iconName: "person.badge.shield.checkmark.fill", label: "Created By", value: item.createdBy, valueColor: .primary)
                        Divider()
                        InventoryItemDetailFieldRow(iconName: "clock.fill", label: "Created At", value: formattedDate(item.createdAt), valueColor: .gray)
                        Divider()
                        InventoryItemDetailFieldRow(iconName: "arrow.clockwise.circle.fill", label: "Updated At", value: formattedDate(item.updatedAt), valueColor: .gray)
                        Divider()
                        InventoryItemDetailFieldRow(iconName: "tag.slash.fill", label: "Active", value: item.isActive ? "Yes" : "No", valueColor: item.isActive ? .green : .red)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)

            }
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground))
    }
}

@available(iOS 14.0, *)
struct InventoryFeatureRootView: View {
    @StateObject var dataStore = BiscuitFactoryDataStore()
    
    var body: some View {
        InventoryItemListView(dataStore: dataStore)
    }
}

