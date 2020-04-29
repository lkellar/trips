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
                    if self.trips.count > 1 {
                        self.showCopyToOther = true
                    } else {
                        self.showNoTripsAlert = true
                    }
                }) {
                    Text("Copy to Other Trip")
                }.sheet(isPresented: $showCopyToOther, content: {
                    CopyToOtherTrip(trip: self.category.trip, category: self.category).environment(\.managedObjectContext, self.context)
                })
            }
            
            Section(footer: Text("This will create a template containing all items from this categor")) {
                Button(action: {
                    print("create template not implemented yet")
                }) {
                    Text("Create Template from Category")
                }
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
