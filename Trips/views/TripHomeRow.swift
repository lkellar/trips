//
//  TripsHomeRow.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-09-18.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct TripHomeRow: View {
    var trip: Trip
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(trip.name).bold().font(.title)
                    Spacer()
                }
                HStack {
                    Text("\(trip.startDate.formatted_date) - \(trip.endDate.formatted_date)").font(.subheadline)
                    Spacer()
                }
            }.layoutPriority(1)
            Spacer()
            ZStack {
                Circle().frame(width: 64, height: 64).foregroundColor(trip.color)
                Image(systemName: "house.fill").foregroundColor(Color.white).font(.system(size: 32))
                
            }
        }
    }
}

struct TripsHomeRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            TripHomeRow(trip: exampleTrips[0])
            TripHomeRow(trip: exampleTrips[1])
        }
    }
}
