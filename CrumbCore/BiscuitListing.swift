import Combine
import Foundation
import SwiftUI

// MARK: - Biscuit Listing
struct BiscuitListing: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var sku: String
    var name: String
    var flavor: String
    var shape: String
    var size: String
    var texture: String
    var color: String
    var sweetnessLevel: Int
    var ingredients: [String]
    var allergens: [String]
    var caloriesPerPiece: Int
    var bakingTemperature: Int
    var bakingTimeMinutes: Int
    var shelfLifeDays: Int
    var packagingType: String
    var packagingWeight: Int
    var storageInstructions: String
    var manufactureDate: Date
    var expiryDate: Date
    var batchCode: String
    var brandName: String
    var category: String
    var subCategory: String
    var qualityGrade: String
    var moistureContent: Double
    var crispnessScore: Int
    var notes: String
    var imageName: String
    var tags: [String]
    var rating: Double
    var createdBy: String
    var createdAt: Date
    var updatedAt: Date
    var isFavorite: Bool
}

// MARK: - Inventory Item
struct InventoryItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var itemCode: String
    var name: String
    var category: String
    var subCategory: String
    var unit: String
    var quantity: Int
    var minStockLevel: Int
    var maxStockLevel: Int
    var reorderQuantity: Int
    var supplierName: String
    var supplierContact: String
    var purchasePrice: Double
    var totalValue: Double
    var batchNumber: String
    var dateReceived: Date
    var expiryDate: Date
    var location: String
    var storageCondition: String
    var status: String
    var notes: String
    var imageName: String
    var barcode: String
    var brand: String
    var weightGrams: Int
    var volumeLiters: Double
    var lastChecked: Date
    var isActive: Bool
    var createdBy: String
    var createdAt: Date
    var updatedAt: Date
    var tags: [String]
    var usageFrequency: Int
    var unitCost: Double
    var lastUsedDate: Date
}

// MARK: - Production Batch
struct ProductionBatch: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var batchCode: String
    var listingSKU: String
    var productName: String
    var producedDate: Date
    var shift: String
    var producedQuantity: Int
    var rejectedQuantity: Int
    var operatorName: String
    var supervisorName: String
    var lineNumber: String
    var ingredientsUsed: [String]
    var machineUsed: String
    var bakingTemp: Int
    var bakingDurationMinutes: Int
    var coolingTimeMinutes: Int
    var packagingDate: Date
    var expiryDate: Date
    var moistureLevel: Double
    var qualityGrade: String
    var inspectionPassed: Bool
    var remarks: String
    var recordedBy: String
    var verifiedBy: String
    var batchCost: Double
    var unitCost: Double
    var productionNotes: String
    var imageName: String
    var category: String
    var lotNumber: String
    var location: String
    var tags: [String]
    var createdAt: Date
    var updatedAt: Date
    var isArchived: Bool
}

struct AuditLogEntry: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var timestamp: Date
    var actor: String
    var role: String
    var action: String
    var affectedModule: String
    var referenceID: String
    var description: String
    var deviceName: String
    var osVersion: String
    var appVersion: String
    var location: String
    var ipAddress: String
    var changeType: String
    var oldValue: String
    var newValue: String
    var success: Bool
    var errorMessage: String
    var reviewedBy: String
    var reviewDate: Date
    var category: String
    var severity: String
    var logSource: String
    var comments: String
    var tags: [String]
    var createdAt: Date
    var updatedAt: Date
    var archived: Bool
    var sessionID: String
    var requestID: String
    var deviceID: String
    var dataSizeBytes: Int
    var durationMs: Int
    var resultCode: String
    var backupStatus: String
    var exportStatus: String
}

// MARK: - Category
struct Category: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var description: String
    var colorHex: String
    var iconName: String
    var parentCategory: String
    var displayOrder: Int
    var isVisible: Bool
    var createdBy: String
    var createdAt: Date
    var updatedAt: Date
    var itemCount: Int
    var notes: String
    var tags: [String]
    var relatedCategories: [String]
    var popularityScore: Int
    var seasonal: Bool
    var featured: Bool
    var lastUsed: Date
    var usageCount: Int
    var version: String
    var region: String
    var productExamples: [String]
    var categoryCode: String
    var weight: Double
    var grade: String
    var approvalStatus: String
    var remarks: String
    var relatedSKUs: [String]
    var archived: Bool
    var assignedBy: String
    var reviewDate: Date
    var importanceLevel: Int
    var sortOrder: Int
    var aliasNames: [String]
    var seoKeywords: [String]
    var backgroundImage: String
    var status: String
}

