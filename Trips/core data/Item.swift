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

    @NSManaged public var name: String
    @NSManaged public var notes: String?
    @NSManaged public var completed: Bool
    @NSManaged public var category: Category?
    @NSManaged public var index: Int
    @NSManaged public var completedCount: Int
    @NSManaged public var totalCount: Int

    static func allItemsFetchRequest() ->NSFetchRequest<Item> {
        let request: NSFetchRequest<Item> = Item.fetchRequest() as! NSFetchRequest<Item>
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return request
    }
    
    static func itemsInTripFetchRequest(trip: Trip) ->  NSFetchRequest<Item> {
        let request: NSFetchRequest<Item> = Item.fetchRequest() as! NSFetchRequest<Item>
        
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        
        request.predicate = NSPredicate(format: "%K IN %@", #keyPath(Item.category), trip.categories)
        
        return request
    }
    
    static func generateItemIndex(category: Category, context: NSManagedObjectContext) throws -> Int {
        // finds the highest index, and adds one to that
        // Stolen from generateCategoryIndex
        
        let request: NSFetchRequest<Item> = Item.fetchRequest() as! NSFetchRequest<Item>
        
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Item.category), category)
        
        request.fetchLimit = 1
        
        let result = try context.fetch(request)
        
        if result.count == 0 {
            return 0
        }
        
        return result[0].index + 1
    }
}
