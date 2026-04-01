//
// FavoritesViewModel.swift
// ShopApp
//
// Created by Mac Mini on 26/03/2026.
//

import Foundation
import Combine

final class FavoritesViewModel: ObservableObject {
@Published private(set) var favoriteProducts: [Product] = []
@Published private(set) var errorMessage: String?

private let repository: ProductRepositoryProtocol
private var cancellables = Set<AnyCancellable>()

init(repository: ProductRepositoryProtocol) {
    self.repository = repository
    loadFavorites()
}

func loadFavorites() {
    repository.fetchFavoriteProducts()
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] products in
            self?.favoriteProducts = products
        }
        .store(in: &cancellables)
}

func toggleFavorite(product: Product) {
    repository.toggleFavorite(product: product)
    loadFavorites()
}
}
