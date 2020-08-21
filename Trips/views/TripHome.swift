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
    
    @Binding var primarySelectionType: PrimarySelectionType
    @Binding var primaryViewSelection: NSManagedObjectID?

    @Binding var accent: Color
    
    @FetchRequest(fetchRequest: Trip.allTripsFetchRequest()) var trips: FetchedResults<Trip>
    
    @State var showAddTrip = false
    
    var body: some View {
        NavigationView {
            VStack {
                if (trips.count > 0) {
                    List {
                        ForEach(sortTrips(trips)) {trip in
                            NavigationLink(destination: TripDetail(trip: trip, accent: $accent, primaryViewSelection: $primaryViewSelection).onAppear(perform: {primarySelectionType = .trip}), tag:trip.objectID, selection: $primaryViewSelection) {
                                    Button(action: {
                                        primaryViewSelection = trip.objectID
                                    }) {
                                        TripHomeRow(trip: trip)
                                    }
                                }
                            }
                    }.listStyle(DefaultListStyle())
                } else {
                    AddButton(action: {showAddTrip = true}, text: "Add a Trip!")
                    Button(action: {
                        SampleDataFactory(context: context).addSampleTrips()
                    }) {
                        Text("Or add example Trips.")
                    }
                    
                }
            }
            .navigationBarTitle("Trips")
        .navigationBarItems(
             trailing: Button(action: {
                    showAddTrip = true
                 }) {
                    Image(systemName: "plus")
                }.padding()
            )
            
            Text("No Trip Selected").font(.subheadline).onAppear(perform: {
                accent = Color.blue
            })
        }.accentColor(accent)
        .onDisappear(perform: {
            accent = Color.blue
        })

    }
}

struct TripsHome_Previews: PreviewProvider {
    static var previews: some View {
        //TripHome()
        Text("Hello!")
    }
}
