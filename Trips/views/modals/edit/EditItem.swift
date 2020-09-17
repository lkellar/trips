//
//  ItemDetail.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-12-13.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI
import CoreData

struct EditItem: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var item: Item
    var trip: Trip?
    
    var accent: Color
    
    @State var updatedName: String = ""
    @State var selectedCategory: Int = -1
    
    init(item: Item, accent: Color, trip: Trip) {
        self.item = item
        self.accent = accent
        self.trip = trip
        print("Initiazing EditItem with \(item.name)")
    }
    
    init(item: Item) {
        self.item = item
        self.accent = Color.accentColor
        self.trip = nil
        print("Initiazing EditItem with \(item.name)")
    }
   
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Item Name", text: $updatedName)
                        .onAppear {
                            if item.name.count > 0 {
                                updatedName = item.name
                            }
                        }
                        .onDisappear {
                            if !item.isDeleted {
                                if item.name != updatedName {
                                    item.name = updatedName
                                }
                            }
                            if item.hasChanges {
                                saveContext(context)
                            }
                        }
                    if let trip = trip {
                        EditItemCategorySelector(item: item, trip: trip, selectedCategory: $selectedCategory)
                    }
                }
                
                Section {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                    })
                }
            }
            .navigationBarTitle("Edit Item")
            .navigationBarItems(trailing:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Close")
            }))
        }
        .accentColor(accent)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct EditItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAHHH MY COMPUTER CANT DO PREVIEWS, or not very well")
    }
}