// MARK: - Supplier
struct Supplier: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var supplierCode: String
    var name: String
    var contactPerson: String
    var contactNumber: String
    var email: String
    var address: String
    var city: String
    var region: String
    var postalCode: String
    var country: String
    var materialsSupplied: [String]
    var rating: Double
    var paymentTerms: String
    var deliveryTimeDays: Int
    var preferred: Bool
    var lastDeliveryDate: Date
    var nextExpectedDelivery: Date
    var notes: String
    var website: String
    var taxID: String
    var bankName: String
    var accountNumber: String
    var branchCode: String
    var swiftCode: String
    var creditLimit: Double
    var outstandingBalance: Double
    var createdAt: Date
    var updatedAt: Date
    var createdBy: String
    var lastContacted: Date
    var tags: [String]
    var documents: [String]
    var imageName: String
    var activeStatus: Bool
    var reliabilityScore: Int
}
import Foundation
import Combine
import SwiftUI

@available(iOS 14.0, *)
class BiscuitFactoryDataStore: ObservableObject {
    // MARK: - Published Arrays
    @Published var biscuitListings: [BiscuitListing] = [] {
        didSet { saveData(forKey: "biscuitListings", data: biscuitListings) }
    }
    @Published var inventoryItems: [InventoryItem] = [] {
        didSet { saveData(forKey: "inventoryItems", data: inventoryItems) }
    }
    @Published var productionBatches: [ProductionBatch] = [] {
        didSet { saveData(forKey: "productionBatches", data: productionBatches) }
    }
    @Published var auditLogs: [AuditLogEntry] = [] {
        didSet { saveData(forKey: "auditLogs", data: auditLogs) }
    }
    @Published var categories: [Category] = [] {
        didSet { saveData(forKey: "categories", data: categories) }
    }
    @Published var suppliers: [Supplier] = [] {
        didSet { saveData(forKey: "suppliers", data: suppliers) }
    }

    // MARK: - Init
    init() {
        loadAllData()
    }

    // MARK: - Add Functions
    func addBiscuitListing(_ listing: BiscuitListing) {
        biscuitListings.append(listing)
    }

    func addInventoryItem(_ item: InventoryItem) {
        inventoryItems.append(item)
    }

    func addProductionBatch(_ batch: ProductionBatch) {
        productionBatches.append(batch)
    }

    func addAuditLog(_ log: AuditLogEntry) {
        auditLogs.append(log)
    }

    func addCategory(_ category: Category) {
        categories.append(category)
    }

    func addSupplier(_ supplier: Supplier) {
        suppliers.append(supplier)
    }

    // MARK: - Delete Functions
    func deleteBiscuitListing(at offsets: IndexSet) {
        biscuitListings.remove(atOffsets: offsets)
    }

    func deleteInventoryItem(at offsets: IndexSet) {
        inventoryItems.remove(atOffsets: offsets)
    }

    func deleteProductionBatch(at offsets: IndexSet) {
        productionBatches.remove(atOffsets: offsets)
    }

    func deleteAuditLog(at offsets: IndexSet) {
        auditLogs.remove(atOffsets: offsets)
    }

    func deleteCategory(at offsets: IndexSet) {
        categories.remove(atOffsets: offsets)
    }

    func deleteSupplier(at offsets: IndexSet) {
        suppliers.remove(atOffsets: offsets)
    }

