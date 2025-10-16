

import SwiftUI
import Combine

@available(iOS 14.0, *)
struct ProductionBatchAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.accentColor)
                .font(.headline)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct ProductionBatchAddFieldView: View {
    let title: String
    let iconName: String
    let placeholder: String
    @Binding var text: String
    var isRequired: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title + (isRequired ? " *" : ""))
                .font(.caption)
                .foregroundColor(.gray)
                .offset(y: -10)
                .scaleEffect(text.isEmpty ? 1.2 : 1.0, anchor: .leading)
                .animation(.easeOut(duration: 0.2), value: text.isEmpty)
            
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.accentColor)
                
                TextField(placeholder, text: $text)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 5)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.3))
        }
        .padding(.horizontal, 15)
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct ProductionBatchAddNumericFieldView: View {
    let title: String
    let iconName: String
    let placeholder: String
    @Binding var value: String
    
    var body: some View {
        ProductionBatchAddFieldView(
            title: title,
            iconName: iconName,
            placeholder: placeholder,
            text: $value
        )
        .keyboardType(.numberPad)
    }
}

@available(iOS 14.0, *)
struct ProductionBatchAddDoubleFieldView: View {
    let title: String
    let iconName: String
    let placeholder: String
    @Binding var value: String
    
    var body: some View {
        ProductionBatchAddFieldView(
            title: title,
            iconName: iconName,
            placeholder: placeholder,
            text: $value
        )
        .keyboardType(.decimalPad)
    }
}

