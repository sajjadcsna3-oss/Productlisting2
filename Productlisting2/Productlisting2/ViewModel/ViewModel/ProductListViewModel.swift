import Foundation
import Combine

final class ProductListViewModel: ObservableObject {
    @Published private(set) var displayedProducts: [Product] = []
    @Published private(set) var favoriteIDs: Set<Int> = []
    @Published private(set) var isLoading = false
    @Published private(set) var isLoadingMore = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var filterOptions: [FilterOption] = [.all]
    @Published var searchText: String = ""
    @Published var selectedFilter: FilterOption = .all

    private var allProducts: [Product] = []
    private var filteredProducts: [Product] = []

    private let repository: ProductRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    private let pageSize = 8
    private var currentPage = 1
    private var canLoadMore = true

    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
        bindSearchAndFilter()
        fetchCategories()
    }

    private func bindSearchAndFilter() {
        Publishers.CombineLatest($searchText, $selectedFilter)
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .sink { [weak self] _, _ in
                self?.applyFilters(resetPagination: true)
            }
            .store(in: &cancellables)
    }

    func fetchProducts() {
        isLoading = true
        errorMessage = nil

        repository.fetchProducts()
            .sink { [weak self] completion in
                self?.isLoading = false

                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] products in
                self?.allProducts = products
                self?.favoriteIDs = Set(products.filter { $0.isFavorite }.map { $0.id })
                self?.applyFilters(resetPagination: true)
            }
            .store(in: &cancellables)
    }

    func refresh() {
        currentPage = 1
        canLoadMore = true
        fetchProducts()
    }

    func loadMoreIfNeeded(currentItem item: Product) {
        guard let last = displayedProducts.last else { return }
        guard last.id == item.id else { return }
        guard canLoadMore else { return }
        guard !isLoadingMore else { return }

        loadNextPage()
    }

    private func loadNextPage() {
        guard filteredProducts.count > displayedProducts.count else {
            canLoadMore = false
            return
        }

        isLoadingMore = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let nextPage = self.currentPage + 1
            let nextItems = self.paginatedItems(from: self.filteredProducts, page: nextPage)

            if nextItems.isEmpty {
                self.canLoadMore = false
            } else {
                self.displayedProducts.append(contentsOf: nextItems)
                self.currentPage = nextPage
            }

            self.isLoadingMore = false
        }
    }

    private func paginatedItems(from products: [Product], page: Int) -> [Product] {
        let start = (page - 1) * pageSize
        guard start < products.count else { return [] }
        let end = min(start + pageSize, products.count)
        return Array(products[start..<end])
    }

    private func applyFilters(resetPagination: Bool) {
        var result = allProducts

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !query.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(query)
            }
        }

        switch selectedFilter {
        case .all:
            break
        case .category(let category):
            result = result.filter { $0.category.lowercased() == category.lowercased() }
        case .priceLowToHigh:
            result = result.sorted { $0.price < $1.price }
        case .priceHighToLow:
            result = result.sorted { $0.price > $1.price }
        }

        filteredProducts = result

        if resetPagination {
            currentPage = 1
            canLoadMore = true
            displayedProducts = paginatedItems(from: filteredProducts, page: 1)
        }
    }

    func toggleFavorite(product: Product) {
        repository.toggleFavorite(product: product)

        if favoriteIDs.contains(product.id) {
            favoriteIDs.remove(product.id)
        } else {
            favoriteIDs.insert(product.id)
        }

        updateFavoriteState(for: product.id)
    }

    func isFavorite(productId: Int) -> Bool {
        favoriteIDs.contains(productId)
    }

    private func updateFavoriteState(for productId: Int) {
        allProducts = allProducts.map { product in
            var updated = product
            if updated.id == productId {
                updated.isFavorite = favoriteIDs.contains(productId)
            }
            return updated
        }

        filteredProducts = filteredProducts.map { product in
            var updated = product
            if updated.id == productId {
                updated.isFavorite = favoriteIDs.contains(productId)
            }
            return updated
        }

        displayedProducts = displayedProducts.map { product in
            var updated = product
            if updated.id == productId {
                updated.isFavorite = favoriteIDs.contains(productId)
            }
            return updated
        }
    }

    private func fetchCategories() {
        repository.fetchCategories()
            .sink { _ in
            } receiveValue: { [weak self] categories in
                let options = categories.map { FilterOption.category($0) }
                self?.filterOptions = [.all] + options + [.priceLowToHigh, .priceHighToLow]
            }
            .store(in: &cancellables)
    }
}
