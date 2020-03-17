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
        rollingIndex = try Category.generateCategoryIndex(trip: exampleTrip, context: context)
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
    
    let exampleCategory = Category(context: context)
    exampleCategory.name = "Tech"
    exampleCategory.index = rollingIndex
    
    
    // TODO ADD secondary categories
    let clothesCategory = Category(context: context)
    clothesCategory.name = "Clothes"
    clothesCategory.index = increturn(&rollingIndex)
    
    exampleCategory.addToItems(exampleItem)
    exampleTrip.addToCategories(exampleCategory)
    exampleTrip.addToCategories(clothesCategory)
    
    
    let secondTrip = Trip(context: context)
    secondTrip.name = "Vancouver Campout"
    secondTrip.startDate = Date(timeIntervalSinceReferenceDate: 591600000)
    secondTrip.endDate = Date(timeIntervalSinceReferenceDate: 592300000)
    secondTrip.color = "purple"
    
    do {
        rollingIndex = try Category.generateCategoryIndex(trip: secondTrip, context: context)
    } catch {
        print("Rolling Index failed \(error)")
        return
    }
    
    let clothesCategoryTwo = Category(context: context)
    clothesCategoryTwo.name = "Clothes"
    clothesCategoryTwo.index = rollingIndex
    
    let exampleItemTwo = Item(context: context)
    exampleItemTwo.name = "Laptop"
    
    let exampleCategoryTwo = Category(context: context)
    exampleCategoryTwo.name = "Tech"
    exampleCategoryTwo.index = increturn(&rollingIndex)
    
    exampleCategoryTwo.addToItems(exampleItemTwo)
    
    let toiletriesCategory = Category(context: context)
    toiletriesCategory.name = "Toiletries"
    toiletriesCategory.index = increturn(&rollingIndex)
    
    let grassCategory = Category(context: context)
    grassCategory.name = "Grass-Related Items"
    grassCategory.index = increturn(&rollingIndex)
    
    let catCategory = Category(context: context)
    catCategory.name = "Cats"
    catCategory.index = increturn(&rollingIndex)
    
    let catItem = Item(context: context)
    catItem.name = "Yellow Cat"
    
    secondTrip.addToCategories(clothesCategoryTwo)
    secondTrip.addToCategories(grassCategory)
    catCategory.addToItems(catItem)
    secondTrip.addToCategories(catCategory)
    secondTrip.addToCategories(toiletriesCategory)
    secondTrip.addToCategories(exampleCategoryTwo)
    
    let clothes = Category(context: context)
    clothes.name = "Clothes"
    clothes.isTemplate = true
    
    let yellow = Category(context: context)
    yellow.name = "Yellow Cats"
    yellow.isTemplate = true
    
    let tech = Category(context: context)
    tech.name = "Tech"
    tech.isTemplate = true
    
    let grass = Category(context: context)
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
