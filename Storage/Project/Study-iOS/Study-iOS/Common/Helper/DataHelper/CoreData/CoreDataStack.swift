//
//  CoreDataStack.swift
//  Study-iOS
//
//  Created by Daeyun Ethan Kim on 06/01/2018.
//  Copyright © 2018 K.D. All rights reserved.
//

import CoreData

// MARK: - CoreDatastack
class CoreDataStack {
    static let shared = CoreDataStack()
    
    // MARK: Properties
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Study_iOS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }() 
    
    private var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    // MARK: Funcations
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteContext(object: NSManagedObject) {
        context.delete(object)
    }
    
    func getObject(request: NSFetchRequest<NSManagedObject>) -> [Any] {
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
}
