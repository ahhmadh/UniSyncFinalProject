//
//  CoreDataManager.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FinalProjectModel")
        container.loadPersistentStores { _, error in
            if let error = error { print("CoreData error:", error) }
        }
        return container
    }()

    func save() {
        let ctx = container.viewContext
        if ctx.hasChanges { try? ctx.save() }
    }
}
