//
//  Project+CoreDataProperties.swift
//  setOutSimpleLife
//
//  Created by taha on 03/12/2020.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var dateCreation: Date?
    @NSManaged public var descript: String?
    @NSManaged public var id: String?
    @NSManaged public var projectName: String?
    @NSManaged public var tag: Tag?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension Project {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
