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
    
    @FetchRequest(fetchRequest: Pack.allPacksFetchRequest()) var packs: FetchedResults<Pack>
    
    @FetchRequest(fetchRequest: Item.allItemsFetchRequest()) var items: FetchedResults<Item>
    
    var body: some View {
        List {
            ForEach(self.packs.filter {$0.trip == self.trip} ) {pack in
                Section(header: Text(pack.name)) {
                    ForEach(self.items.filter {$0.pack == pack}) { item in
                        Text(item.name)
                    }.onDelete(perform: self.getDeleteFunction(pack: pack))
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
    
    func getDeleteFunction(pack: Pack) -> (IndexSet) -> Void {
        func delete(at offsets: IndexSet) {
            pack.removeFromItems(at: NSIndexSet(indexSet: offsets))
            
            do {
                try self.context.save()
            } catch {
                print(error)
            }
            
        }
        
        return delete
    }
    
    
}

struct TripItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("IMPLMENET PREVIEW PLS")
    }
}
