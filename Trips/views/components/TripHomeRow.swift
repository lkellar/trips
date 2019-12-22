//
//  TripsHomeRow.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-09-18.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI
import CoreData

struct TripHomeRow: View {
    var trip: Trip
    @Environment(\.managedObjectContext) var context
    
    @State var refreshing = false
    var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(trip.name).bold().font(.title)
                    Spacer()
                }
                HStack {
                    // Kind of a hack, but basically, if the trip name is 0, trip is deleted almost certainly, so don't calculate dates (which crashes app if trip is deleted)
                    Text(trip.name.count > 0 ? "\(trip.startDate != nil ? trip.startDate!.formatted_date : "") - \(trip.endDate != nil ? trip.endDate!.formatted_date: "")" : "").font(.subheadline)
                    Text(refreshing ? "": "")
                    Spacer()
                }
            }.layoutPriority(1.0)
            Spacer()
            ZStack {
                Circle().frame(width: CGFloat(64.0), height: CGFloat(64.0)).foregroundColor(Color.fromString(color: trip.color ?? "primary"))
                Image(systemName: "house.fill").foregroundColor(Color.white).font(.system(size: 32))
                
            }
        }.onReceive(self.didSave, perform: { _ in
            self.refreshing.toggle()
        })
    }
}

struct TripsHomeRow_Previews: PreviewProvider {
    static var previews: some View {
        Text("Example Trips?")
        /*List {
            //TripHomeRow(trip: exampleTrips[0])
            //TripHomeRow(trip: exampleTrips[1])
        }*/
    }
}
