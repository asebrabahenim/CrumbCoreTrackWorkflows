import SwiftUI
import Combine

typealias Model = BiscuitListing

extension Date {
    func formattedForDisplay() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}

@available(iOS 14.0, *)
struct BiscuitListingAddFieldView: View {
    let title: String
    let iconName: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isRequired: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(Color.orange)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                if isRequired {
                    Text("*")
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal, 8)
            
            TextField(placeholder, text: $text)
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .keyboardType(keyboardType)
        }
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct BiscuitListingAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(Color.orange)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Text("*")
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 8)
            
            DatePicker(
                "Select Date",
                selection: $date,
                displayedComponents: .date
            )
            .labelsHidden()
            .datePickerStyle(CompactDatePickerStyle())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct BiscuitListingAddIntPickerView: View {
    let title: String
    let iconName: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(Color.orange)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Text("*")
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 8)
            
            Picker(title, selection: $value) {
                ForEach(range, id: \.self) { num in
                    Text("\(num)")
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct BiscuitListingAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.white)
                .padding(6)
                .background(Color.blue)
                .clipShape(Circle())
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Spacer()
        }
        .padding(.top)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct BiscuitListingAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataStore: BiscuitFactoryDataStore
    
    @State private var sku: String = ""
    @State private var name: String = ""
    @State private var flavor: String = ""
    @State private var shape: String = ""
    @State private var size: String = ""
    @State private var texture: String = ""
    @State private var color: String = ""
    @State private var sweetnessLevel: Int = 5
    @State private var ingredients: String = ""
    @State private var allergens: String = ""
    @State private var caloriesPerPiece: String = ""
    @State private var bakingTemperature: String = ""
    @State private var bakingTimeMinutes: String = ""
    @State private var shelfLifeDays: String = ""
    @State private var packagingType: String = ""
    @State private var packagingWeight: String = ""
    @State private var storageInstructions: String = ""
    @State private var manufactureDate: Date = Date()
    @State private var expiryDate: Date = Calendar.current.date(byAdding: .day, value: 180, to: Date())!
    @State private var batchCode: String = ""
    @State private var brandName: String = ""
    @State private var category: String = ""
    @State private var subCategory: String = ""
    @State private var qualityGrade: String = "A"
    @State private var moistureContent: String = ""
    @State private var crispnessScore: Int = 8
    @State private var notes: String = ""
    @State private var imageName: String = "biscuit_default"
    @State private var tags: String = ""
    @State private var rating: String = ""
    @State private var createdBy: String = "User"
    @State private var isFavorite: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    private func validateAndSave() {
        var errors: [String] = []
        
        if sku.isEmpty { errors.append("SKU is required.") }
        if name.isEmpty { errors.append("Name is required.") }
        if flavor.isEmpty { errors.append("Flavor is required.") }
        if shape.isEmpty { errors.append("Shape is required.") }
        if texture.isEmpty { errors.append("Texture is required.") }
        if brandName.isEmpty { errors.append("Brand Name is required.") }
        if packagingType.isEmpty { errors.append("Packaging Type is required.") }
        if ingredients.isEmpty { errors.append("Ingredients are required.") }
        if allergens.isEmpty { errors.append("Allergens are required.") }
        if category.isEmpty { errors.append("Category is required.") }
        if subCategory.isEmpty { errors.append("SubCategory is required.") }
        
        let caloriesInt = Int(caloriesPerPiece)
        if caloriesInt == nil || caloriesInt! <= 0 { errors.append("Calories must be a positive integer.") }
        
        let tempInt = Int(bakingTemperature)
        if tempInt == nil || tempInt! <= 0 { errors.append("Baking Temp must be a positive integer.") }
        
        let timeInt = Int(bakingTimeMinutes)
        if timeInt == nil || timeInt! <= 0 { errors.append("Baking Time must be a positive integer.") }
        
        let shelfLifeInt = Int(shelfLifeDays)
        if shelfLifeInt == nil || shelfLifeInt! <= 0 { errors.append("Shelf Life must be a positive integer.") }
        
        let weightInt = Int(packagingWeight)
        if weightInt == nil || weightInt! <= 0 { errors.append("Packaging Weight must be a positive integer.") }
        
        let moistureDouble = Double(moistureContent)
        if moistureDouble == nil || moistureDouble! <= 0 { errors.append("Moisture Content must be a positive number.") }
        
        let ratingDouble = Double(rating)
        if ratingDouble == nil || ratingDouble! < 0 || ratingDouble! > 5 { errors.append("Rating must be between 0 and 5.") }
        
        if expiryDate <= manufactureDate { errors.append("Expiry Date must be after Manufacture Date.") }
        
        if errors.isEmpty {
            let newListing = BiscuitListing(
                sku: sku,
                name: name,
                flavor: flavor,
                shape: shape,
                size: size,
                texture: texture,
                color: color,
                sweetnessLevel: sweetnessLevel,
                ingredients: ingredients.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty },
                allergens: allergens.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty },
                caloriesPerPiece: caloriesInt ?? 1,
                bakingTemperature: tempInt ?? 180,
                bakingTimeMinutes: timeInt ?? 15,
                shelfLifeDays: shelfLifeInt ?? 180,
                packagingType: packagingType,
                packagingWeight: weightInt ?? 0,
                storageInstructions: storageInstructions,
                manufactureDate: manufactureDate,
                expiryDate: expiryDate,
                batchCode: batchCode.isEmpty ? "TEMP-BATCH" : batchCode,
                brandName: brandName,
                category: category,
                subCategory: subCategory,
                qualityGrade: qualityGrade,
                moistureContent: moistureDouble ?? 0.0,
                crispnessScore: crispnessScore,
                notes: notes,
                imageName: imageName,
                tags: tags.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty },
                rating: ratingDouble ?? 0.0,
                createdBy: createdBy,
                createdAt: Date(),
                updatedAt: Date(),
                isFavorite: isFavorite
            )
            dataStore.addBiscuitListing(newListing)
            
            alertMessage = "Successfully added **\(name)** listing!"
            showAlert = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                presentationMode.wrappedValue.dismiss()
            }
        } else {
            alertMessage = "Please fix the following errors:\n\n" + errors.joined(separator: "\n")
            showAlert = true
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    BiscuitListingAddSectionHeaderView(title: "Core Product Details", iconName: "tag.fill")
                    
                    VStack(spacing: 15) {
                        BiscuitListingAddFieldView(title: "Product Name", iconName: "a.square.fill", placeholder: "e.g., Choco Crunch", text: $name)
                        BiscuitListingAddFieldView(title: "SKU Code", iconName: "barcode", placeholder: "e.g., BIS-001", text: $sku)
                        BiscuitListingAddFieldView(title: "Brand Name", iconName: "building.2.fill", placeholder: "e.g., Crunchy Delights", text: $brandName)
                        
                        HStack {
                            BiscuitListingAddFieldView(title: "Category", iconName: "folder.fill", placeholder: "e.g., Cookies", text: $category)
                            BiscuitListingAddFieldView(title: "Sub Category", iconName: "folder.open.fill", placeholder: "e.g., Chocolate", text: $subCategory)
                        }
                        
                        HStack {
                            BiscuitListingAddFieldView(title: "Flavor", iconName: "face.smiling.fill", placeholder: "e.g., Chocolate", text: $flavor)
                            BiscuitListingAddFieldView(title: "Shape", iconName: "diamond.fill", placeholder: "e.g., Round", text: $shape)
                        }
                        
                        BiscuitListingAddIntPickerView(title: "Sweetness (1-10)", iconName: "sugar.cube.fill", value: $sweetnessLevel, range: 1...10)
                    }
                    
                    BiscuitListingAddSectionHeaderView(title: "Physical Attributes", iconName: "ruler.fill")
                    
                    VStack(spacing: 15) {
                        HStack {
                            BiscuitListingAddFieldView(title: "Size", iconName: "ruler", placeholder: "e.g., Medium", text: $size)
                            BiscuitListingAddFieldView(title: "Texture", iconName: "checkerboard.rectangle", placeholder: "e.g., Crispy", text: $texture)
                        }
                        BiscuitListingAddFieldView(title: "Color", iconName: "paintpalette.fill", placeholder: "e.g., Brown", text: $color)
                        
                        HStack {
                            BiscuitListingAddFieldView(title: "Moisture Content (%)", iconName: "drop.fill", placeholder: "e.g., 3.5", text: $moistureContent, keyboardType: .decimalPad)
                            BiscuitListingAddIntPickerView(title: "Crispness (1-10)", iconName: "hand.tap.fill", value: $crispnessScore, range: 1...10)
                        }
                    }
                    
                    BiscuitListingAddSectionHeaderView(title: "Ingredients & Health", iconName: "cross.case.fill")
                    
                    VStack(spacing: 15) {
                        BiscuitListingAddFieldView(title: "Ingredients (comma-separated)", iconName: "list.bullet.rectangle", placeholder: "e.g., Wheat, Sugar, Cocoa", text: $ingredients)
                        BiscuitListingAddFieldView(title: "Allergens (comma-separated)", iconName: "exclamationmark.triangle.fill", placeholder: "e.g., Gluten, Milk", text: $allergens)
                        
                        HStack {
                            BiscuitListingAddFieldView(title: "Calories/Piece", iconName: "flame.fill", placeholder: "e.g., 50", text: $caloriesPerPiece, keyboardType: .numberPad)
                            BiscuitListingAddFieldView(title: "Rating (0-5)", iconName: "star.fill", placeholder: "e.g., 4.8", text: $rating, keyboardType: .decimalPad)
                        }
                    }
                    
                    BiscuitListingAddSectionHeaderView(title: "Production & Logistics", iconName: "gearshape.fill")
                    
                    VStack(spacing: 15) {
                        HStack {
                            BiscuitListingAddFieldView(title: "Baking Temp (°C)", iconName: "thermometer", placeholder: "e.g., 180", text: $bakingTemperature, keyboardType: .numberPad)
                            BiscuitListingAddFieldView(title: "Baking Time (min)", iconName: "clock.fill", placeholder: "e.g., 15", text: $bakingTimeMinutes, keyboardType: .numberPad)
                        }
                        
                        HStack {
                            BiscuitListingAddFieldView(title: "Shelf Life (Days)", iconName: "calendar.badge.clock", placeholder: "e.g., 180", text: $shelfLifeDays, keyboardType: .numberPad)
                            BiscuitListingAddFieldView(title: "Packaging Type", iconName: "shippingbox.fill", placeholder: "e.g., Wrapper", text: $packagingType)
                        }
                        
                        HStack {
                            BiscuitListingAddFieldView(title: "Packaging Weight (g)", iconName: "scalemass.fill", placeholder: "e.g., 200", text: $packagingWeight, keyboardType: .numberPad)
                            BiscuitListingAddFieldView(title: "Storage Instructions", iconName: "snowflake", placeholder: "e.g., Cool, Dry Place", text: $storageInstructions)
                        }
                        
                        HStack {
                            BiscuitListingAddDatePickerView(title: "Manufacture Date", iconName: "calendar.badge.plus", date: $manufactureDate)
                            BiscuitListingAddDatePickerView(title: "Expiry Date", iconName: "calendar.badge.minus", date: $expiryDate)
                        }
                        
                        BiscuitListingAddFieldView(title: "Batch Code", iconName: "number.square.fill", placeholder: "e.g., BATCH-A1", text: $batchCode, isRequired: false)
                        BiscuitListingAddFieldView(title: "Quality Grade", iconName: "seal.fill", placeholder: "e.g., A", text: $qualityGrade, isRequired: false)
                        BiscuitListingAddFieldView(title: "Notes", iconName: "pencil.and.outline", placeholder: "e.g., Best with tea", text: $notes, isRequired: false)
                    }
                    
                    Toggle(isOn: $isFavorite) {
                        Text("Mark as Favorite")
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1))
                    .padding(.horizontal)
                    
                    Button(action: validateAndSave) {
                        Text("Save New Biscuit Listing")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.green)
                                    .shadow(color: Color.green.opacity(0.5), radius: 8, x: 0, y: 5)
                            )
                            .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .padding(.bottom, 20)
                
            }
            .navigationTitle("New Biscuit Listing")
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertMessage.contains("Successfully") ? "Success" : "Validation Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

