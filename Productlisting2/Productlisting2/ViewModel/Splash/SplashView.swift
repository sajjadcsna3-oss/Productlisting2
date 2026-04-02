import SwiftUI
import Combine
struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    @EnvironmentObject private var router: Router

    private let repository: ProductRepositoryProtocol

    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.85), Color.purple.opacity(0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "bag.fill")
                    .font(.system(size: 72))
                    .foregroundColor(.white)

                Text("ShopEase")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)

                ProgressView()
                    .tint(.white)
                    .padding(.top, 10)
            }
        }
        .onAppear {
            viewModel.start {
                router.push(.productList)
            }
        }
    }
}
