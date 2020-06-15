//
//  EditCategory.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-04-24.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

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
                        if self.category.name.count > 0 {
                            self.updatedName = self.category.name
                        }
                }
            }
                
            Section(footer: Text("This will create a copy of this category in another Trip")) {
                Button(action: {
                    if self.trips.count > 1  || self.showCopyToOther {
                        self.showCopyToOther.toggle()
                    } else {
                        self.showNoTripsAlert = true
                    }
                }) {
                    Text("Copy to Other Trip")
                }
                
                if self.showCopyToOther {
                    CopyToOtherTrip(trip: self.category.trip, category: self.category, showSelf: self.$showCopyToOther)
                }
            }
            
            Section(footer: Text("This will create a template containing all items from this category")) {
                Button(action: {
                    self.showCreateTemplate.toggle()
                }) {
                    Text("Create Template from Category")
                }.sheet(isPresented: $showCreateTemplate, content: {
                    CreateTemplateFromCategory(category: self.category, accent: self.accent).environment(\.managedObjectContext, self.context)
                })
            }
            
            Section {
                Button(action: {
                    copyToOther(category: self.category, trip: self.category.trip!, context: self.context)
                    self.showDuplicateAlert = true
                }) {
                    Text("Duplicate")
                }.alert(isPresented: self.$showDuplicateAlert, content: {
                    Alert(title: Text("Category \(self.updatedName) Duplicated"),
                          dismissButton: .default(Text("Dismiss")))
                })
                
                Button(action: {
                    self.showDeleteAlert = true
                }) {
                    Text("Delete")
                }.foregroundColor(.red)
                    .alert(isPresented: self.$showDeleteAlert, content: {
                    Alert(title: Text("Are you sure you want to delete \(self.updatedName)?"),
                          message: Text("This cannot be undone."),
                          primaryButton: Alert.Button.destructive(Text("Delete"), action: {
                        do {
                            self.context.delete(self.category)
                            try self.context.save()
                        } catch {
                            print(error)
                        }
                          }), secondaryButton: Alert.Button.cancel(Text("Cancel")))
                })
                
            }
        }.navigationBarTitle(Text("Edit Category"))
            .navigationBarItems(trailing: HStack {
                Text("").alert(isPresented: self.$showNoTripsAlert, content:{
                    Alert(title: Text("There are no other Trips"),
                        message: Text("Please go create another Trip first"),
                        dismissButton: .default(Text("Dismiss")))
                    })
                .onDisappear(perform: {
                    self.category.name = self.updatedName
                    
                    saveContext(self.context)
                })
        }).navigationViewStyle(StackNavigationViewStyle())
    }
}

struct EditCategory_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAAAAAAAAh")
    }
}
