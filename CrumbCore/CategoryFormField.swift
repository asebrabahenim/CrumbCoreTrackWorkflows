import SwiftUI
import Combine

private protocol CategoryFormField: View {
    var title: String { get }
    var iconName: String { get }
    var isFilled: Bool { get }
}


@available(iOS 14.0, *)
private struct CategoryAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.headline)
                .foregroundColor(Color.accentColor)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.top, 15)
        .padding(.bottom, 5)
    }
}

@available(iOS 14.0, *)
private struct CategoryAddFieldView: CategoryFormField {
    let title: String
    let iconName: String
    @Binding var text: String
    var isFilled: Bool { !text.isEmpty }

    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.secondary)
                .offset(y: -25)
                .scaleEffect(0.8, anchor: .leading)
                .padding(.vertical,10)
            
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.secondary)
                TextField("", text: $text)
                    .foregroundColor(.primary)
            }
        }
        .padding(.top, 10)
        .padding(.horizontal)
        .padding(.bottom, 5)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isFilled ? Color.accentColor : Color.gray.opacity(0.5), lineWidth: 1)
                .background(Color(.systemGray6))
        )
    }
}

@available(iOS 14.0, *)
private struct CategoryAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.secondary)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(CompactDatePickerStyle())
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                .background(Color(.systemGray6))
        )
    }
}

@available(iOS 14.0, *)
private struct CategoryAddToggleFieldView: View {
    let title: String
    let iconName: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.secondary)
            Text(title)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .accentColor(Color.accentColor)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                .background(Color(.systemGray6))
        )
    }
}

@available(iOS 14.0, *)
private struct CategoryAddIntFieldView: CategoryFormField {
    let title: String
    let iconName: String
    @Binding var value: Int
    var isFilled: Bool { value > 0 }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.secondary)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            Stepper("\(value)", value: $value, in: 0...999)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isFilled ? Color.accentColor : Color.gray.opacity(0.5), lineWidth: 1)
                .background(Color(.systemGray6))
        )
    }
}

@available(iOS 14.0, *)
private struct CategoryAddDoubleFieldView: CategoryFormField {
    let title: String
    let iconName: String
    @Binding var value: Double
    @State private var textValue: String = ""

    var isFilled: Bool { !textValue.isEmpty && value != 0.0 }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.secondary)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            TextField("0.0", text: $textValue, onCommit: {
                if let val = Double(textValue) {
                    value = val
                } else {
                    textValue = String(format: "%.2f", value)
                }
            })
            .keyboardType(.decimalPad)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isFilled ? Color.accentColor : Color.gray.opacity(0.5), lineWidth: 1)
                .background(Color(.systemGray6))
        )
        .onAppear {
            textValue = String(format: "%.2f", value)
        }
        .onReceive(Just(value)) { newValue in
                   textValue = String(format: "%.2f", newValue)
        }
    }
}

