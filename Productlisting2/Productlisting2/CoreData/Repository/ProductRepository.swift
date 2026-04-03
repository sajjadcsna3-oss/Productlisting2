import Foundation
import Combine
import CoreData

final class ProductRepository: ProductRepositoryProtocol {
    private let networkService: NetworkService
    private let context: NSManagedObjectContext
    private let favoriteIDsKey = "favorite_product_ids"

    init(networkService: NetworkService, context: NSManagedObjectContext) {
        self.networkService = networkService
        self.context = context
    }

    func fetchProducts() -> AnyPublisher<[Product], NetworkError> {
        networkService.request(endpoint: ProductEndpoint.products)
            .map { [weak self] (response: ProductListResponse) in
                guard let self = self else { return response.products }

                return response.products.map { product in
                    var updated = product
                    updated.isFavorite = self.isFavorite(productId: product.id)
                    return updated
                }
            }
            .eraseToAnyPublisher()
    }

    func fetchProductDetail(id: Int) -> AnyPublisher<Product, NetworkError> {
        networkService.request(endpoint: ProductEndpoint.productDetail(id: id))
            .map { [weak self] (product: Product) in
                guard let self = self else { return product }

                var updated = product
                updated.isFavorite = self.isFavorite(productId: product.id)
                return updated
            }
            .eraseToAnyPublisher()
    }

    func fetchCategories() -> AnyPublisher<[String], NetworkError> {
        networkService.request(endpoint: ProductEndpoint.categories)
    }

    func fetchFavoriteProducts() -> AnyPublisher<[Product], NetworkError> {
        fetchProducts()
            .map { products in
                products.filter { $0.isFavorite }
            }
            .eraseToAnyPublisher()
    }

    func isFavorite(productId: Int) -> Bool {
        favoriteIDs().contains(productId)
    }

    func toggleFavorite(product: Product) {
        var ids = favoriteIDs()

        if ids.contains(product.id) {
            ids.remove(product.id)
        } else {
            ids.insert(product.id)
        }

        UserDefaults.standard.set(Array(ids), forKey: favoriteIDsKey)
    }

    private func favoriteIDs() -> Set<Int> {
        let ids = UserDefaults.standard.array(forKey: favoriteIDsKey) as? [Int] ?? []
        return Set(ids)
    }
}
