//
//  CopyToOtherTrip.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-04-24.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct CopyToOtherTrip: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: Trip.allTripsFetchRequest()) var trips: FetchedResults<Trip>
    
    var trip: Trip?
    var category: Category
    
    @Binding var showSelf: Bool
    
    var body: some View {
        // For some reason, maybe the filter? it presents backwards
        List {
            if self.showSelf {
                ForEach(self.trips.filter {$0 != self.trip}.reversed(), id: \.self) { trip in
                    Button(action:{
                        copyToOther(category: self.category, trip: trip, context: self.context)
                        self.showSelf = false
                    }) {
                        TripHomeRow(trip: trip)
                    }
                }
            }
        }
        
    }
    
}

struct CopyToOtherTrip_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAAAAAAAH")
    }
}
