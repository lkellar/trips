//
//  exampleTrips.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-09-18.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
/*
let packs = [Pack(name: "Tech", items: [Item(name: "Laptop")])]

let exampleTrips = [
    Trip(name: "Trip to Georgia", startDate: Date(timeIntervalSinceReferenceDate: 588200000.0), endDate: Date(timeIntervalSinceReferenceDate: 588804800.0), color: Color.red, icon: "house.fill"),
    Trip(name: "Trip to Oregon", startDate: Date(timeIntervalSinceReferenceDate: 590515986.0), endDate: Date(timeIntervalSinceReferenceDate: 590516014.0), color: Color.blue, icon: "sunrise")
]
*/

func addSampleData(context: NSManagedObjectContext) {
    do {
        let dater = try context.fetch(Trip.allTripsFetchRequest())
        guard dater.count == 0 else {
            return
        }
    } catch {
        print(error)
        return
    }
    
    
    let exampleTrip = Trip(context: context)
    
    exampleTrip.name = "Trip to Georgia"
    exampleTrip.startDate = Date(timeIntervalSinceReferenceDate: 588200000.0)
    exampleTrip.endDate = Date(timeIntervalSinceReferenceDate: 588804800.0)
    exampleTrip.color = "green"
    
    let exampleItem = Item(context: context)
    exampleItem.name = "Laptop"
    
    let examplePack = Pack(context: context)
    examplePack.name = "Tech"
    
    examplePack.addToItems(exampleItem)
    exampleTrip.addToPacks(examplePack)
    
    do {
        try context.save()
    } catch {
        print(error)
    }
    
}