@available(iOS 14.0, *)
struct BiscuitListingSearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
                .scaleEffect(isEditing ? 1.2 : 1.0)
            
            TextField("Search biscuits by name or SKU...", text: $searchText, onEditingChanged: { editing in
                withAnimation {
                    self.isEditing = editing
                }
            })
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            if isEditing && !searchText.isEmpty {
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
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding([.horizontal, .top])
    }
}

@available(iOS 14.0, *)
struct DataPoint: View {
        
    let icon: String
    let key: String
    var value: String
    var accent: Color
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
                .foregroundColor(accent)
            Text("\(key):")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Text(value)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
}
@available(iOS 14.0, *)
struct BiscuitListingListRowView: View {
    let listing: BiscuitListing
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Text(listing.name.uppercased())
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(String(format: "%.1f", listing.rating))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Image(systemName: listing.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                    .scaleEffect(1.2)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue)
            )
            
            VStack(alignment: .leading, spacing: 10) {
                
                HStack(alignment: .top) {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        
                        DataPoint(icon: "barcode", key: "SKU", value: listing.sku, accent: Color.blue)
                        DataPoint(icon: "tag.circle.fill", key: "Brand", value: listing.brandName, accent: .blue)
                        DataPoint(icon: "flame.fill", key: "Calories", value: "\(listing.caloriesPerPiece) cal", accent: .red)
                        DataPoint(icon: "thermometer", key: "Bake Temp", value: "\(listing.bakingTemperature)°C", accent: .red)
                        DataPoint(icon: "timer", key: "Bake Time", value: "\(listing.bakingTimeMinutes)m", accent: .red)
                        DataPoint(icon: "heart.text.square.fill", key: "Allergens", value: listing.allergens.joined(separator: ", "), accent: .red)
                        DataPoint(icon: "square.text.square.fill", key: "Batch", value: listing.batchCode, accent: .blue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 1, height: 120)
                        .padding(.horizontal, 8)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        DataPoint(icon: "ruler", key: "Size/Shape", value: "\(listing.size)/\(listing.shape)", accent: .green)
                        DataPoint(icon: "checkerboard.rectangle", key: "Texture/Color", value: "\(listing.texture)/\(listing.color)", accent: .green)
                        DataPoint(icon: "sugar.cube.fill", key: "Sweetness", value: "\(listing.sweetnessLevel)/10", accent: .green)
                        DataPoint(icon: "drop.fill", key: "Moisture", value: String(format: "%.1f%%", listing.moistureContent), accent: .green)
                        DataPoint(icon: "seal.fill", key: "Grade", value: listing.qualityGrade, accent: .purple)
                        DataPoint(icon: "calendar.badge.clock", key: "Shelf Life", value: "\(listing.shelfLifeDays) days", accent: .purple)
                        DataPoint(icon: "calendar.badge.minus", key: "Expiry", value: listing.expiryDate.formattedForDisplay(), accent: .purple)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Divider()
                HStack {
                    Image(systemName: "note.text")
                        .foregroundColor(.secondary)
                    Text("Notes:")
                        .font(.caption2)
                        .fontWeight(.bold)
                    Text(listing.notes.isEmpty ? "No specific notes." : listing.notes)
                        .font(.caption)
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.top, 5)
            }
            .padding(15)
            .background(Color.white)
        }
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 4)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct BiscuitListingNoDataView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(Color.gray.opacity(0.5))
            
            Text("No Biscuit Listings Found")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            
            Text("Try refining your search or add a new biscuit listing to the factory inventory.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 50)
    }
}

