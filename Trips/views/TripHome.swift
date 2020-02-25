//
//  TripsHome.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-09-18.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI
import CoreData

struct TripHome: View {
    // ❇️ Core Data property wrappers
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(fetchRequest: Trip.allTripsFetchRequest()) var trips: FetchedResults<Trip>
    
    @State var showAddTrip = false
    
    var body: some View {
        NavigationView {
            VStack {
                if (self.trips.count > 0) {
                    List {
                        ForEach((self.trips)) {trip in
                            NavigationLink(destination: TripDetail(trip: trip)) {
                                TripHomeRow(trip: trip)
                                }
                            }
                    }
                } else {
                    AddButton(action: {self.showAddTrip = true}, text: "Add a Trip!")
                }
            }
            .navigationBarTitle("Trips")
        .navigationBarItems(leading:
            Button(action: {
                    do {
                        let trips = try self.context.fetch(Trip.allTripsFetchRequest())
                        for obj in trips {
                            self.context.delete(obj)
                        }

                        let packs = try self.context.fetch(Pack.allPacksFetchRequest())
                        for obj in packs {
                            self.context.delete(obj)
                        }
                        
                        let items = try self.context.fetch(Item.allItemsFetchRequest())
                        for obj in items {
                            self.context.delete(obj)
                        }
                        
                        addSampleData(context: self.context)
                        
                    } catch {
                        print(error)
                    }
                }, label: {
                    Image(systemName: "trash")
                }
                ).padding(),
             trailing: Button(action: {
                    self.showAddTrip = true
                 }) {
                    Image(systemName: "plus")
                }.padding()
                .sheet(isPresented: $showAddTrip, content: {
                    AddTrip().environment(\.managedObjectContext, self.context)
                })
            )
        }
    }
}

struct TripsHome_Previews: PreviewProvider {
    static var previews: some View {
        //TripHome()
        Text("Hello!")
    }
}
