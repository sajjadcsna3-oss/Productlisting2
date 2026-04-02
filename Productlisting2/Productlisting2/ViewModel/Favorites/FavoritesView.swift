import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel: FavoritesViewModel
    @EnvironmentObject private var router: Router

    private let repository: ProductRepositoryProtocol

    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
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
                            Button {
                                router.push(.productDetail(id: product.id))
                            } label: {
                                ProductRowView(
                                    product: product,
                                    isFavorite: true,
                                    favoriteTapped: {
                                        viewModel.toggleFavorite(product: product)
                                    }
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.loadFavorites()
        }
    }
}
