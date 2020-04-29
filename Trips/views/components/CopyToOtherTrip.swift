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
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var trip: Trip?
    var category: Category
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(self.trips.filter {$0 != self.trip}, id: \.self) { trip in
                    Button(action:{
                        self.copyToOther(category: self.category, trip: trip)
                    }) {
                        TripHomeRow(trip: trip)
                    }
                }
            }.navigationBarTitle(Text("Copy To Other Trip"))
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
        } catch {
            print("Error while copying category")
        }
        
        self.presentationMode.wrappedValue.dismiss()
        
    }
}

struct CopyToOtherTrip_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAAAAAAAH")
    }
}
