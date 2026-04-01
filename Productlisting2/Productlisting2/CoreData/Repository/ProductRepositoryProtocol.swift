import Foundation
import Combine

protocol ProductRepositoryProtocol {
func fetchProducts() -> AnyPublisher<[Product], Error>
func fetchProductDetail(id: Int) -> AnyPublisher<Product, Error>
func fetchCategories() -> AnyPublisher<[String], Error>

func fetchFavoriteProducts() -> AnyPublisher<[Product], Error>

func isFavorite(productId: Int) -> Bool
func toggleFavorite(product: Product)
}
