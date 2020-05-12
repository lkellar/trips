//
//  CopyToOtherTrip.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-04-24.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct CopyToOtherTrip: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: Trip.allTripsFetchRequest()) var trips: FetchedResults<Trip>
    
    var trip: Trip?
    var category: Category
    
    @Binding var showSelf: Bool
    
    var body: some View {
        // For some reason, maybe the filter? it presents backwards
        List {
            if self.showSelf {
                ForEach(self.trips.filter {$0 != self.trip}.reversed(), id: \.self) { trip in
                    Button(action:{
                        self.copyToOther(category: self.category, trip: trip)
                    }) {
                        TripHomeRow(trip: trip)
                    }
                }
            }
        }
        
    }
    
    func copyToOther(category: Category, trip: Trip) {
        do {
            let newCategory = Category(context: self.context)
            newCategory.items = NSOrderedSet()
            newCategory.name = category.name
            
            newCategory.index =  try Category.generateCategoryIndex(trip: trip, context: self.context)
            for item in category.items {
                let newItem = Item(context: self.context)
                newItem.completed = false
                newItem.name = (item as! Item).name
                newItem.index = try Item.generateItemIndex(category: newCategory, context: self.context)
                
                newCategory.addToItems(newItem)
            }
            
            trip.addToCategories(newCategory)
            saveContext(self.context)
            
            self.showSelf = false
        } catch {
            print("Error while copying category")
        }
        
    }
}

struct CopyToOtherTrip_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAAAAAAAH")
    }
}
