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
    
    @Binding var accent: Color
    
    @FetchRequest(fetchRequest: Trip.allTripsFetchRequest()) var trips: FetchedResults<Trip>
    
    @State var showAddTrip = false
    
    var body: some View {
        NavigationView {
            VStack {
                if (self.trips.count > 0) {
                    List {
                        ForEach(sortTrips(self.trips)) {trip in
                            NavigationLink(destination: TripDetail(trip: trip, accent: self.$accent)) {
                                TripHomeRow(trip: trip)
                                }
                            }
                    }
                } else {
                    AddButton(action: {self.showAddTrip = true}, text: "Add a Trip!")
                }
            }
            .navigationBarTitle("Trips")
        .navigationBarItems(
             trailing: Button(action: {
                    self.showAddTrip = true
                 }) {
                    Image(systemName: "plus")
                }.padding()
                .sheet(isPresented: $showAddTrip, content: {
                    AddTrip().environment(\.managedObjectContext, self.context)
                })
            )
            
            Text("No Trip Selected").font(.subheadline).onAppear(perform: {
                self.accent = Color.blue
            })
        }.accentColor(self.accent)
        .onDisappear(perform: {
            self.accent = Color.blue
        })

    }
    
    func sortTrips(_ trips: FetchedResults<Trip>) -> [Trip] {
        var newTrips = trips.filter {$0.startDate != nil}
        newTrips = newTrips.sorted(by: {$0.startDate! < $1.startDate!})
        newTrips.append(contentsOf: trips.filter {$0.startDate == nil})
        return newTrips
    }
}

struct TripsHome_Previews: PreviewProvider {
    static var previews: some View {
        //TripHome()
        Text("Hello!")
    }
}
