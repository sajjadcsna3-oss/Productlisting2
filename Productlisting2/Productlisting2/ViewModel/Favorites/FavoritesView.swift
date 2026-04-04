import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel: FavoritesViewModel
    @EnvironmentObject private var router: Router

    init(repository: ProductRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: FavoritesViewModel(repository: repository))
    }

    var body: some View {
        VStack {
            if viewModel.favoriteProducts.isEmpty {
                Spacer()
                Text("No favorite products yet ❤️")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(viewModel.favoriteProducts) { product in
                            ProductRowView(
                                product: product,
                                isFavorite: true,
                                favoriteTapped: {
                                    viewModel.toggleFavorite(product: product)
                                }
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                router.push(.productDetail(id: product.id))
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadFavorites()
        }
    }
}
