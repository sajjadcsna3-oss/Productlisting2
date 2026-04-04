import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel: ProductListViewModel
    @EnvironmentObject private var router: Router

    init(repository: ProductRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: ProductListViewModel(repository: repository))
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

            Button {
                router.push(.favorites)
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
        } else if let errorMessage = viewModel.errorMessage,
                  viewModel.displayedProducts.isEmpty {
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
                        ProductRowView(
                            product: product,
                            isFavorite: viewModel.isFavorite(productId: product.id),
                            favoriteTapped: {
                                viewModel.toggleFavorite(product: product)
                            }
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            router.push(.productDetail(id: product.id))
                        }
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: product)
                        }
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
