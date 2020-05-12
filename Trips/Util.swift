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
        try context.save()
    } catch {
        print("ERROR: \(error); END OF ERROR")
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
        print(error)
        return []
    }
    
}
