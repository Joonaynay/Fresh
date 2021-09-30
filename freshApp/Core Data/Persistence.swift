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
    
    func fetch() -> [CurrentUser]? {
        do {
            let currentUser = try context.fetch(CurrentUser.fetchRequest()) as! [CurrentUser]            
            return currentUser
        } catch {
            
        }
         
        return nil
    }
    
    
}
