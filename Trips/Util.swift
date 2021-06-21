//
//  Util.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-10-04.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI
import os

let coreDataLogger = Logger(subsystem: "org.kellar.trips", category: "coredata")

extension Date {
    var formatted_date: String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: Locale.current.languageCode!)
        return dateFormatter.string(from: self)
    }
}

extension Color {
    // So basically, as far as I can tell, there's no way to create a Color from a string, and it's hard to store a Color in core data, and I plan to use only named colors, so this will allow me to store strings and convert to color.
    static func fromString(color: String) -> Color {
        switch color {
        case "black":
            return Color.black
        case "blue":
            return Color.blue
        case "clear":
            return Color.clear
        case "gray":
            return Color.gray
        case "green":
            return Color.green
        case "orange":
            return Color.orange
        case "pink":
            return Color.pink
        case "primary":
            return Color.primary
        case "purple":
            return Color.purple
        case "red":
            return Color.red
        case "secondary":
            return Color.secondary
        case "white":
            return Color.white
        case "yellow":
            return Color.yellow
        default:
            // Don't want to raise an error, so returning primary color seems like best option
            return Color.primary
        }
    }
}

func saveContext(_ context: NSManagedObjectContext) -> Void {
    do {
        if context.hasChanges {
            try context.save()
        }
    } catch {
        coreDataLogger.log("Failed Saving Context: \(error.localizedDescription)")
    }
}

func checkDateValidity(startDate: Date, endDate: Date, showStartDate: Bool, showEndDate: Bool) -> Bool {
    if showEndDate == true && showStartDate == true {
        if startDate > endDate {
            if startDate.formatted_date != endDate.formatted_date {
                return false
            }
        }
    }
    return true
}

func copyTemplateToTrip(template: Category, trip: Trip, context: NSManagedObjectContext) throws {
    guard template.isTemplate else {
        throw TripError.TemplateIsCategoryError("Provided \"template\" is NOT a template!")
    }
    let transitionCategory = Category(context: context)
    // completed and istemplate are by default set to false
    transitionCategory.name = template.name
    
    transitionCategory.index =  try Category.generateCategoryIndex(trip: trip, context: context)
    
    for item in template.items {
        let itom = Item(context: context)
        itom.name = (item as! Item).name
        itom.index = (item as! Item).index
        
        transitionCategory.addToItems(itom)
    }
    
    trip.addToCategories(transitionCategory)
}

func increturn(_ num: inout Int) -> Int {
    // increment by one and return
    num += 1
    return num
}
    
func fetchItems(_ category: Category, _ context: NSManagedObjectContext) -> [Item] {
    let request: NSFetchRequest<Item> = Item.fetchRequest() as! NSFetchRequest<Item>
    
    request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
    
    request.predicate = NSPredicate(format: "%K == %@", #keyPath(Item.category), category)
    
    do {
        return try context.fetch(request)
    } catch {
        coreDataLogger.error("Failed to fetch items from Category \(category.objectID, privacy: .private(mask: .hash)): \(error.localizedDescription)")
        return []
    }
    
}


func copyToOther(category: Category, trip: Trip, context: NSManagedObjectContext) {
    coreDataLogger.debug("Copying category \(category.objectID, privacy: .private(mask: .hash)) to Trip \(trip.objectID, privacy: .private(mask: .hash))")
    do {
        let newCategory = Category(context: context)
        newCategory.items = NSSet()
        newCategory.name = category.name
        
        newCategory.index =  try Category.generateCategoryIndex(trip: trip, context: context)
        for item in category.items {
            let newItem = Item(context: context)
            newItem.completed = false
            newItem.completedCount = 0
            newItem.name = (item as! Item).name
            newItem.index = try Item.generateItemIndex(category: newCategory, context: context)
            
            newCategory.addToItems(newItem)
        }
        
        trip.addToCategories(newCategory)
        saveContext(context)
        
    } catch {
        coreDataLogger.error("Error Copying Category  \(category.objectID, privacy: .private(mask: .hash)) to Trip \(trip.objectID, privacy: .private(mask: .hash)): \(error.localizedDescription)")
    }
    
}

func sortTrips(_ trips: FetchedResults<Trip>) -> [Trip] {
    var newTrips = trips.filter {$0.startDate != nil}
    newTrips = newTrips.sorted(by: {$0.startDate! < $1.startDate!})
    newTrips.append(contentsOf: trips.filter {$0.startDate == nil})
    return newTrips
}

enum PrimarySelectionType {
    case trip
    case template
    case addTrip
    case addTemplate
}

enum SecondarySelectionType {
    case editTrip
    case editTemplate
    case editItem
    case addItem
    case addTemplate
    case addCategory
}

struct SelectionConfig: Equatable {
    var viewSelectionType: PrimarySelectionType
    var viewSelection: NSManagedObjectID?
    var secondaryViewSelectionType: SecondarySelectionType?
    var secondaryViewSelection: NSManagedObjectID?
}

extension PrimarySelectionType {
    func text() -> String {
        switch(self) {
        case .trip:
            return "trip"
        case .template:
            return "template"
        case .addTrip:
            return "addTrip"
        case .addTemplate:
            return "addTemplate"
        }
    }
}


func fetchEntityByExisting<T: NSManagedObject>(id: NSManagedObjectID?, entityType: T.Type, context: NSManagedObjectContext) -> T? {
    if let id = id {
        do {
            // We can force unwrap the selection, as there is a check in the parent to only use this view if selection is valid
            logger.info("Looking up existing entity by ID. ID is \(id, privacy: .private(mask: .hash))")
            let entity = try context.existingObject(with: id) as? T
            if let unwrappedEntity = entity {
                logger.info("Successfully found entity with ID:  \(id, privacy: .private(mask: .hash))")
                return unwrappedEntity
            }
            logger.info("Couldn't found entity with ID for Given Type:  \(id, privacy: .private(mask: .hash))")

            return nil
        } catch {
            logger.error("Looking up entity with ID: \(id, privacy: .private(mask: .hash)) failed. Error: \(error.localizedDescription, privacy: .public)")
            return nil
        }
    } else {
        return nil
    }
}
