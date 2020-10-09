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
    
    @State var item: Item?
    @State var trip: Trip?
    @Binding var selection: SelectionConfig
    
    @Binding var accent: Color
    
    @State var updatedName: String = ""
    @State var selectedCategory: Int = -1
    
    init(selection: Binding<SelectionConfig>, accent: Binding<Color>) {
        _selection = selection
        _accent = accent
    }
   
    var body: some View {
        NavigationView {
            Form {
                if (item != nil) {
                    Section {
                        TextField("Item Name", text: $updatedName)
                            .onAppear {
                                if !(item?.isDeleted ?? true){
                                    if item!.name.count > 0 {
                                        updatedName = item!.name
                                    }
                                }
                            }
                            .onDisappear {
                                if !(item?.isDeleted ?? true){
                                    if item!.name != updatedName {
                                        item!.name = updatedName
                                    }
                                }
                                if item?.hasChanges ?? false {
                                    saveContext(context)
                                }
                            }
                        if let trip = trip {
                            // Using force unwrap because of optional detection higher up
                            EditItemCategorySelector(item: item!, trip: trip, selectedCategory: $selectedCategory)
                        }
                    }
                    
                    Section {
                        Button(action: {
                            if let item = item {
                                item.name = updatedName
                                if item.hasChanges {
                                    saveContext(context)
                                }
                                
                            }
                            selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection, secondaryViewSelectionType: nil, secondaryViewSelection: nil)
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Save")
                        })
                    }
                } else {
                    Text("Item not Found")
                }
            }
            .navigationBarTitle("Edit Item")
            .navigationBarItems(trailing:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection, secondaryViewSelectionType: nil, secondaryViewSelection: nil)
                }, label: {
                    Text("Close")
                })
                  .padding()
            )
            .onChange(of: selection.secondaryViewSelection) { newSecondaryViewSelection in
                item = fetchEntityByExisting(id: newSecondaryViewSelection, entityType: Item.self, context: context)
                if let item = item {
                    updatedName = item.name
                }
            }
            .onAppear {
                item = fetchEntityByExisting(id: selection.secondaryViewSelection, entityType: Item.self, context: context)
                if (selection.viewSelectionType == .trip) {
                    trip = fetchEntityByExisting(id: selection.viewSelection, entityType: Trip.self, context: context)
                } else {
                    trip = nil
                }
            }
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
