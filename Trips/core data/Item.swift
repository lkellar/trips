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

    static func allItemsFetchRequest() ->NSFetchRequest<Item> {
        let request: NSFetchRequest<Item> = Item.fetchRequest() as! NSFetchRequest<Item>
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return request
    }
}