    // MARK: - UserDefaults Helpers
    private func saveData<T: Codable>(forKey key: String, data: T) {
        do {
            let encoded = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encoded, forKey: key)
        } catch {
            print("Error saving \(key): \(error)")
        }
    }

    private func loadData<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error loading \(key): \(error)")
            return nil
        }
    }

    // MARK: - Load All Data
    func loadAllData() {
        if let savedListings = loadData(forKey: "biscuitListings", as: [BiscuitListing].self) {
            biscuitListings = savedListings
        } else {
            biscuitListings = generateDummyBiscuitListings()
        }

        if let savedItems = loadData(forKey: "inventoryItems", as: [InventoryItem].self) {
            inventoryItems = savedItems
        } else {
            inventoryItems = generateDummyInventoryItems()
        }

        if let savedBatches = loadData(forKey: "productionBatches", as: [ProductionBatch].self) {
            productionBatches = savedBatches
        } else {
            productionBatches = generateDummyProductionBatches()
        }

        if let savedLogs = loadData(forKey: "auditLogs", as: [AuditLogEntry].self) {
            auditLogs = savedLogs
        } else {
            auditLogs = generateDummyAuditLogs()
        }

        if let savedCategories = loadData(forKey: "categories", as: [Category].self) {
            categories = savedCategories
        } else {
            categories = generateDummyCategories()
        }

        if let savedSuppliers = loadData(forKey: "suppliers", as: [Supplier].self) {
            suppliers = savedSuppliers
        } else {
            suppliers = generateDummySuppliers()
        }
    }

    // MARK: - Dummy Data Generators
    private func generateDummyBiscuitListings() -> [BiscuitListing] {
        return [
            BiscuitListing(
                sku: "BIS-001",
                name: "Choco Crunch",
                flavor: "Chocolate",
                shape: "Round",
                size: "Medium",
                texture: "Crispy",
                color: "Brown",
                sweetnessLevel: 8,
                ingredients: ["Wheat", "Sugar", "Cocoa"],
                allergens: ["Gluten"],
                caloriesPerPiece: 50,
                bakingTemperature: 180,
                bakingTimeMinutes: 15,
                shelfLifeDays: 180,
                packagingType: "Wrapper",
                packagingWeight: 200,
                storageInstructions: "Store in cool, dry place",
                manufactureDate: Date(),
                expiryDate: Calendar.current.date(byAdding: .day, value: 180, to: Date())!,
                batchCode: "BATCH-A1",
                brandName: "Crunchy Delights",
                category: "Cookies",
                subCategory: "Chocolate",
                qualityGrade: "A",
                moistureContent: 3.5,
                crispnessScore: 9,
                notes: "Best with tea",
                imageName: "biscuit1",
                tags: ["bestseller", "snack"],
                rating: 4.8,
                createdBy: "Admin",
                createdAt: Date(),
                updatedAt: Date(),
                isFavorite: true
            )
        ]
    }

    private func generateDummyInventoryItems() -> [InventoryItem] {
        return [
            InventoryItem(
                itemCode: "INV-1001",
                name: "Wheat Flour",
                category: "Raw Material",
                subCategory: "Flour",
                unit: "kg",
                quantity: 200,
                minStockLevel: 50,
                maxStockLevel: 500,
                reorderQuantity: 100,
                supplierName: "GrainCo Ltd",
                supplierContact: "0300-1234567",
                purchasePrice: 80.0,
                totalValue: 16000.0,
                batchNumber: "FLR-A1",
                dateReceived: Date(),
                expiryDate: Calendar.current.date(byAdding: .month, value: 12, to: Date())!,
                location: "Warehouse A",
                storageCondition: "Cool & Dry",
                status: "Available",
                notes: "High quality wheat flour",
                imageName: "flour",
                barcode: "123456789",
                brand: "GrainCo",
                weightGrams: 1000,
                volumeLiters: 1.0,
                lastChecked: Date(),
                isActive: true,
                createdBy: "Admin",
                createdAt: Date(),
                updatedAt: Date(),
                tags: ["baking", "flour"],
                usageFrequency: 10,
                unitCost: 80.0,
                lastUsedDate: Date()
            )
        ]
    }

    private func generateDummyProductionBatches() -> [ProductionBatch] {
        return [
            ProductionBatch(
                batchCode: "PB-001",
                listingSKU: "BIS-001",
                productName: "Choco Crunch",
                producedDate: Date(),
                shift: "Morning",
                producedQuantity: 1000,
                rejectedQuantity: 20,
                operatorName: "Ali Khan",
                supervisorName: "Sara Ahmed",
                lineNumber: "L1",
                ingredientsUsed: ["Flour", "Sugar", "Cocoa"],
                machineUsed: "Oven-X2",
                bakingTemp: 180,
                bakingDurationMinutes: 15,
                coolingTimeMinutes: 10,
                packagingDate: Date(),
                expiryDate: Calendar.current.date(byAdding: .day, value: 180, to: Date())!,
                moistureLevel: 3.2,
                qualityGrade: "A",
                inspectionPassed: true,
                remarks: "Excellent batch",
                recordedBy: "Admin",
                verifiedBy: "Supervisor",
                batchCost: 5000.0,
                unitCost: 5.0,
                productionNotes: "Smooth process",
                imageName: "batch1",
                category: "Chocolate",
                lotNumber: "LOT-A1",
                location: "Factory 1",
                tags: ["good", "verified"],
                createdAt: Date(),
                updatedAt: Date(),
                isArchived: false
            )
        ]
    }

    private func generateDummyAuditLogs() -> [AuditLogEntry] {
        return [
            AuditLogEntry(
                timestamp: Date(),
                actor: "Admin",
                role: "Manager",
                action: "Added New Listing",
                affectedModule: "BiscuitListing",
                referenceID: "BIS-001",
                description: "Added Choco Crunch biscuit listing",
                deviceName: "iPhone 13",
                osVersion: "iOS 14.8",
                appVersion: "1.0",
                location: "Lahore",
                ipAddress: "192.168.1.1",
                changeType: "Create",
                oldValue: "",
                newValue: "New record added",
                success: true,
                errorMessage: "",
                reviewedBy: "System",
                reviewDate: Date(),
                category: "System",
                severity: "Low",
                logSource: "App",
                comments: "Auto log",
                tags: ["info"],
                createdAt: Date(),
                updatedAt: Date(),
                archived: false,
                sessionID: "SESSION-1",
                requestID: "REQ-001",
                deviceID: "DEV-123",
                dataSizeBytes: 256,
                durationMs: 12,
                resultCode: "200",
                backupStatus: "Success",
                exportStatus: "Pending"
            )
        ]
    }

    private func generateDummyCategories() -> [Category] {
        return [
            Category(
                title: "Chocolate Biscuits",
                description: "All chocolate-based biscuits",
                colorHex: "#8B4513",
                iconName: "cube.box",
                parentCategory: "Biscuits",
                displayOrder: 1,
                isVisible: true,
                createdBy: "Admin",
                createdAt: Date(),
                updatedAt: Date(),
                itemCount: 10,
                notes: "Top selling category",
                tags: ["featured"],
                relatedCategories: ["Cookies"],
                popularityScore: 95,
                seasonal: false,
                featured: true,
                lastUsed: Date(),
                usageCount: 100,
                version: "1.0",
                region: "Pakistan",
                productExamples: ["Choco Crunch"],
                categoryCode: "CAT-001",
                weight: 1.0,
                grade: "A",
                approvalStatus: "Approved",
                remarks: "Stable category",
                relatedSKUs: ["BIS-001"],
                archived: false,
                assignedBy: "System",
                reviewDate: Date(),
                importanceLevel: 1,
                sortOrder: 1,
                aliasNames: ["Choco Treats"],
                seoKeywords: ["chocolate", "cookies"],
                backgroundImage: "category_bg",
                status: "Active"
            )
        ]
    }

    private func generateDummySuppliers() -> [Supplier] {
        return [
            Supplier(
                supplierCode: "SUP-001",
                name: "GrainCo Ltd",
                contactPerson: "Ali Raza",
                contactNumber: "0300-1112233",
                email: "contact@grainco.com",
                address: "123 Flour Street",
                city: "Karachi",
                region: "Sindh",
                postalCode: "75500",
                country: "Pakistan",
                materialsSupplied: ["Flour", "Sugar"],
                rating: 4.7,
                paymentTerms: "30 Days",
                deliveryTimeDays: 3,
                preferred: true,
                lastDeliveryDate: Date(),
                nextExpectedDelivery: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
                notes: "Reliable supplier",
                website: "https://grainco.com",
                taxID: "TX-1234",
                bankName: "HBL",
                accountNumber: "123456789",
                branchCode: "001",
                swiftCode: "HBLPKKAXXX",
                creditLimit: 100000.0,
                outstandingBalance: 20000.0,
                createdAt: Date(),
                updatedAt: Date(),
                createdBy: "Admin",
                lastContacted: Date(),
                tags: ["preferred"],
                documents: ["contract.pdf"],
                imageName: "supplier1",
                activeStatus: true,
                reliabilityScore: 90
            )
        ]
    }
}
