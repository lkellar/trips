//
//  TripItems.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-09-20.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct TripDetail: View {
    var trip: Trip
    
    var body: some View {
        List {
            ForEach((trip.packs), id: \.self) {pack in
                Section(header: Text(pack.name)) {
                    ForEach((pack.items), id: \.self) { item in
                        Text(item.name)
                    }
                }
            }
        }.navigationBarTitle(trip.name)
    }
}

struct TripItem_Previews: PreviewProvider {
    static var previews: some View {
        TripDetail(trip: exampleTrips[0])
    }
}
