//
//  Productlisting2App.swift
//  Productlisting2
//
//  Created by Mac Mini on 01/04/2026.
//

import SwiftUI
import CoreData

@main
struct Productlisting2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
