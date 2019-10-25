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
    
    @State var modalDisplayed = false
    
    var trip: Trip
    
    var body: some View {
        List {
            ForEach((trip.packs.array as! [Pack])) {pack in
                Section(header: Text(pack.name)) {
                    ForEach((pack.items.array as! [Item])) { item in
                        Text(item.name)
                    }
                }
            }
            }.navigationBarTitle(trip.name)
            .navigationBarItems(trailing:
                Button(action: {
                    self.modalDisplayed = true
                }, label: {
                    Image(systemName: "plus")
                }
                    // Learned a cool fact, .sheet gets an empty environment, so, gotta recreate it
                    ).padding()
                    .sheet(isPresented: $modalDisplayed, content: {
                    AddItem(packs: self.trip.packs.array as! [Pack]).environment(\.managedObjectContext, self.context)
                }))
    }
}

struct TripItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("IMPLMENET PREVIEW PLS")
    }
}
