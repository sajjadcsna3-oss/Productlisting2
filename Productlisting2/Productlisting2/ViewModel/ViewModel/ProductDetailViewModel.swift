import Foundation
import Combine

final class ProductDetailViewModel: ObservableObject {
    @Published private(set) var product: Product?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var isFavorite = false

    let repository: ProductRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }

    func fetchProductDetail(id: Int) {
        print("🟡 DetailViewModel: fetchProductDetail started for id \(id)")
        isLoading = true
        errorMessage = nil

        repository.fetchProductDetail(id: id)
            .sink { [weak self] completion in
                self?.isLoading = false

                switch completion {
                case .finished:
                    print("✅ DetailViewModel: fetchProductDetail finished")
                case .failure(let error):
                    print("❌ DetailViewModel: fetchProductDetail failed: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] product in
                print("✅ DetailViewModel: received product \(product.title)")
                self?.product = product
                self?.isFavorite = product.isFavorite
            }
            .store(in: &cancellables)
    }

    func toggleFavorite() {
        guard let product = product else { return }

        repository.toggleFavorite(product: product)
        isFavorite.toggle()

        var updated = product
        updated.isFavorite = isFavorite
        self.product = updated
    }
}
