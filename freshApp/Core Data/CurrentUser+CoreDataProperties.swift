//
//  CurrentUser+CoreDataProperties.swift
//  
//
//  Created by Forrest Buhler on 9/29/21.
//
//

import Foundation
import CoreData


extension CurrentUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentUser> {
        return NSFetchRequest<CurrentUser>(entityName: "CurrentUser")
    }

    @NSManaged public var username: String?

}
