import SwiftUI
import CoreData

@main
struct Productlisting2: App {
let persistenceController = PersistenceController.shared

var body: some Scene {
    WindowGroup {
        NavigationStack {
            SplashView(
                repository: ProductRepository(
                    networkService: NetworkManager(),
                    context: persistenceController.container.viewContext
                )
            )
        }
    }
}
}
