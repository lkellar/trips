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
            ForEach(trips.filter {$0 != trip}.reversed(), id: \.self) { trip in
                Button(action:{
                    showSelf = false
                    copyToOther(category: category, trip: trip, context: context)
                }) {
                    TripHomeRow(trip: trip)
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