@available(iOS 14.0, *)
struct ProductionBatchAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(CompactDatePickerStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 15)
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct ProductionBatchAddPickerView: View {
    let title: String
    let iconName: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 15)
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct ProductionBatchAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataStore: BiscuitFactoryDataStore
    
    @State private var batchCode: String = ""
    @State private var listingSKU: String = ""
    @State private var productName: String = ""
    @State private var producedDate: Date = Date()
    @State private var shift: String = "Morning"
    @State private var producedQuantity: String = ""
    @State private var rejectedQuantity: String = ""
    @State private var operatorName: String = ""
    @State private var supervisorName: String = ""
    @State private var lineNumber: String = ""
    @State private var ingredientsUsed: String = ""
    @State private var machineUsed: String = ""
    @State private var bakingTemp: String = ""
    @State private var bakingDurationMinutes: String = ""
    @State private var coolingTimeMinutes: String = ""
    @State private var packagingDate: Date = Date()
    @State private var expiryDate: Date = Calendar.current.date(byAdding: .month, value: 6, to: Date())!
    @State private var moistureLevel: String = ""
    @State private var qualityGrade: String = "A"
    @State private var inspectionPassed: Bool = true
    @State private var remarks: String = ""
    @State private var recordedBy: String = ""
    @State private var verifiedBy: String = ""
    @State private var batchCost: String = ""
    @State private var unitCost: String = ""
    @State private var productionNotes: String = ""
    @State private var imageName: String = ""
    @State private var category: String = ""
    @State private var lotNumber: String = ""
    @State private var location: String = ""
    @State private var tags: String = ""
    @State private var isArchived: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    let shifts = ["Morning", "Afternoon", "Night"]
    let grades = ["A", "B", "C"]
    
    private func validateAndSave() {
        var errors: [String] = []
        
        if batchCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Batch Code is required.") }
        if listingSKU.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Listing SKU is required.") }
        if productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Product Name is required.") }
        if operatorName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Operator Name is required.") }
        if producedQuantity.isEmpty || Int(producedQuantity) == nil { errors.append("Produced Quantity must be a valid number.") }
        if rejectedQuantity.isEmpty || Int(rejectedQuantity) == nil { errors.append("Rejected Quantity must be a valid number.") }
        if bakingTemp.isEmpty || Int(bakingTemp) == nil { errors.append("Baking Temp must be a valid number.") }
        if moistureLevel.isEmpty || Double(moistureLevel) == nil { errors.append("Moisture Level must be a valid number.") }
        if batchCost.isEmpty || Double(batchCost) == nil { errors.append("Batch Cost must be a valid number.") }
        if unitCost.isEmpty || Double(unitCost) == nil { errors.append("Unit Cost must be a valid number.") }
        
        if errors.isEmpty {
            let newBatch = ProductionBatch(
                batchCode: batchCode,
                listingSKU: listingSKU,
                productName: productName,
                producedDate: producedDate,
                shift: shift,
                producedQuantity: Int(producedQuantity) ?? 0,
                rejectedQuantity: Int(rejectedQuantity) ?? 0,
                operatorName: operatorName,
                supervisorName: supervisorName,
                lineNumber: lineNumber,
                ingredientsUsed: ingredientsUsed.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
                machineUsed: machineUsed,
                bakingTemp: Int(bakingTemp) ?? 0,
                bakingDurationMinutes: Int(bakingDurationMinutes) ?? 0,
                coolingTimeMinutes: Int(coolingTimeMinutes) ?? 0,
                packagingDate: packagingDate,
                expiryDate: expiryDate,
                moistureLevel: Double(moistureLevel) ?? 0.0,
                qualityGrade: qualityGrade,
                inspectionPassed: inspectionPassed,
                remarks: remarks,
                recordedBy: recordedBy,
                verifiedBy: verifiedBy,
                batchCost: Double(batchCost) ?? 0.0,
                unitCost: Double(unitCost) ?? 0.0,
                productionNotes: productionNotes,
                imageName: imageName,
                category: category,
                lotNumber: lotNumber,
                location: location,
                tags: tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
                createdAt: Date(),
                updatedAt: Date(),
                isArchived: isArchived
            )
            
            dataStore.addProductionBatch(newBatch)
            
            alertMessage = "Batch Added Successfully!\n\nProduct: \(newBatch.productName)\nCode: \(newBatch.batchCode)"
            showAlert = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if !showAlert {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        } else {
            alertMessage = "Please correct the following errors:\n\n" + errors.joined(separator: "\n")
            showAlert = true
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack(spacing: 15) {
                        ProductionBatchAddSectionHeaderView(title: "Batch & Product ID", iconName: "tag.circle.fill")
                        
                        ProductionBatchAddFieldView(title: "Batch Code", iconName: "barcode", placeholder: "e.g., PB-001", text: $batchCode)
                        ProductionBatchAddFieldView(title: "Listing SKU", iconName: "cube.box", placeholder: "e.g., BIS-001", text: $listingSKU)
                        ProductionBatchAddFieldView(title: "Product Name", iconName: "fork.knife", placeholder: "e.g., Choco Crunch", text: $productName)
                        ProductionBatchAddFieldView(title: "Category", iconName: "tray.full", placeholder: "e.g., Chocolate", text: $category)
                        ProductionBatchAddFieldView(title: "Lot Number", iconName: "number.circle", placeholder: "e.g., LOT-A1", text: $lotNumber)
                    }
                    .padding(.bottom, 20)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                    
                    VStack(spacing: 15) {
                        ProductionBatchAddSectionHeaderView(title: "Production Metrics", iconName: "chart.bar.fill")
                        
                        HStack {
                            ProductionBatchAddNumericFieldView(title: "Produced Qty", iconName: "number", placeholder: "e.g., 1000", value: $producedQuantity)
                            ProductionBatchAddNumericFieldView(title: "Rejected Qty", iconName: "xmark.octagon", placeholder: "e.g., 20", value: $rejectedQuantity)
                        }
                        
                        HStack {
                            ProductionBatchAddDatePickerView(title: "Produced Date", iconName: "calendar", date: $producedDate)
                            ProductionBatchAddPickerView(title: "Shift", iconName: "clock", selection: $shift, options: shifts)
                        }
                        
                        ProductionBatchAddFieldView(title: "Line Number", iconName: "list.number", placeholder: "e.g., L1", text: $lineNumber)
                        ProductionBatchAddFieldView(title: "Machine Used", iconName: "gear", placeholder: "e.g., Oven-X2", text: $machineUsed)
                        ProductionBatchAddFieldView(title: "Ingredients Used (Comma separated)", iconName: "leaf.fill", placeholder: "Flour, Sugar, Cocoa", text: $ingredientsUsed)
                    }
                    .padding(.bottom, 20)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                    
                    VStack(spacing: 15) {
                        ProductionBatchAddSectionHeaderView(title: "Baking & Cooling", iconName: "flame.fill")
                        
                        HStack {
                            ProductionBatchAddNumericFieldView(title: "Baking Temp (°C)", iconName: "thermometer", placeholder: "e.g., 180", value: $bakingTemp)
                            ProductionBatchAddNumericFieldView(title: "Baking Duration (min)", iconName: "timer", placeholder: "e.g., 15", value: $bakingDurationMinutes)
                        }
                        ProductionBatchAddNumericFieldView(title: "Cooling Time (min)", iconName: "snowflake", placeholder: "e.g., 10", value: $coolingTimeMinutes)
                    }
                    .padding(.bottom, 20)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                    
                    VStack(spacing: 15) {
                        ProductionBatchAddSectionHeaderView(title: "Cost & Location", iconName: "dollarsign.circle.fill")
                        
                        HStack {
                            ProductionBatchAddDoubleFieldView(title: "Batch Cost", iconName: "dollarsign", placeholder: "e.g., 5000.0", value: $batchCost)
                            ProductionBatchAddDoubleFieldView(title: "Unit Cost", iconName: "centsign.circle", placeholder: "e.g., 5.0", value: $unitCost)
                        }
                        ProductionBatchAddFieldView(title: "Location", iconName: "location.fill", placeholder: "e.g., Factory 1", text: $location)
                        ProductionBatchAddFieldView(title: "Image Name", iconName: "photo", placeholder: "e.g., batch1", text: $imageName)
                    }
                    .padding(.bottom, 20)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)

                    VStack(spacing: 15) {
                        ProductionBatchAddSectionHeaderView(title: "Personnel & Quality", iconName: "person.3.fill")
                        
                        ProductionBatchAddFieldView(title: "Operator Name", iconName: "person", placeholder: "Name", text: $operatorName)
                        ProductionBatchAddFieldView(title: "Supervisor Name", iconName: "person.2", placeholder: "Name", text: $supervisorName)
                        ProductionBatchAddFieldView(title: "Recorded By", iconName: "square.and.pencil", placeholder: "User", text: $recordedBy)
                        ProductionBatchAddFieldView(title: "Verified By", iconName: "checkmark.seal.fill", placeholder: "Auditor Name", text: $verifiedBy)
                        
                        HStack {
                            ProductionBatchAddDoubleFieldView(title: "Moisture Level (%)", iconName: "drop", placeholder: "e.g., 3.2", value: $moistureLevel)
                            ProductionBatchAddPickerView(title: "Quality Grade", iconName: "star.fill", selection: $qualityGrade, options: grades)
                        }
                        
                        Toggle(isOn: $inspectionPassed) {
                            Text("Inspection Passed")
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        
                        Toggle(isOn: $isArchived) {
                            Text("Is Archived")
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)

                    }
                    .padding(.bottom, 20)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)

                    VStack(alignment: .leading, spacing: 15) {
                        ProductionBatchAddSectionHeaderView(title: "Notes & Dates", iconName: "doc.text.fill")

                        HStack {
                            ProductionBatchAddDatePickerView(title: "Packaging Date", iconName: "calendar.badge.plus", date: $packagingDate)
                            ProductionBatchAddDatePickerView(title: "Expiry Date", iconName: "calendar.badge.minus", date: $expiryDate)
                        }

                        VStack(alignment: .leading) {
                            Text("Production Notes")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 15)
                            TextEditor(text: $productionNotes)
                                .frame(height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 15)

                        VStack(alignment: .leading) {
                            Text("Remarks")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 15)
                            TextEditor(text: $remarks)
                                .frame(height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 15)

                        ProductionBatchAddFieldView(title: "Tags (Comma separated)", iconName: "tag.circle", placeholder: "good, verified", text: $tags)
                    }
                    .padding(.bottom, 20)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)

                    Button(action: validateAndSave) {
                        Text("Save New Production Batch")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 15)
                            .padding(.bottom, 20)
                    }
                }
                .padding(.top, 1)
                
            }
            .navigationTitle("Add Batch Record")
            .background(Color(UIColor.systemGroupedBackground))
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertMessage.contains("Successfully") ? "Success" : "Validation Error"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")) {
                        if alertMessage.contains("Successfully") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                      }
                )
            }
        }
    }
}

