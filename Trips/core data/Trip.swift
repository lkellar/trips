//
//  Trip.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-10-01.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Trip)
public class Trip: NSManagedObject, Identifiable {

    @NSManaged public var color: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var icon: String?
    @NSManaged public var name: String
    @NSManaged public var startDate: Date?
    @NSManaged public var completed: Bool
    @NSManaged public var showCompleted: Bool
    @NSManaged public var categories: NSSet

}

// MARK: Generated accessors for Categories
extension Trip {

    @objc(insertObject:inCategoriesAtIndex:)
    @NSManaged public func insertIntoCategories(_ value: Category, at idx: Int)

    @objc(removeObjectFromCategoriesAtIndex:)
    @NSManaged public func removeFromCategories(at idx: Int)

    @objc(insertCategories:atIndexes:)
    @NSManaged public func insertIntoCategories(_ values: [Category], at indexes: NSIndexSet)

    @objc(removeCategoriesAtIndexes:)
    @NSManaged public func removeFromCategories(at indexes: NSIndexSet)

    @objc(replaceObjectInCategoriesAtIndex:withObject:)
    @NSManaged public func replaceCategories(at idx: Int, with value: Category)

    @objc(replaceCategoriesAtIndexes:withCategories:)
    @NSManaged public func replaceCategories(at indexes: NSIndexSet, with values: [Category])

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSOrderedSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSOrderedSet)
    
    static func allTripsFetchRequest() -> NSFetchRequest<Trip> {
        let request: NSFetchRequest<Trip> = Trip.fetchRequest() as! NSFetchRequest<Trip>
        
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        
        return request
    }
    
    func beginNextLeg(context: NSManagedObjectContext) throws -> Void {
        let items = try context.fetch(Item.itemsInTripFetchRequest(trip: self))
        
        for item in items {
            item.completed = false
        }
        
        saveContext(context)
    }

}

