//
//  Persistence.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/29/21.
//

import CoreData

struct Persistence {
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "FreshModel")
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchUser(uid: String) -> CurrentUser? {
        do {
            let request = CurrentUser.fetchRequest() as NSFetchRequest<CurrentUser>
            let predicate = NSPredicate(format: "id CONTAINS '\(uid)'")
            request.predicate = predicate
            let currentUser = try context.fetch(request)
            return currentUser.first
        } catch {
            
        }
         
        return nil
    }
    
    
}
