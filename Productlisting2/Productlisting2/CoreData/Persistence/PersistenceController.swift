//
// PersistenceController.swift
// ShopApp
//
// Created by Mac Mini on 26/03/2026.
//
import CoreData

final class PersistenceController {
static let shared = PersistenceController()

let container: NSPersistentContainer

init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "ShopApp")

    if inMemory {
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }

    container.loadPersistentStores { _, error in
        if let error = error {
            print("CoreData load error: \(error.localizedDescription)")
        }
    }

    container.viewContext.automaticallyMergesChangesFromParent = true
}
}
