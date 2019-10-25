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
    
    
    // TODO ADD secondary packs
    let clothesPack = Pack(context: context)
    clothesPack.name = "Clothes"
    
    examplePack.addToItems(exampleItem)
    exampleTrip.addToPacks(examplePack)
    exampleTrip.addToPacks(clothesPack)
    
    
    let secondTrip = Trip(context: context)
    secondTrip.name = "Vancouver Campout"
    secondTrip.startDate = Date(timeIntervalSinceReferenceDate: 591600000)
    secondTrip.endDate = Date(timeIntervalSinceReferenceDate: 592300000)
    secondTrip.color = "purple"
    
    let clothesPackTwo = Pack(context: context)
    clothesPackTwo.name = "Clothes"
    
    let exampleItemTwo = Item(context: context)
    exampleItemTwo.name = "Laptop"
    
    let examplePackTwo = Pack(context: context)
    examplePackTwo.name = "Tech"
    
    examplePackTwo.addToItems(exampleItemTwo)
    
    let toiletriesPack = Pack(context: context)
    toiletriesPack.name = "Toiletries"
    
    let grassPack = Pack(context: context)
    grassPack.name = "Grass-Related Items"
    
    let catPack = Pack(context: context)
    catPack.name = "Cats"
    
    let catItem = Item(context: context)
    catItem.name = "Yellow Cat"
    
    
    secondTrip.addToPacks(clothesPackTwo)
    secondTrip.addToPacks(grassPack)
    catPack.addToItems(catItem)
    secondTrip.addToPacks(catPack)
    secondTrip.addToPacks(toiletriesPack)
    secondTrip.addToPacks(examplePackTwo)
    
    do {
        try context.save()
    } catch {
        print(error)
    }
    
}
