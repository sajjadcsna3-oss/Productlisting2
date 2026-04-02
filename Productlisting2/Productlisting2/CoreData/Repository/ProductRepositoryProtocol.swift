import Foundation
import Combine

protocol ProductRepositoryProtocol {
    func fetchProducts() -> AnyPublisher<[Product], NetworkError>
    func fetchProductDetail(id: Int) -> AnyPublisher<Product, NetworkError>
    func fetchCategories() -> AnyPublisher<[String], NetworkError>
    func fetchFavoriteProducts() -> AnyPublisher<[Product], NetworkError>

    func isFavorite(productId: Int) -> Bool
    func toggleFavorite(product: Product)
}
