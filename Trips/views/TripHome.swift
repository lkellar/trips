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
    
    @Binding var selectionType: SelectionType
    @Binding var viewSelection: NSManagedObjectID?
    @Binding var accent: Color
    
    @FetchRequest(fetchRequest: Trip.allTripsFetchRequest()) var trips: FetchedResults<Trip>
    
    @State var showAddTrip = false
    
    var body: some View {
        NavigationView {
            VStack {
                if (self.trips.count > 0) {
                    List {
                        ForEach(sortTrips(self.trips)) {trip in
                            NavigationLink(destination: TripDetail(trip: trip, accent: self.$accent, selection: $viewSelection).onAppear(perform: {selectionType = .trip}), tag:trip.objectID, selection: $viewSelection) {
                                    Button(action: {
                                        viewSelection = trip.objectID
                                    }) {
                                        TripHomeRow(trip: trip)
                                    }
                                }
                            }
                    }.listStyle(DefaultListStyle())
                } else {
                    AddButton(action: {self.showAddTrip = true}, text: "Add a Trip!")
                    Button(action: {
                        SampleDataFactory(context: self.context).addSampleTrips()
                    }) {
                        Text("Or add example Trips.")
                    }
                    
                }
            }
            .navigationBarTitle("Trips")
        .navigationBarItems(
             trailing: Button(action: {
                    self.showAddTrip = true
                 }) {
                    Image(systemName: "plus")
                }.padding()
            )
            
            Text("No Trip Selected").font(.subheadline).onAppear(perform: {
                self.accent = Color.blue
            })
        }.accentColor(self.accent)
        .onDisappear(perform: {
            self.accent = Color.blue
        })

    }
}

struct TripsHome_Previews: PreviewProvider {
    static var previews: some View {
        //TripHome()
        Text("Hello!")
    }
}