@available(iOS 14.0, *)
struct ProductionBatchListRowView: View {
    let batch: ProductionBatch
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(alignment: .top) {
                Image(systemName: "box.truck.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(batch.productName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("SKU: \(batch.listingSKU)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(batch.batchCode)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(5)
                    
                    Text("Grade: \(batch.qualityGrade)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(batch.inspectionPassed ? Color.green : Color.red)
                        .cornerRadius(5)
                }
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "sum")
                            .foregroundColor(.orange)
                        Text("Produced: **\(batch.producedQuantity)**")
                    }
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.purple)
                        Text("Batch Cost: **\(Int(batch.batchCost))**")
                    }
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.6))
                        Text("Shift: **\(batch.shift)**")
                    }
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.pink)
                        Text("Operator: **\(batch.operatorName)**")
                    }
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            Divider()
            
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(spacing: 20) {
                    ProductionBatchListDetailItem(icon: "calendar.circle.fill", title: "Produced", value: formattedDate(batch.producedDate))
                    ProductionBatchListDetailItem(icon: "drop.fill", title: "Moisture", value: "\(String(format: "%.1f", batch.moistureLevel))%")
                    ProductionBatchListDetailItem(icon: "thermometer.sun.fill", title: "Temp", value: "\(batch.bakingTemp)°C")
                    ProductionBatchListDetailItem(icon: "timer", title: "Duration", value: "\(batch.bakingDurationMinutes) min")
                    ProductionBatchListDetailItem(icon: "building.2.fill", title: "Location", value: batch.location.isEmpty ? "N/A" : batch.location)
                    ProductionBatchListDetailItem(icon: "calendar.badge.minus", title: "Expires", value: formattedDate(batch.expiryDate))
                }
                .padding(.vertical, 5)
            }
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

