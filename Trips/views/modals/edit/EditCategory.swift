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
    @State var updatedName: String = ""
    @State var showCopyToOther: Bool = false
    @State var showNoTripsAlert = false
    @State var showCreateTemplate: Bool = false
    
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
                    CreateTemplateFromCategory(category: self.category).environment(\.managedObjectContext, self.context)
                })
            }
            
            Section {
                Button(action: {
                    print("noo duplicate yet")
                }) {
                    Text("Duplicate")
                }
                Button(action: {
                    print("no deleteet t")
                }) {
                    Text("Delete")
                }.foregroundColor(.red)
            }
        }.navigationBarTitle(Text("Edit Category"))
            .navigationBarItems(leading: HStack {
                Text("").alert(isPresented: self.$showNoTripsAlert, content:{
                    Alert(title: Text("There are no other Trips"),
                        message: Text("Please go create another Trip first"),
                        dismissButton: .default(Text("Dismiss")))
                })
        })
    }
}

struct EditCategory_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAAAAAAAAh")
    }
}
