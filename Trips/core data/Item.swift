//
//  Item.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-10-04.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//
//

import Foundation
import CoreData


@objc(Item)
public class Item: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String
    @NSManaged public var notes: String?
    @NSManaged public var pack: Pack?

}
