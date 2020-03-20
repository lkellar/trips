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

    static func allItemsFetchRequest() ->NSFetchRequest<Item> {
        let request: NSFetchRequest<Item> = Item.fetchRequest() as! NSFetchRequest<Item>
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return request
    }
    
    static func generateItemIndex(category: Category, context: NSManagedObjectContext) throws -> Int {
        // Finds the lowest available Item index
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
    
    static func adjustItemIndex(source: Int, index: Int, category: Category, context: NSManagedObjectContext) {
        // increases the item index of all item with index equal to or larger than the param, and vice versa
        // ALSO stolen from categories
        let request: NSFetchRequest<Item> = Item.fetchRequest() as! NSFetchRequest<Item>
        
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
                NSPredicate(format: "%K == %@", #keyPath(Item.category), category),
                NSPredicate(format: "%K BETWEEN { %@, %@ }", #keyPath(Item.index), NSNumber(value: lower), NSNumber(value: upper))
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
