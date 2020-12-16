//
//  Task+CoreDataProperties.swift
//  setOutSimpleLife
//
//  Created by taha on 03/12/2020.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var dateCreation: Date?
    @NSManaged public var deadline: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var enjoyment: Int16
    @NSManaged public var id: String?
    @NSManaged public var importance: Int16
    @NSManaged public var note: String?
    @NSManaged public var reminder: Date?
    @NSManaged public var schedule: Bool
    @NSManaged public var taskName: String?
    @NSManaged public var project: Project?
    @NSManaged public var tag: Tag?

}
