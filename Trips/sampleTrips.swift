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
    var rollingIndex: Int
    do {
        rollingIndex = try Pack.generatePackIndex(trip: exampleTrip, context: context)
    } catch {
        print("Rolling Index failed \(error)")
        return
    }
    
    exampleTrip.name = "Trip to Georgia"
    exampleTrip.startDate = Date(timeIntervalSinceReferenceDate: 588200000.0)
    exampleTrip.endDate = Date(timeIntervalSinceReferenceDate: 588804800.0)
    exampleTrip.color = "green"
    
    let exampleItem = Item(context: context)
    exampleItem.name = "Laptop"
    
    let examplePack = Pack(context: context)
    examplePack.name = "Tech"
    examplePack.index = rollingIndex
    
    
    // TODO ADD secondary packs
    let clothesPack = Pack(context: context)
    clothesPack.name = "Clothes"
    clothesPack.index = increturn(&rollingIndex)
    
    examplePack.addToItems(exampleItem)
    exampleTrip.addToPacks(examplePack)
    exampleTrip.addToPacks(clothesPack)
    
    
    let secondTrip = Trip(context: context)
    secondTrip.name = "Vancouver Campout"
    secondTrip.startDate = Date(timeIntervalSinceReferenceDate: 591600000)
    secondTrip.endDate = Date(timeIntervalSinceReferenceDate: 592300000)
    secondTrip.color = "purple"
    
    do {
        rollingIndex = try Pack.generatePackIndex(trip: secondTrip, context: context)
    } catch {
        print("Rolling Index failed \(error)")
        return
    }
    
    let clothesPackTwo = Pack(context: context)
    clothesPackTwo.name = "Clothes"
    clothesPackTwo.index = rollingIndex
    
    let exampleItemTwo = Item(context: context)
    exampleItemTwo.name = "Laptop"
    
    let examplePackTwo = Pack(context: context)
    examplePackTwo.name = "Tech"
    examplePackTwo.index = increturn(&rollingIndex)
    
    examplePackTwo.addToItems(exampleItemTwo)
    
    let toiletriesPack = Pack(context: context)
    toiletriesPack.name = "Toiletries"
    toiletriesPack.index = increturn(&rollingIndex)
    
    let grassPack = Pack(context: context)
    grassPack.name = "Grass-Related Items"
    grassPack.index = increturn(&rollingIndex)
    
    let catPack = Pack(context: context)
    catPack.name = "Cats"
    catPack.index = increturn(&rollingIndex)
    
    let catItem = Item(context: context)
    catItem.name = "Yellow Cat"
    
    secondTrip.addToPacks(clothesPackTwo)
    secondTrip.addToPacks(grassPack)
    catPack.addToItems(catItem)
    secondTrip.addToPacks(catPack)
    secondTrip.addToPacks(toiletriesPack)
    secondTrip.addToPacks(examplePackTwo)
    
    let clothes = Pack(context: context)
    clothes.name = "Clothes"
    clothes.isTemplate = true
    
    let yellow = Pack(context: context)
    yellow.name = "Yellow Cats"
    yellow.isTemplate = true
    
    let tech = Pack(context: context)
    tech.name = "Tech"
    tech.isTemplate = true
    
    let grass = Pack(context: context)
    grass.name = "Grass"
    grass.isTemplate = true
    
    for itom in ["Koi Grass", "Mowed", "Orange Grass"] {
        let item = Item(context: context)
        item.name = itom
        grass.addToItems(item)
    }
    
    
    do {
        try context.save()
    } catch {
        print(error)
    }
    
}