@available(iOS 14.0, *)
struct CategoryAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataStore: BiscuitFactoryDataStore
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var colorHex: String = "#FFFFFF"
    @State private var iconName: String = "folder"
    @State private var parentCategory: String = ""
    @State private var displayOrder: Int = 1
    @State private var isVisible: Bool = true
    @State private var createdBy: String = "User"
    @State private var itemCount: Int = 0
    @State private var notes: String = ""
    @State private var tags: String = ""
    @State private var relatedCategories: String = ""
    @State private var popularityScore: Int = 50
    @State private var seasonal: Bool = false
    @State private var featured: Bool = false
    @State private var usageCount: Int = 0
    @State private var version: String = "1.0"
    @State private var region: String = ""
    @State private var productExamples: String = ""
    @State private var categoryCode: String = ""
    @State private var weight: Double = 0.0
    @State private var grade: String = "C"
    @State private var approvalStatus: String = "Pending"
    @State private var remarks: String = ""
    @State private var relatedSKUs: String = ""
    @State private var archived: Bool = false
    @State private var assignedBy: String = "User"
    @State private var reviewDate: Date = Date()
    @State private var importanceLevel: Int = 1
    @State private var sortOrder: Int = 1
    @State private var aliasNames: String = ""
    @State private var seoKeywords: String = ""
    @State private var backgroundImage: String = ""
    @State private var status: String = "Active"

    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private func validateAndSave() {
        var errors: [String] = []
        
        if title.isEmpty { errors.append("Title is required.") }
        if description.isEmpty { errors.append("Description is required.") }
        if parentCategory.isEmpty { errors.append("Parent Category is required.") }
        if region.isEmpty { errors.append("Region is required.") }
        if categoryCode.isEmpty { errors.append("Category Code is required.") }
        if grade.isEmpty { errors.append("Grade is required.") }
        if approvalStatus.isEmpty { errors.append("Approval Status is required.") }
        if version.isEmpty { errors.append("Version is required.") }
        if status.isEmpty { errors.append("Status is required.") }


        if errors.isEmpty {
            let now = Date()
            let newCategory = Category(
                title: title,
                description: description,
                colorHex: colorHex,
                iconName: iconName,
                parentCategory: parentCategory,
                displayOrder: displayOrder,
                isVisible: isVisible,
                createdBy: createdBy,
                createdAt: now,
                updatedAt: now,
                itemCount: itemCount,
                notes: notes,
                tags: tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                relatedCategories: relatedCategories.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                popularityScore: popularityScore,
                seasonal: seasonal,
                featured: featured,
                lastUsed: now,
                usageCount: usageCount,
                version: version,
                region: region,
                productExamples: productExamples.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                categoryCode: categoryCode,
                weight: weight,
                grade: grade,
                approvalStatus: approvalStatus,
                remarks: remarks,
                relatedSKUs: relatedSKUs.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                archived: archived,
                assignedBy: assignedBy,
                reviewDate: reviewDate,
                importanceLevel: importanceLevel,
                sortOrder: sortOrder,
                aliasNames: aliasNames.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                seoKeywords: seoKeywords.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                backgroundImage: backgroundImage,
                status: status
            )
            
            dataStore.addCategory(newCategory)
            alertMessage = "Success! The new category '\(title)' has been added."
        } else {
            alertMessage = "Please correct the following errors:\n\n" + errors.joined(separator: "\n")
        }
        
        showAlert = true
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                CategoryAddSectionHeaderView(title: "Basic Identity", iconName: "tag.fill")
                
                VStack(spacing: 15) {
                    CategoryAddFieldView(title: "Category Title", iconName: "textformat.alt", text: $title)
                    CategoryAddFieldView(title: "Category Code (SKU)", iconName: "barcode", text: $categoryCode)
                    CategoryAddFieldView(title: "Description", iconName: "note.text", text: $description)
                    CategoryAddFieldView(title: "Parent Category", iconName: "link", text: $parentCategory)
                    CategoryAddFieldView(title: "Icon Name (SF Symbol)", iconName: "photo.fill", text: $iconName)
                    CategoryAddFieldView(title: "Color Hex", iconName: "paintpalette.fill", text: $colorHex)
                }
                
                CategoryAddSectionHeaderView(title: "Status & Visibility", iconName: "info.circle.fill")
                
                VStack(spacing: 15) {
                    CategoryAddFieldView(title: "Status", iconName: "bolt.fill", text: $status)
                    HStack {
                        CategoryAddToggleFieldView(title: "Is Visible", iconName: "eye.fill", isOn: $isVisible)
                        CategoryAddToggleFieldView(title: "Is Featured", iconName: "star.fill", isOn: $featured)
                    }
                    HStack {
                        CategoryAddToggleFieldView(title: "Is Seasonal", iconName: "leaf.fill", isOn: $seasonal)
                        CategoryAddToggleFieldView(title: "Is Archived", iconName: "archivebox.fill", isOn: $archived)
                    }
                    CategoryAddFieldView(title: "Background Image Name", iconName: "photo", text: $backgroundImage)
                }
                
                CategoryAddSectionHeaderView(title: "Metadata & Metrics", iconName: "chart.bar.fill")
                
                VStack(spacing: 15) {
                    HStack {
                        CategoryAddIntFieldView(title: "Display Order", iconName: "list.number", value: $displayOrder)
                        CategoryAddIntFieldView(title: "Sort Order", iconName: "arrow.up.arrow.down", value: $sortOrder)
                    }
                    HStack {
                        CategoryAddIntFieldView(title: "Item Count", iconName: "archivebox.fill", value: $itemCount)
                        CategoryAddIntFieldView(title: "Usage Count", iconName: "figure.walk", value: $usageCount)
                    }
                    HStack {
                        CategoryAddDoubleFieldView(title: "Avg. Weight (kg)", iconName: "scalemass.fill", value: $weight)
                        CategoryAddIntFieldView(title: "Popularity Score (0-100)", iconName: "hand.thumbsup.fill", value: $popularityScore)
                    }
                    CategoryAddIntFieldView(title: "Importance Level (1-5)", iconName: "heart.fill", value: $importanceLevel)
                    CategoryAddFieldView(title: "Region", iconName: "map.fill", text: $region)

                }
                
                CategoryAddSectionHeaderView(title: "Management & References", iconName: "person.3.fill")

                VStack(spacing: 15) {
                    CategoryAddFieldView(title: "Created By", iconName: "person.fill", text: $createdBy)
                    CategoryAddFieldView(title: "Assigned By", iconName: "person.2.fill", text: $assignedBy)
                    CategoryAddFieldView(title: "Grade (A/B/C)", iconName: "g.circle.fill", text: $grade)
                    CategoryAddFieldView(title: "Approval Status", iconName: "hourglass.badge.fill", text: $approvalStatus)
                    CategoryAddFieldView(title: "Version", iconName: "number", text: $version)
                    CategoryAddDatePickerView(title: "Review Date", iconName: "calendar", date: $reviewDate)
                }
                
                CategoryAddSectionHeaderView(title: "Text & Keywords", iconName: "keyboard.fill")

                VStack(spacing: 15) {
                    CategoryAddFieldView(title: "Alias Names (comma sep.)", iconName: "text.magnifyingglass", text: $aliasNames)
                    CategoryAddFieldView(title: "SEO Keywords (comma sep.)", iconName: "globe", text: $seoKeywords)
                    CategoryAddFieldView(title: "Related Categories (comma sep.)", iconName: "bolt.horizontal.fill", text: $relatedCategories)
                    CategoryAddFieldView(title: "Related SKUs (comma sep.)", iconName: "list.bullet.rectangle.fill", text: $relatedSKUs)
                    CategoryAddFieldView(title: "Product Examples (comma sep.)", iconName: "cube.fill", text: $productExamples)
                    CategoryAddFieldView(title: "Tags (comma sep.)", iconName: "tag", text: $tags)
                    CategoryAddFieldView(title: "Remarks", iconName: "pencil", text: $remarks)
                    CategoryAddFieldView(title: "Notes", iconName: "doc.text.fill", text: $notes)
                }

                Button(action: validateAndSave) {
                    Text("Create New Category")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
            }
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
        .navigationTitle("New Category Listing")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertMessage.contains("Success") ? "Operation Complete" : "Validation Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if alertMessage.contains("Success") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
}


