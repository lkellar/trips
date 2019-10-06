//
//  TripItems.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-09-20.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct TripDetail: View {
    @Environment(\.managedObjectContext) var context
    
    var trip: Trip
    
    var body: some View {
        List {
            ForEach((trip.packs.array as! [Pack]), id: \.self) {pack in
                Section(header: Text(pack.name)) {
                    
                    ForEach((pack.items.array as! [Item]), id: \.self) { item in
                        Text(item.name)
                    }
                }
            }
            }.navigationBarTitle(trip.name)
            /*.navigationBarItems(trailing:
                Button(action: {
                    self.trip.packs[0].addToItems(Item(name:"2nd Laptop"))
                }, label: {
                    Image(systemName: "plus")
                })
        )*/
    }
}

struct TripItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("IMPLMENET PREVIEW PLS")
    }
}
