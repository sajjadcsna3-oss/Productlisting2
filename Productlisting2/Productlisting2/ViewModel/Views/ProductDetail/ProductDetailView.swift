import SwiftUI

struct ProductDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ProductDetailViewModel

    let productID: Int
    private let repository: ProductRepositoryProtocol

    @State private var goToFavorites = false

    init(productID: Int, repository: ProductRepositoryProtocol) {
        self.productID = productID
        self.repository = repository
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(repository: repository))
    }

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView("Loading details...")
                    .padding(.top, 100)

            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Text(errorMessage)
                        .foregroundColor(.gray)

                    Button("Retry") {
                        viewModel.fetchProductDetail(id: productID)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.top, 100)

            } else if let product = viewModel.product {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(Circle())
                        }

                        Spacer()
                    }

                    AsyncImage(url: URL(string: product.image)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 280)

                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .frame(height: 280)

                        case .failure:
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, minHeight: 280)

                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    Text(product.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)

                    Text(product.description)
                        .font(.body)
                        .foregroundColor(.secondary)

                    Button {
                        let wasFavorite = viewModel.isFavorite
                        viewModel.toggleFavorite()

                        if !wasFavorite {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                goToFavorites = true
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            Text(viewModel.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isFavorite ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.top, 10)

                    NavigationLink(
                        destination: FavoritesView(repository: repository),
                        isActive: $goToFavorites
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.fetchProductDetail(id: productID)
        }
    }
}
