//
//  CoreDataToDoTask+CoreDataProperties.swift
//  
//
//  Created by Abylaikhan Abilkayr on 28.08.2024.
//
//

import Foundation
import CoreData


extension CoreDataToDoTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataToDoTask> {
        return NSFetchRequest<CoreDataToDoTask>(entityName: "CoreDataToDoTask")
    }

    @NSManaged public var id: Int64
    @NSManaged public var todo: String?
    @NSManaged public var completed: Bool
    @NSManaged public var date: String?
    @NSManaged public var descrip: String?

}
