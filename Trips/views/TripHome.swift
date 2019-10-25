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
    
    var body: some View {
        NavigationView {
            List {
                ForEach((self.trips)) {trip in
                    NavigationLink(destination: TripDetail(trip: trip)) {
                        TripHomeRow(trip: trip)
                    }
                }
            }
            .navigationBarTitle("Trips")
        .navigationBarItems(trailing:
            Button(action: {
                do {
                    let trips = try self.context.fetch(Trip.allTripsFetchRequest())
                    for obj in trips {
                        self.context.delete(obj)
                    }
                    addSampleData(context: self.context)
                    
                } catch {
                    print(error)
                }
            }, label: {
                Image(systemName: "trash")
            }
            ))
        }
    }
}

struct TripsHome_Previews: PreviewProvider {
    static var previews: some View {
        //TripHome()
        Text("Hello!")
    }
}
