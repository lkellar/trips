//
//  EditCategory.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-04-24.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import CoreData
import SwiftUI

struct EditCategory: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(fetchRequest: Trip.allTripsFetchRequest()) var trips: FetchedResults<Trip>
    
    var category: Category
    var accent: Color
    
    @State var updatedName: String = ""
    @State var showCopyToOther: Bool = false
    @State var showNoTripsAlert = false
    @State var showCreateTemplate: Bool = false
    @State var showDeleteAlert: Bool = false
    @State var showDuplicateAlert: Bool = false
    
    var body: some View {
        Form {
            Section {
                TextField("Category Name", text: $updatedName)
                    .onAppear {
                        updatedName = category.name
                    }
                    .onDisappear(perform: {
                        if updatedName.count > 0 && updatedName != category.name && !category.isDeleted{
                            category.name = updatedName
                        }
                        
                        if (category.hasChanges) {
                            saveContext(context)
                        }
                        
                    })
            }
                
            Section(footer: Text("This will create a copy of this category in another Trip")) {
                Button(action: {
                    if trips.count > 1  || showCopyToOther {
                        showCopyToOther.toggle()
                    } else {
                        showNoTripsAlert = true
                    }
                }) {
                    Text("Copy to Other Trip")
                }
                if showCopyToOther {
                    CopyToOtherTrip(trip: category.trip, category: category, showSelf: $showCopyToOther)
                }
            }
            
            Section(footer: Text("This will create a template containing all items from this category")) {
                Button(action: {
                    showCreateTemplate.toggle()
                }) {
                    Text("Create Template from Category")
                }.sheet(isPresented: $showCreateTemplate, content: {
                    CreateTemplateFromCategory(category: category, accent: accent).environment(\.managedObjectContext, context)
                })
            }
            
            Section {
                Button(action: {
                    copyToOther(category: category, trip: category.trip!, context: context)
                    showDuplicateAlert = true
                }) {
                    Text("Duplicate")
                }.alert(isPresented: $showDuplicateAlert, content: {
                    Alert(title: Text("Category \(updatedName) Duplicated"),
                          dismissButton: .default(Text("Dismiss")))
                })
                
                Button(action: {
                    showDeleteAlert = true
                }) {
                    Text("Delete")
                }.foregroundColor(.red)
                    .alert(isPresented: $showDeleteAlert, content: {
                    Alert(title: Text("Are you sure you want to delete \(updatedName)?"),
                          message: Text("This cannot be undone."),
                          primaryButton: Alert.Button.destructive(Text("Delete"), action: {
                            category.items.forEach {item in
                                context.delete(item as! NSManagedObject)
                            }
                            context.delete(category)
                          }), secondaryButton: Alert.Button.cancel(Text("Cancel")))
                })
                
            }
        }.navigationBarTitle(Text("Edit Category"))
            .navigationBarItems(trailing: HStack {
                Text("").alert(isPresented: $showNoTripsAlert, content:{
                    Alert(title: Text("There are no other Trips"),
                        message: Text("Please go create another Trip first"),
                        dismissButton: .default(Text("Dismiss")))
                    })
        }).navigationViewStyle(StackNavigationViewStyle())
    }
}

struct EditCategory_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAAAAAAAAh")
    }
}
