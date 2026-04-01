//
// ProductListView.swift
// ShopApp
//
// Created by Mac Mini on 26/03/2026.
//
import SwiftUI

struct ProductListView: View {
@StateObject private var viewModel: ProductListViewModel
private let repository: ProductRepositoryProtocol

init(viewModel: ProductListViewModel, repository: ProductRepositoryProtocol) {
_viewModel = StateObject(wrappedValue: viewModel)
self.repository = repository
}

var body: some View {
VStack(spacing: 16) {
headerView


    SearchBarView(text: $viewModel.searchText)
        .padding(.horizontal)

    HStack {
        FilterMenuView(
            options: viewModel.filterOptions,
            selectedFilter: $viewModel.selectedFilter
        )
        Spacer()
    }
    .padding(.horizontal)

    contentView
}
.padding(.top, 8)
.navigationBarBackButtonHidden(true)
.onAppear {
    if viewModel.displayedProducts.isEmpty {
        viewModel.fetchProducts()
    }
}
}
private var headerView: some View {
HStack {
Text("ShopEase")
.font(.largeTitle)
.fontWeight(.bold)
Spacer()
NavigationLink {
FavoritesView(repository: repository)
} label: {
Image(systemName: "heart.fill")
.font(.title2)
.foregroundColor(.red)
}
}
.padding(.horizontal)
}

@ViewBuilder
private var contentView: some View {
if viewModel.isLoading && viewModel.displayedProducts.isEmpty {
Spacer()
ProgressView("Loading products...")
Spacer()
} else if let errorMessage = viewModel.errorMessage, viewModel.displayedProducts.isEmpty {
Spacer()
VStack(spacing: 10) {
Text(errorMessage)
.foregroundColor(.gray)
.multilineTextAlignment(.center)


        Button("Retry") {
            viewModel.fetchProducts()
        }
        .buttonStyle(.borderedProminent)
    }
    Spacer()
} else {
    ScrollView {
        LazyVStack(spacing: 14) {
            ForEach(viewModel.displayedProducts) { product in
                NavigationLink {
                    ProductDetailView(
                        productID: product.id,
                        repository: repository
                    )
                } label: {
                    ProductRowView(
                        product: product,
                        isFavorite: viewModel.isFavorite(productId: product.id),
                        favoriteTapped: {
                            viewModel.toggleFavorite(product: product)
                        }
                    )
                    .onAppear {
                        viewModel.loadMoreIfNeeded(currentItem: product)
                    }
                }
                .buttonStyle(.plain)
            }

            if viewModel.isLoadingMore {
                ProgressView()
                    .padding()
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
    .refreshable {
        viewModel.refresh()
    }
}
}
}
