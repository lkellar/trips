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
    let defaults = UserDefaults.standard
    do {
        let dater = try context.fetch(Trip.allTripsFetchRequest())
        guard dater.count == 0 else {
            defaults.set(true, forKey: "hasRunBefore")
            return
        }
        // on first run only
        guard defaults.bool(forKey: "hasRunBefore") == false else {
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
    
    exampleTrip.name = "Campout 🏕"
    exampleTrip.startDate = Date(timeIntervalSinceReferenceDate: 613868400.0)
    exampleTrip.endDate = Date(timeIntervalSinceReferenceDate: 614041200)
    exampleTrip.color = "pink"
    exampleTrip.icon = "map.fill"
    
    let exampleItem = Item(context: context)
    exampleItem.name = "Tent"
    exampleItem.index = 0
    
    let exampleCategory = Category(context: context)
    exampleCategory.name = "Supplies"
    exampleCategory.index = rollingIndex
    
    
    // TODO ADD secondary categories
    let clothesCategory = Category(context: context)
    clothesCategory.name = "Clothes"
    clothesCategory.index = increturn(&rollingIndex)
    
    let exampleClothing = Item(context: context)
    exampleClothing.name = "Camping Hat"
    exampleClothing.index = 0
    
    exampleCategory.addToItems(exampleItem)
    clothesCategory.addToItems(exampleClothing)
    exampleTrip.addToCategories(exampleCategory)
    exampleTrip.addToCategories(clothesCategory)
    
    
    let secondTrip = Trip(context: context)
    secondTrip.name = "Business Trip"
    secondTrip.startDate = Date(timeIntervalSinceReferenceDate: 616114800)
    secondTrip.endDate = Date(timeIntervalSinceReferenceDate: 616719600)
    secondTrip.color = "purple"
    secondTrip.icon = "briefcase.fill"
    
    do {
        rollingIndex = try Category.generateCategoryIndex(trip: secondTrip, context: context)
    } catch {
        print("Rolling Index failed \(error)")
        return
    }
    
    let clothesCategoryTwo = Category(context: context)
    clothesCategoryTwo.name = "Work Items"
    clothesCategoryTwo.index = rollingIndex
    
    let papers = Item(context: context)
    papers.name = "Important Papers 🗃"
    papers.index = 0
    
    let exampleItemTwo = Item(context: context)
    exampleItemTwo.name = "Polo 👕"
    exampleItemTwo.index = 0
    
    let exampleItemThree = Item(context: context)
    exampleItemThree.name = "Slacks"
    exampleItemThree.index = 1
    
    let exampleCategoryTwo = Category(context: context)
    exampleCategoryTwo.name = "Clothes"
    exampleCategoryTwo.index = increturn(&rollingIndex)
    
    exampleCategoryTwo.addToItems(exampleItemTwo)
    exampleCategoryTwo.addToItems(exampleItemThree)
    clothesCategoryTwo.addToItems(papers)
    
    secondTrip.addToCategories(clothesCategoryTwo)
    secondTrip.addToCategories(exampleCategoryTwo)
    
    let beach = Category(context: context)
    beach.name = "Beach 🏖"
    beach.isTemplate = true
    
    var itomIndex = -1
    for itom in ["Umbrella", "Beach Chair", "Towel"] {
        let item = Item(context: context)
        item.name = itom
        item.index = increturn(&itomIndex)
        beach.addToItems(item)
    }
    
    let tech = Category(context: context)
    tech.name = "Tech"
    tech.isTemplate = true
    
    itomIndex = -1
    for itom in ["Laptop", "Laptop Charger"] {
        let item = Item(context: context)
        item.name = itom
        item.index = increturn(&itomIndex)
        tech.addToItems(item)
    }
    
    
    do {
        try context.save()
        defaults.set(true, forKey: "hasRunBefore")
    } catch {
        print(error)
    }
    
}