@available(iOS 14.0, *)
private struct CategorySearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search categories...", text: $searchText)
                .foregroundColor(.primary)
                .disableAutocorrection(true)
            
            if !searchText.isEmpty {
                Button(action: { self.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray5))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
}

@available(iOS 14.0, *)
private struct CategoryListRowView: View {
    let category: Category
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // MARK: Header Section
            HStack(alignment: .top) {
                Image(systemName: category.iconName)
                    .font(.title)
                    .foregroundColor(Color(hex: category.colorHex) ?? .blue)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: category.colorHex)?.opacity(0.15) ?? Color.blue.opacity(0.15))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text("Parent: \(category.parentCategory) | Code: \(category.categoryCode)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 6) {
                        if category.featured {
                            Label("Featured", systemImage: "star.fill")
                                .font(.caption2)
                                .padding(4)
                                .background(Color.yellow.opacity(0.2))
                                .cornerRadius(6)
                        }
                        if category.seasonal {
                            Label("Seasonal", systemImage: "leaf.fill")
                                .font(.caption2)
                                .padding(4)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(6)
                        }
                        if category.archived {
                            Label("Archived", systemImage: "archivebox.fill")
                                .font(.caption2)
                                .padding(4)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(6)
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text(category.grade)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(category.grade == "A+" ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                        .cornerRadius(6)
                    
                    Text(category.status)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(category.status == "Active" ? .green : .red)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
            
            Divider().padding(.horizontal, 12)
            
            // MARK: Description & Notes
            VStack(alignment: .leading, spacing: 4) {
                Text(category.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                if !category.notes.isEmpty {
                    Text("Note: \(category.notes)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 12)
            
            Divider().padding(.horizontal, 12)
            
            // MARK: Metrics Section
            HStack(spacing: 12) {
                CategoryMetricView(icon: "bag.fill", label: "Items", value: "\(category.itemCount)", color: .purple)
                CategoryMetricView(icon: "chart.line.uptrend.xyaxis", label: "Popularity", value: "\(category.popularityScore)", color: .orange)
                CategoryMetricView(icon: "heart.fill", label: "Importance", value: "\(category.importanceLevel)", color: .red)
                CategoryMetricView(icon: "ruler", label: "Weight", value: String(format: "%.1f", category.weight), color: .blue)
            }
            .padding(.horizontal, 12)
            
            Divider().padding(.horizontal, 12)
            
            // MARK: Creator & Visibility
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Label("Created by \(category.createdBy)", systemImage: "person.fill")
                    Spacer()
                    Text("Order: \(category.displayOrder)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .font(.caption2)
                .foregroundColor(.secondary)
                
                HStack {
                    Label("Visible: \(category.isVisible ? "Yes" : "No")", systemImage: category.isVisible ? "eye.fill" : "eye.slash.fill")
                    Spacer()
                    Label("Approved: \(category.approvalStatus)", systemImage: "checkmark.seal.fill")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            
            Divider().padding(.horizontal, 12)
            
            // MARK: Tags & Aliases
            if !category.tags.isEmpty || !category.aliasNames.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    if !category.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(category.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption2)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }
                    if !category.aliasNames.isEmpty {
                        Text("Aliases: \(category.aliasNames.joined(separator: ", "))")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }
                .padding(.horizontal, 12)
            }
            
            Divider().padding(.horizontal, 12)
            
            // MARK: Footer Section
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Version \(category.version) | \(category.region)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text("Reviewed: \(dateFormatter.string(from: category.reviewDate))")
                        .font(.caption2)
                        .foregroundColor(.accentColor)
                }
                Spacer()
                Text("Used \(category.usageCount)x")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding([.bottom, .horizontal], 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
        )
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
}

@available(iOS 14.0, *)
private struct CategoryMetricView: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(color)
            VStack(alignment: .leading) {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

@available(iOS 14.0, *)
private struct CategoryNoDataView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "magnifyingglass.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.secondary)
            
            Text("No Categories Found")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Try adjusting your search criteria or add a new category using the '+' button above.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 100)
    }
}

@available(iOS 14.0, *)
struct CategoryListView: View {
    @ObservedObject var dataStore: BiscuitFactoryDataStore
    @State private var searchText: String = ""
    @State private var isShowingAddView: Bool = false
    
    private var filteredCategories: [Category] {
        if searchText.isEmpty {
            return dataStore.categories
        } else {
            return dataStore.categories.filter { category in
                category.title.localizedCaseInsensitiveContains(searchText) ||
                category.description.localizedCaseInsensitiveContains(searchText) ||
                category.categoryCode.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                CategorySearchBarView(searchText: $searchText)
                
                if filteredCategories.isEmpty {
                    CategoryNoDataView()
                    Spacer()
                } else {
                    List {
                        ForEach(filteredCategories) { category in
                            NavigationLink(destination: CategoryDetailView(category: category)) {
                                CategoryListRowView(category: category)
                                    .listRowInsets(EdgeInsets())
                                    .background(Color(.systemBackground))
                            }
                        }
                        .onDelete(perform: deleteCategory)
                        .listRowBackground(Color(.systemGroupedBackground))
                    }
                    .listStyle(GroupedListStyle())
                }
            }
            .navigationTitle("Category Management")
            .navigationBarItems(trailing:
                Button(action: {
                    isShowingAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                }
            )
            .sheet(isPresented: $isShowingAddView) {
                NavigationView {
                    CategoryAddView(dataStore: dataStore)
                }
            }
        
    }
    
    private func deleteCategory(at offsets: IndexSet) {
        let categoriesToDelete = offsets.map { filteredCategories[$0].id }
        dataStore.categories.removeAll { categoriesToDelete.contains($0.id) }
    }
}


@available(iOS 14.0, *)
private struct CategoryDetailFieldRow: View {
    let title: String
    let value: String
    let iconName: String
    let valueColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.secondary)
                .frame(width: 20)
            
            Text(title)
                .font(.callout)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(valueColor)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
    }
}

@available(iOS 14.0, *)
private struct CategoryDetailBlock: View {
    let title: String
    let iconName: String
    
    var content: () -> AnyView
    
    init<Content: View>(title: String, iconName: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.iconName = iconName
        self.content = { AnyView(content()) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 5)
            
            content()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct CategoryDetailView: View {
    let category: Category
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text(category.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("\(category.parentCategory) | Code: \(category.categoryCode) | V\(category.version)")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: category.iconName)
                            .font(.system(size: 40))
                            .foregroundColor(Color(hex: category.colorHex) ?? .blue)
                    }
                    
                    Text(category.description)
                        .font(.body)
                        .padding(.vertical, 5)
                    
                    HStack {
                        BadgeView(label: category.status, color: category.status == "Active" ? .green : .red)
                        if category.featured {
                            BadgeView(label: "FEATURED", color: .yellow)
                        }
                        if category.seasonal {
                            BadgeView(label: "SEASONAL", color: .orange)
                        }
                        if category.archived {
                            BadgeView(label: "ARCHIVED", color: .gray)
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
                .padding(.top, 5)

                
                CategoryDetailBlock(title: "Core Attributes", iconName: "puzzlepiece.fill") {
                    VStack(spacing: 8) {
                        HStack {
                            CategoryDetailFieldRow(title: "Parent Category", value: category.parentCategory, iconName: "link", valueColor: .primary)
                            CategoryDetailFieldRow(title: "Display Order", value: "\(category.displayOrder)", iconName: "list.number", valueColor: .primary)
                        }
                        HStack {
                            CategoryDetailFieldRow(title: "Region", value: category.region, iconName: "map.fill", valueColor: .primary)
                            CategoryDetailFieldRow(title: "Sort Order", value: "\(category.sortOrder)", iconName: "arrow.up.arrow.down", valueColor: .primary)
                        }
                        HStack {
                            CategoryDetailFieldRow(title: "Color Hex", value: category.colorHex, iconName: "paintpalette.fill", valueColor: .primary)
                            CategoryDetailFieldRow(title: "Background Image", value: category.backgroundImage.isEmpty ? "N/A" : category.backgroundImage, iconName: "photo", valueColor: .primary)
                        }
                        HStack {
                            CategoryDetailFieldRow(title: "Avg. Weight (kg)", value: String(format: "%.2f", category.weight), iconName: "scalemass.fill", valueColor: .primary)
                            CategoryDetailFieldRow(title: "Is Visible", value: category.isVisible ? "Yes" : "No", iconName: "eye.fill", valueColor: category.isVisible ? .green : .red)
                        }
                    }
                }
                
                
                CategoryDetailBlock(title: "Performance & Usage", iconName: "chart.bar.fill") {
                    VStack(spacing: 8) {
                        CategoryDetailFieldRow(title: "Popularity Score", value: "\(category.popularityScore) / 100", iconName: "hand.thumbsup.fill", valueColor: .blue)
                        CategoryDetailFieldRow(title: "Item Count", value: "\(category.itemCount)", iconName: "archivebox.fill", valueColor: .primary)
                        CategoryDetailFieldRow(title: "Usage Count", value: "\(category.usageCount)", iconName: "figure.walk", valueColor: .blue)
                        CategoryDetailFieldRow(title: "Importance Level", value: "\(category.importanceLevel) / 5", iconName: "heart.fill", valueColor: category.importanceLevel > 3 ? .red : .primary)
                        CategoryDetailFieldRow(title: "Last Used", value: dateFormatter.string(from: category.lastUsed), iconName: "clock.fill", valueColor: .primary)
                    }
                }

                
                CategoryDetailBlock(title: "Management & Audit", iconName: "shield.lefthalf.fill") {
                    VStack(spacing: 8) {
                        CategoryDetailFieldRow(title: "Approval Status", value: category.approvalStatus, iconName: "checkmark.shield.fill", valueColor: category.approvalStatus == "Approved" ? .green : .orange)
                        CategoryDetailFieldRow(title: "Grade", value: category.grade, iconName: "g.circle.fill", valueColor: .primary)
                        CategoryDetailFieldRow(title: "Review Date", value: dateFormatter.string(from: category.reviewDate), iconName: "calendar.badge.clock", valueColor: .primary)
                        CategoryDetailFieldRow(title: "Created By", value: category.createdBy, iconName: "person.fill", valueColor: .primary)
                        CategoryDetailFieldRow(title: "Assigned By", value: category.assignedBy, iconName: "person.2.fill", valueColor: .primary)
                        CategoryDetailFieldRow(title: "Created At", value: dateFormatter.string(from: category.createdAt), iconName: "plus.circle.fill", valueColor: .primary)
                        CategoryDetailFieldRow(title: "Updated At", value: dateFormatter.string(from: category.updatedAt), iconName: "arrow.counterclockwise", valueColor: .primary)
                        
                        Divider()
                        Text("Remarks: \(category.remarks.isEmpty ? "N/A" : category.remarks)")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Text("Notes: \(category.notes.isEmpty ? "N/A" : category.notes)")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .lineLimit(nil)
                    }
                }
                
                
                CategoryDetailBlock(title: "Related Data", iconName: "paperclip") {
                    VStack(alignment: .leading, spacing: 8) {
                        CategoryRelatedDataView(title: "Related SKUs", data: category.relatedSKUs, icon: "list.bullet.rectangle.fill")
                        CategoryRelatedDataView(title: "Related Categories", data: category.relatedCategories, icon: "bolt.horizontal.fill")
                        CategoryRelatedDataView(title: "Product Examples", data: category.productExamples, icon: "cube.fill")
                        CategoryRelatedDataView(title: "Tags", data: category.tags, icon: "tag.fill")
                        CategoryRelatedDataView(title: "Alias Names", data: category.aliasNames, icon: "text.magnifyingglass")
                        CategoryRelatedDataView(title: "SEO Keywords", data: category.seoKeywords, icon: "globe")
                    }
                }

                Spacer()
            }
            .padding(.bottom, 50)
        }
        .navigationTitle("Category Detail")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
}

@available(iOS 14.0, *)
private struct CategoryRelatedDataView: View {
    let title: String
    let data: [String]
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                Text("\(title):")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            if data.isEmpty {
                Text("N/A")
                    .font(.callout)
                    .foregroundColor(.secondary)
            } else {
                Text(data.joined(separator: ", "))
                    .font(.callout)
                    .foregroundColor(.primary)
            }
            Divider()
        }
    }
}

extension Color {
    init?(hex: String) {
        let r, g, b: CGFloat
        let start = hex.index(hex.startIndex, offsetBy: hex.hasPrefix("#") ? 1 : 0)
        let hexColor = String(hex[start...])
        
        guard hexColor.count == 6 else { return nil }
        
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            b = CGFloat(hexNumber & 0x0000ff) / 255
            self.init(red: r, green: g, blue: b)
            return
        }
        return nil
    }
}

@available(iOS 14.0, *)
private struct BadgeView: View {
    let label: String
    let color: Color
    
    var body: some View {
        Text(label)
            .font(.caption2)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(5)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()
