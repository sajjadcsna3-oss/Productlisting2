import SwiftUI
import CoreData
@main
struct Productlisting2: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var router = Router()

    private var repository: ProductRepositoryProtocol {
        ProductRepository(
            networkService: NetworkManager(),
            context: persistenceController.container.viewContext
        )
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                SplashView(repository: repository)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .productList:
                            ProductListView(
                                viewModel: ProductListViewModel(repository: repository),
                                repository: repository
                            )

                        case .productDetail(let id):
                            ProductDetailView(
                                productID: id,
                                repository: repository
                            )

                        case .favorites:
                            FavoritesView(repository: repository)
                        }
                    }
            }
            .environmentObject(router)
        }
    }
}
