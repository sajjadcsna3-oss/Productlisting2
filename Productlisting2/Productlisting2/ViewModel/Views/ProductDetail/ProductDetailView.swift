    import SwiftUI

    struct ProductDetailView: View {
        @Environment(\.dismiss) private var dismiss
        @StateObject private var viewModel: ProductDetailViewModel

        let productID: Int

        init(productID: Int, repository: ProductRepositoryProtocol) {
            self.productID = productID
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

                        AsyncImage(url: URL(string: product.thumbnail)) { phase in
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

                        Text(product.category.capitalized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("$\(product.price, specifier: "%.2f")")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)

                        Text(product.description)
                            .font(.body)
                            .foregroundColor(.secondary)

                        Button {
                            viewModel.toggleFavorite()
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
