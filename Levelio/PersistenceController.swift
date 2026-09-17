//
//  PersistenceController.swift
//  Levelio
//
//  Created by Jose on 17/09/26.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Levelio")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data gagal dimuat: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
