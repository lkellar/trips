//
//  Pack.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-10-04.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Pack)
public class Pack: NSManagedObject, Identifiable {

    @NSManaged public var name: String
    @NSManaged public var items: NSOrderedSet
    @NSManaged public var completed: Bool
    @NSManaged public var isTemplate: Bool
    @NSManaged public var trip: Trip?

}

// MARK: Generated accessors for items
extension Pack {

    @objc(insertObject:inItemsAtIndex:)
    @NSManaged public func insertIntoItems(_ value: Item, at idx: Int)

    @objc(removeObjectFromItemsAtIndex:)
    @NSManaged public func removeFromItems(at idx: Int)

    @objc(insertItems:atIndexes:)
    @NSManaged public func insertIntoItems(_ values: [Item], at indexes: NSIndexSet)

    @objc(removeItemsAtIndexes:)
    @NSManaged public func removeFromItems(at indexes: NSIndexSet)

    @objc(replaceObjectInItemsAtIndex:withObject:)
    @NSManaged public func replaceItems(at idx: Int, with value: Item)

    @objc(replaceItemsAtIndexes:withItems:)
    @NSManaged public func replaceItems(at indexes: NSIndexSet, with values: [Item])

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSOrderedSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSOrderedSet)

    static func allPacksFetchRequest() ->NSFetchRequest<Pack> {
        let request: NSFetchRequest<Pack> = Pack.fetchRequest() as! NSFetchRequest<Pack>
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
       
        return request
    }
}
