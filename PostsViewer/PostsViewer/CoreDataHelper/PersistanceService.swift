//
//  PersistanceService.swift
//  PostsViewer
//
//  Created by keyur.tailor on 24/02/21.
//  Copyright © 2021 keyur.tailor. All rights reserved.
//

import Foundation
import CoreData

final class PersistenceService {
    // MARK: - Core Data stack
    
    private init() { }
    
    static let shared = PersistenceService()
    
    lazy var context = persistentContainer.viewContext
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PostsViewer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
                print("SAVED")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
        } catch {
            print(error)
            return [T]()
        }
    }
    
    func delete(_ object:NSManagedObject) {
        context.delete(object)
        saveContext()
    }
}
