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
    @NSManaged public var endDate: Date
    @NSManaged public var icon: String?
    @NSManaged public var name: String
    @NSManaged public var startDate: Date
    @NSManaged public var packs: NSOrderedSet

}

// MARK: Generated accessors for packs
extension Trip {

    @objc(insertObject:inPacksAtIndex:)
    @NSManaged public func insertIntoPacks(_ value: Pack, at idx: Int)

    @objc(removeObjectFromPacksAtIndex:)
    @NSManaged public func removeFromPacks(at idx: Int)

    @objc(insertPacks:atIndexes:)
    @NSManaged public func insertIntoPacks(_ values: [Pack], at indexes: NSIndexSet)

    @objc(removePacksAtIndexes:)
    @NSManaged public func removeFromPacks(at indexes: NSIndexSet)

    @objc(replaceObjectInPacksAtIndex:withObject:)
    @NSManaged public func replacePacks(at idx: Int, with value: Pack)

    @objc(replacePacksAtIndexes:withPacks:)
    @NSManaged public func replacePacks(at indexes: NSIndexSet, with values: [Pack])

    @objc(addPacksObject:)
    @NSManaged public func addToPacks(_ value: Pack)

    @objc(removePacksObject:)
    @NSManaged public func removeFromPacks(_ value: Pack)

    @objc(addPacks:)
    @NSManaged public func addToPacks(_ values: NSOrderedSet)

    @objc(removePacks:)
    @NSManaged public func removeFromPacks(_ values: NSOrderedSet)
    
    static func allTripsFetchRequest() -> NSFetchRequest<Trip> {
        let request: NSFetchRequest<Trip> = Trip.fetchRequest() as! NSFetchRequest<Trip>
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return request
    }

}