@available(iOS 14.0, *)
struct ProductionBatchListDetailItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

@available(iOS 14.0, *)
struct ProductionBatchNoDataView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "tray.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.orange)
            
            Text("No Production Batches Found")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Looks like the factory floor is empty! Tap the '+' to add a new batch record.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 50)
    }
}

@available(iOS 14.0, *)
struct ProductionBatchSearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Search by batch code or product name...", text: $searchText) { isEditing in
                self.isEditing = isEditing
            } onCommit: {
                self.isEditing = false
            }
            .padding(10)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    
                    if isEditing {
                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                        .transition(.scale)
                    }
                }
            )
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.searchText = ""
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.default, value: isEditing)
    }
}

@available(iOS 14.0, *)
struct ProductionBatchListView: View {
    @ObservedObject var dataStore: BiscuitFactoryDataStore
    @State private var searchText: String = ""
    @State private var showingAddView = false
    
    private var filteredBatches: [ProductionBatch] {
        if searchText.isEmpty {
            return dataStore.productionBatches
        } else {
            return dataStore.productionBatches.filter {
                $0.batchCode.localizedCaseInsensitiveContains(searchText) ||
                $0.productName.localizedCaseInsensitiveContains(searchText) ||
                $0.operatorName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack {
                ProductionBatchSearchBarView(searchText: $searchText)
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
                
                if filteredBatches.isEmpty {
                    ProductionBatchNoDataView()
                } else {
                    List {
                        ForEach(filteredBatches) { batch in
                            NavigationLink(destination: ProductionBatchDetailView(batch: batch)) {
                                ProductionBatchListRowView(batch: batch)
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 15, bottom: 8, trailing: 15))
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(PlainListStyle())
                }
                Spacer()
            }
            .navigationTitle("Production Batches")
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarItems(trailing:
                Button(action: {
                    showingAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            )
            .sheet(isPresented: $showingAddView) {
                ProductionBatchAddView( dataStore: dataStore)
            }
        
    }
    
    private func deleteItems(offsets: IndexSet) {
        let indicesToDelete = offsets.map { filteredBatches[$0] }
        dataStore.productionBatches.removeAll { item in
            indicesToDelete.contains(where: { $0.id == item.id })
        }
    }
}

@available(iOS 14.0, *)
struct ProductionBatchDetailFieldRow: View {
    let iconName: String
    let label: String
    let value: String
    var valueColor: Color = .primary
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .frame(width: 20)
                .foregroundColor(.accentColor)
            
            Text(label)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .foregroundColor(valueColor)
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
    }
}

@available(iOS 14.0, *)
struct ProductionBatchDetailGroupedBlock<Content: View>: View {
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
                    .font(.title3)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 5)
            
            content
                .padding(.horizontal, 10)
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}


@available(iOS 14.0, *)
struct ProductionBatchDetailView: View {
    let batch: ProductionBatch
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                VStack(spacing: 8) {
                    Text(batch.productName)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    Text("Batch Code: \(batch.batchCode)")
                        .font(.headline)
                        .foregroundColor(Color.white.opacity(0.8))
                    
                    HStack {
                        Image(systemName: "checkmark.shield.fill")
                            .foregroundColor(.white)
                        Text(batch.inspectionPassed ? "Inspection Passed" : "Inspection Failed")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(batch.inspectionPassed ? Color.green.opacity(0.8) : Color.red.opacity(0.8))
                    .cornerRadius(8)
                }
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                
                ProductionBatchDetailGroupedBlock(title: "Summary & Dates", iconName: "calendar.badge.clock.fill") {
                    VStack {
                        VStack {
                            VStack(alignment: .leading) {
                                ProductionBatchDetailFieldRow(iconName: "sum", label: "Produced Quantity", value: "\(batch.producedQuantity)")
                                ProductionBatchDetailFieldRow(iconName: "xmark.octagon.fill", label: "Rejected Quantity", value: "\(batch.rejectedQuantity)")
                                ProductionBatchDetailFieldRow(iconName: "dollarsign.circle", label: "Batch Cost", value: String(format: "%.2f", batch.batchCost))
                                ProductionBatchDetailFieldRow(iconName: "centsign.circle", label: "Unit Cost", value: String(format: "%.2f", batch.unitCost))
                            }
                            Divider()
                            VStack(alignment: .leading) {
                                ProductionBatchDetailFieldRow(iconName: "calendar.badge.plus", label: "Produced Date", value: formattedDate(batch.producedDate))
                                ProductionBatchDetailFieldRow(iconName: "archivebox.fill", label: "Packaging Date", value: formattedDate(batch.packagingDate))
                                ProductionBatchDetailFieldRow(iconName: "calendar.badge.minus", label: "Expiry Date", value: formattedDate(batch.expiryDate), valueColor: .red)
                                ProductionBatchDetailFieldRow(iconName: "star.fill", label: "Quality Grade", value: batch.qualityGrade)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                ProductionBatchDetailGroupedBlock(title: "Process & Equipment", iconName: "gearshape.fill") {
                    VStack(alignment: .leading) {
                        ProductionBatchDetailFieldRow(iconName: "tag", label: "Listing SKU", value: batch.listingSKU)
                        ProductionBatchDetailFieldRow(iconName: "clock.arrow.2.circlepath", label: "Shift", value: batch.shift)
                        ProductionBatchDetailFieldRow(iconName: "line.horizontal.3.decrease.circle.fill", label: "Line Number", value: batch.lineNumber)
                        ProductionBatchDetailFieldRow(iconName: "oven.fill", label: "Machine Used", value: batch.machineUsed)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                ProductionBatchDetailFieldRow(iconName: "thermometer", label: "Baking Temp (°C)", value: "\(batch.bakingTemp)")
                            }
                            Divider()
                            VStack(alignment: .leading) {
                                ProductionBatchDetailFieldRow(iconName: "timer", label: "Baking Duration (min)", value: "\(batch.bakingDurationMinutes)")
                            }
                        }
                        
                        ProductionBatchDetailFieldRow(iconName: "snowflake", label: "Cooling Time (min)", value: "\(batch.coolingTimeMinutes)")
                        ProductionBatchDetailFieldRow(iconName: "drop.fill", label: "Moisture Level (%)", value: String(format: "%.1f", batch.moistureLevel))
                        ProductionBatchDetailFieldRow(iconName: "leaf.fill", label: "Ingredients Used", value: batch.ingredientsUsed.isEmpty ? "N/A" : batch.ingredientsUsed.joined(separator: ", "))
                    }
                }
                .padding(.horizontal)
                
                ProductionBatchDetailGroupedBlock(title: "Personnel & Location", iconName: "person.3.fill") {
                    VStack(alignment: .leading) {
                        ProductionBatchDetailFieldRow(iconName: "person.fill", label: "Operator Name", value: batch.operatorName)
                        ProductionBatchDetailFieldRow(iconName: "person.2.fill", label: "Supervisor Name", value: batch.supervisorName)
                        ProductionBatchDetailFieldRow(iconName: "square.and.pencil", label: "Recorded By", value: batch.recordedBy)
                        ProductionBatchDetailFieldRow(iconName: "checkmark.seal.fill", label: "Verified By", value: batch.verifiedBy.isEmpty ? "N/A" : batch.verifiedBy)
                        
                        Divider()
                        
                        ProductionBatchDetailFieldRow(iconName: "folder.badge.gearshape", label: "Category", value: batch.category.isEmpty ? "N/A" : batch.category)
                        ProductionBatchDetailFieldRow(iconName: "doc.text.fill", label: "Lot Number", value: batch.lotNumber.isEmpty ? "N/A" : batch.lotNumber)
                        ProductionBatchDetailFieldRow(iconName: "building.2.fill", label: "Location", value: batch.location.isEmpty ? "N/A" : batch.location)
                    }
                }
                .padding(.horizontal)
                
                ProductionBatchDetailGroupedBlock(title: "Notes & System Info", iconName: "desktopcomputer") {
                    VStack(alignment: .leading) {
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Image(systemName: "note.text")
                                    .foregroundColor(.accentColor)
                                Text("Production Notes")
                                    .fontWeight(.medium)
                            }
                            Text(batch.productionNotes.isEmpty ? "N/A" : batch.productionNotes)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding(.leading, 2)
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Image(systemName: "note.text.badge.plus")
                                    .foregroundColor(.accentColor)
                                Text("Remarks")
                                    .fontWeight(.medium)
                            }
                            Text(batch.remarks.isEmpty ? "N/A" : batch.remarks)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding(.leading, 2)
                        }
                        
                        Divider()
                        
                        ProductionBatchDetailFieldRow(iconName: "photo", label: "Image Name", value: batch.imageName.isEmpty ? "N/A" : batch.imageName)
                        ProductionBatchDetailFieldRow(iconName: "sparkles", label: "Tags", value: batch.tags.isEmpty ? "None" : batch.tags.joined(separator: ", "))
                        ProductionBatchDetailFieldRow(iconName: "archivebox", label: "Archived", value: batch.isArchived ? "Yes" : "No")
                        ProductionBatchDetailFieldRow(iconName: "clock.fill", label: "Created At", value: formattedDate(batch.createdAt))
                        ProductionBatchDetailFieldRow(iconName: "arrow.clockwise.circle.fill", label: "Updated At", value: formattedDate(batch.updatedAt))
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("Batch Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground))
    }
}

