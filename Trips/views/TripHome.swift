//
//  TripsHome.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-09-18.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct TripHome: View {
    var trips: [Trip]
    
    var body: some View {
        NavigationView {
            List {
                ForEach((trips), id:  \.self) {trip in
                    NavigationLink(destination: TripDetail(trip: trip)) {
                        TripHomeRow(trip: trip)
                    }
                }
            }
            .navigationBarTitle("Trips")
        }
    }
}

struct TripsHome_Previews: PreviewProvider {
    static var previews: some View {
        TripHome(trips: exampleTrips)
    }
}
