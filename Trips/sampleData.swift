//
//  sampleData.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-09-18.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI
import CoreData

struct SampleDataFactory {
    let context: NSManagedObjectContext

    func generateItem(name: String, index: Int) -> Item {
        let exampleItem = Item(context: context)
        exampleItem.name = name
        exampleItem.index = index
        return exampleItem
    }

    func generateCategory(name: String, index: Int, isTemplate: Bool = false) -> Category {
        let exampleCategory = Category(context: context)
        exampleCategory.name = name
        exampleCategory.index = index
        exampleCategory.isTemplate = isTemplate
        return exampleCategory
    }

    func generateTrip(name: String, startDate: Date, endDate: Date, color: String, icon: String) -> Trip {
        let exampleTrip = Trip(context: context)
        exampleTrip.name = name
        exampleTrip.startDate = startDate
        exampleTrip.endDate = endDate
        exampleTrip.color = color
        exampleTrip.icon = icon
        return exampleTrip
    }
    
    func generateCategoryRollingIndex(trip: Trip) throws -> Int {
        return try Category.generateCategoryIndex(trip: trip, context: context)
    }
    
    func generateItemRollingIndex(category: Category) throws -> Int {
        return try Item.generateItemIndex(category: category, context: context)
    }
    
    func addSampleTemplates() {
        var exampleCategory = generateCategory(name: "Beach 🏖", index: -1, isTemplate: true)
        
        var index = -1
        for name in ["Umbrella", "Beach Chair", "Towel"] {
            let item = generateItem(name: name, index: increturn(&index))
            exampleCategory.addToItems(item)
        }
        
        exampleCategory = generateCategory(name: "Tech", index: -1, isTemplate: true)
        
        index = -1
        for name in ["Laptop", "Laptop Charger"] {
            let item = generateItem(name: name, index: increturn(&index))
            exampleCategory.addToItems(item)
        }
    }

    func addSampleTrips() {
        do {
            var exampleTrip = generateTrip(name: "Campout 🏕", startDate: Date(timeIntervalSinceReferenceDate: 613868400.0), endDate: Date(timeIntervalSinceReferenceDate: 614041200), color: "pink", icon: "map.fill")
            var rollingCategoryIndex: Int = try generateCategoryRollingIndex(trip: exampleTrip)
            
            var exampleItem = generateItem(name: "Tent", index: 0)
            
            var exampleCategory = generateCategory(name: "Supplies", index: rollingCategoryIndex)
            
            exampleCategory.addToItems(exampleItem)
            exampleTrip.addToCategories(exampleCategory)
            
            exampleCategory = generateCategory(name: "Clothes", index: increturn(&rollingCategoryIndex))
            
            exampleItem = generateItem(name: "Camping Hat", index: 0)
            
            exampleCategory.addToItems(exampleItem)
            exampleTrip.addToCategories(exampleCategory)
            
            exampleTrip = generateTrip(name: "Business Trip", startDate: Date(timeIntervalSinceReferenceDate: 616114800), endDate: Date(timeIntervalSinceReferenceDate: 616719600), color: "purple", icon: "briefcase.fill")
            
            rollingCategoryIndex = try generateCategoryRollingIndex(trip: exampleTrip)
            
            exampleCategory = generateCategory(name: "Work Items", index: rollingCategoryIndex)
            
            exampleItem = generateItem(name: "Important Papers 🗃", index: 0)
            exampleCategory.addToItems(exampleItem)
            exampleTrip.addToCategories(exampleCategory)
            
            exampleCategory = generateCategory(name: "Clothes", index: increturn(&rollingCategoryIndex))
            
            var rollingItemIndex = try generateItemRollingIndex(category: exampleCategory) - 1
            for name in ["Polo 👕", "Slacks"] {
                exampleItem = generateItem(name: name, index: increturn(&rollingItemIndex))
                exampleCategory.addToItems(exampleItem)
            }
            
            exampleTrip.addToCategories(exampleCategory)
            
            try context.save()
        } catch {
            print(error)
        }
        
    }

}
