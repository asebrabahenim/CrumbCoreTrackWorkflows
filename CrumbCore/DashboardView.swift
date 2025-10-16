
import SwiftUI

@available(iOS 14.0, *)
struct DashboardView: View {
    @ObservedObject var dataStore = BiscuitFactoryDataStore()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    DashboardHeaderView()
                    
                    DashboardSectionView(
                        title: "Main Modules",
                        items: [
                            DashboardItem(title: "Biscuit Listings", icon: "circle.grid.3x3.fill", destination: AnyView(BiscuitListingListView(dataStore: dataStore))),
                            DashboardItem(title: "Inventory Items", icon: "shippingbox.fill", destination: AnyView(InventoryItemListView(dataStore: dataStore))),
                            DashboardItem(title: "Production Batches", icon: "gearshape.2.fill", destination: AnyView(ProductionBatchListView(dataStore: dataStore))),
                            DashboardItem(title: "Audit Logs", icon: "doc.text.magnifyingglass", destination: AnyView(AuditLogEntryListView(dataStore: dataStore))),
                            DashboardItem(title: "Categories", icon: "folder.fill", destination: AnyView(CategoryListView(dataStore: dataStore))),
                            DashboardItem(title: "Suppliers", icon: "person.3.fill", destination: AnyView(SupplierListView(dataStore: dataStore)))
                        ]
                    )
                }
                .padding()
            }
            .navigationTitle("🍪 Crumb Core ")
        }
    }
}

@available(iOS 14.0, *)
struct DashboardHeaderView: View {
    var body: some View {
        VStack(spacing: 6) {
            Text("Biscuit Factory Manager")
                .font(.title)
                .bold()
            Text("Offline Factory Management App")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBrown), .orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(20)
        .foregroundColor(.white)
        .shadow(radius: 4)
    }
}

@available(iOS 14.0, *)
struct DashboardSectionView: View {
    var title: String
    var items: [DashboardItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(items, id: \.title) { item in
                NavigationLink(destination: item.destination) {
                    HStack(spacing: 16) {
                        Image(systemName: item.icon)
                            .font(.system(size: 24))
                            .frame(width: 40, height: 40)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(10)
                        Text(item.title)
                            .font(.body)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct DashboardItem {
    var title: String
    var icon: String
    var destination: AnyView
}
