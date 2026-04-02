import Foundation
import Combine
final class SplashViewModel: ObservableObject {
    func start(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion()
        }
    }
}