@available(iOS 14.0, *)
struct BiscuitListingListView: View {
    @ObservedObject var dataStore: BiscuitFactoryDataStore
    @State private var searchText: String = ""
    @State private var showingAddView: Bool = false
    
    var filteredListings: [BiscuitListing] {
        if searchText.isEmpty {
            return dataStore.biscuitListings
        } else {
            return dataStore.biscuitListings.filter { listing in
                listing.name.localizedCaseInsensitiveContains(searchText) ||
                listing.sku.localizedCaseInsensitiveContains(searchText) ||
                listing.flavor.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                
                BiscuitListingSearchBarView(searchText: $searchText)
                
                if filteredListings.isEmpty {
                    BiscuitListingNoDataView()
                } else {
                    List {
                        ForEach(filteredListings) { listing in
                            NavigationLink(destination: BiscuitListingDetailView(listing: listing)) {
                                BiscuitListingListRowView(listing: listing)
                                    .padding(.vertical, 5)
                            }
                            .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Biscuit Listings")
            .navigationBarItems(
                trailing:
                    Button(action: { showingAddView = true }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                    }
            )
            .sheet(isPresented: $showingAddView) {
                BiscuitListingAddView(dataStore : dataStore)
            }
        
    }
    
    private func deleteItems(offsets: IndexSet) {
        let listingsToDelete = offsets.map { filteredListings[$0] }
        
        for listing in listingsToDelete {
            if let index = dataStore.biscuitListings.firstIndex(where: { $0.id == listing.id }) {
                dataStore.biscuitListings.remove(at: index)
            }
        }
    }
}

@available(iOS 14.0, *)
struct BiscuitListingDetailFieldRow: View {
    let key: String
    let value: String
    let iconName: String
    let accentColor: Color
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: iconName)
                .foregroundColor(accentColor)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(key)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 5)
            
            Spacer()
        }
    }
}

@available(iOS 14.0, *)
struct BiscuitListingDetailBlock: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.orange)
                .shadow(color: Color.orange.opacity(0.3), radius: 5, x: 0, y: 3)
        )
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct BiscuitListingDetailView: View {
    let listing: BiscuitListing
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                VStack(spacing: 5) {
                    Text(listing.name)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    Text("SKU: \(listing.sku) | Batch: \(listing.batchCode)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", listing.rating))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 5)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(Color.blue)
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    BiscuitListingDetailBlock(title: "Identity & Branding", icon: "tag.fill")
                    
                    VStack(spacing: 15) {
                        HStack(alignment: .top) {
                            VStack(spacing: 15) {
                                BiscuitListingDetailFieldRow(key: "Brand Name", value: listing.brandName, iconName: "building.2.fill", accentColor: .blue)
                                BiscuitListingDetailFieldRow(key: "Category", value: listing.category, iconName: "folder.fill", accentColor: .blue)
                                BiscuitListingDetailFieldRow(key: "Sub Category", value: listing.subCategory, iconName: "folder.open.fill", accentColor: .blue)
                                BiscuitListingDetailFieldRow(key: "Image Name", value: listing.imageName, iconName: "photo.fill", accentColor: .blue)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 15) {
                                BiscuitListingDetailFieldRow(key: "Flavor", value: listing.flavor, iconName: "face.smiling.fill", accentColor: .blue)
                                BiscuitListingDetailFieldRow(key: "Shape", value: listing.shape, iconName: "diamond.fill", accentColor: .blue)
                                BiscuitListingDetailFieldRow(key: "Size", value: listing.size, iconName: "ruler", accentColor: .blue)
                                BiscuitListingDetailFieldRow(key: "Color", value: listing.color, iconName: "paintpalette.fill", accentColor: .blue)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    BiscuitListingDetailBlock(title: "Ingredients & Nutritional", icon: "leaf.fill")
                    
                    VStack(spacing: 15) {
                        HStack(alignment: .top) {
                            VStack(spacing: 15) {
                                BiscuitListingDetailFieldRow(key: "Sweetness Level", value: "\(listing.sweetnessLevel)/10", iconName: "sugar.cube.fill", accentColor: .green)
                                BiscuitListingDetailFieldRow(key: "Calories Per Piece", value: "\(listing.caloriesPerPiece) cal", iconName: "flame.fill", accentColor: .green)
                                BiscuitListingDetailFieldRow(key: "Allergens", value: listing.allergens.joined(separator: ", "), iconName: "exclamationmark.triangle.fill", accentColor: .green)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 15) {
                                BiscuitListingDetailFieldRow(key: "Moisture Content", value: String(format: "%.1f%%", listing.moistureContent), iconName: "drop.fill", accentColor: .green)
                                BiscuitListingDetailFieldRow(key: "Crispness Score", value: "\(listing.crispnessScore)/10", iconName: "hand.tap.fill", accentColor: .green)
                                BiscuitListingDetailFieldRow(key: "Ingredients", value: listing.ingredients.joined(separator: ", "), iconName: "list.bullet.rectangle", accentColor: .green)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    BiscuitListingDetailBlock(title: "Production Timeline", icon: "timer")
                    
                    VStack(spacing: 15) {
                        HStack(alignment: .top) {
                            VStack(spacing: 15) {
                                BiscuitListingDetailFieldRow(key: "Baking Temperature", value: "\(listing.bakingTemperature) °C", iconName: "thermometer", accentColor: .purple)
                                BiscuitListingDetailFieldRow(key: "Baking Time", value: "\(listing.bakingTimeMinutes) mins", iconName: "clock.fill", accentColor: .purple)
                                BiscuitListingDetailFieldRow(key: "Manufacture Date", value: listing.manufactureDate.formattedForDisplay(), iconName: "calendar.badge.plus", accentColor: .purple)
                                BiscuitListingDetailFieldRow(key: "Expiry Date", value: listing.expiryDate.formattedForDisplay(), iconName: "calendar.badge.minus", accentColor: .purple)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 15) {
                                BiscuitListingDetailFieldRow(key: "Shelf Life", value: "\(listing.shelfLifeDays) days", iconName: "hourglass.badge.fill", accentColor: .purple)
                                BiscuitListingDetailFieldRow(key: "Quality Grade", value: listing.qualityGrade, iconName: "seal.fill", accentColor: .purple)
                                BiscuitListingDetailFieldRow(key: "Created By", value: listing.createdBy, iconName: "person.fill", accentColor: .purple)
                                BiscuitListingDetailFieldRow(key: "Is Favorite", value: listing.isFavorite ? "Yes" : "No", iconName: listing.isFavorite ? "heart.fill" : "heart", accentColor: .purple)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    BiscuitListingDetailBlock(title: "Packaging & Storage", icon: "shippingbox.fill")
                    
                    VStack(spacing: 15) {
                        HStack(alignment: .top) {
                            VStack(spacing: 15) {
                                BiscuitListingDetailFieldRow(key: "Packaging Type", value: listing.packagingType, iconName: "box.truck.fill", accentColor: Color(red: 0.3, green: 0.3, blue: 0.9))
                                BiscuitListingDetailFieldRow(key: "Packaging Weight", value: "\(listing.packagingWeight)g", iconName: "scalemass.fill", accentColor: Color(red: 0.3, green: 0.3, blue: 0.9))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 15) {
                                BiscuitListingDetailFieldRow(key: "Storage Instructions", value: listing.storageInstructions, iconName: "snowflake", accentColor: Color(red: 0.3, green: 0.3, blue: 0.9))
                                BiscuitListingDetailFieldRow(key: "Tags", value: listing.tags.joined(separator: ", "), iconName: "bookmark.fill", accentColor: Color(red: 0.3, green: 0.3, blue: 0.9))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Notes")
                            .font(.headline)
                            .padding(.top)
                        Text(listing.notes.isEmpty ? "No detailed notes provided for this listing." : listing.notes)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    BiscuitListingDetailBlock(title: "Audit Information", icon: "slider.horizontal.3")
                    
                    VStack(spacing: 15) {
                        HStack(alignment: .top) {
                            VStack(spacing: 15) {
                                BiscuitListingDetailFieldRow(key: "Created At", value: listing.createdAt.formattedForDisplay(), iconName: "calendar.circle.fill", accentColor: .secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 15) {
                                BiscuitListingDetailFieldRow(key: "Updated At", value: listing.updatedAt.formattedForDisplay(), iconName: "arrow.2.circlepath", accentColor: .secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle(listing.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
}
