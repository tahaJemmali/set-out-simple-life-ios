//
//  Tag+CoreDataProperties.swift
//  setOutSimpleLife
//
//  Created by taha on 03/12/2020.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var color: String?
    @NSManaged public var id: String?
    @NSManaged public var tagName: String?

}
