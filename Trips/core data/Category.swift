//
//  Category.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-10-04.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject, Identifiable {

    @NSManaged public var name: String
    @NSManaged public var items: NSSet
    @NSManaged public var completed: Bool
    @NSManaged public var isTemplate: Bool
    @NSManaged public var trip: Trip?
    // Templates get an index of -1 by default
    @NSManaged public var index: Int

}

// MARK: Generated accessors for items
extension Category {

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
    
    static func allTemplatesFetchRequest() -> NSFetchRequest<Category> {
        // This one fetches templates, ha, kinda like reverse
        // Ha, I deleted the inverse function that did the opposite of this one
        // So now the joke on the first comment makes no sense; ha
        let request: NSFetchRequest<Category> = Category.fetchRequest() as! NSFetchRequest<Category>
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        request.predicate = NSPredicate(format: "%K == true", #keyPath(Category.isTemplate))
        
        return request
    }
    
    static func allCategoriesFetchRequest() -> NSFetchRequest<Category> {
        let request: NSFetchRequest<Category> = Category.fetchRequest() as! NSFetchRequest<Category>
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return request
    }
    
    static func generateCategoryIndex(trip: Trip, context: NSManagedObjectContext) throws -> Int {
        // finds the highest index, and adds one to that
        
        let request: NSFetchRequest<Category> = Category.fetchRequest() as! NSFetchRequest<Category>
        
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.trip), trip)
        
        request.fetchLimit = 1
        
        let result = try context.fetch(request)
        
        if result.count == 0 {
            return 0
        }
        
        return result[0].index + 1
    }
    
    static func adjustCategoryIndex(source: Int, index: Int, trip: Trip, context: NSManagedObjectContext) {
        // increases the category index of all categories with index equal to or larger than the param
        let request: NSFetchRequest<Category> = Category.fetchRequest() as! NSFetchRequest<Category>
        
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        
        var upper, lower: Int
        if (source > index) {
            upper = source
            lower = index
        } else if (source < index) {
            upper = index
            lower = source
        } else {
            return
        }
        
        request.predicate = NSCompoundPredicate(
            type: .and,
            subpredicates: [
                NSPredicate(format: "%K == %@", #keyPath(Category.trip), trip),
                NSPredicate(format: "%K BETWEEN { %@, %@ }", #keyPath(Category.index), NSNumber(value: lower), NSNumber(value: upper))
        ])
        
        do {
            let results = try context.fetch(request)
            results.forEach { result in
                result.index += (source > index ? 1 : -1)
            }
            saveContext(context)
        } catch {
            print("Adjusting indexes error: \(error)")
        }
    }
}
