//
//  TripItems.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-09-20.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI
import CoreData

struct TripDetail: View {
    @Environment(\.managedObjectContext) var context
    
    @State var modalDisplayed = false
    @State var packModalDisplayed = false
    @State var editTripDisplayed = false
    @State var refreshing = false
    
    var trip: Trip

    var packRequest : FetchRequest<Pack>
    
    var packs: FetchedResults<Pack>{packRequest.wrappedValue}
    init(trip: Trip) {
        self.trip = trip
        self.packRequest = FetchRequest(entity: Pack.entity(),sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate:
            NSPredicate(format: "%K == %@", #keyPath(Pack.trip), trip))
    }
    
    var body: some View {
        List {
            ForEach(self.packs ) {pack in
                // Same hack used in TripHomeRow.swift, but A. it seems to work, and B. I can't find another way around it. Basically, it manually refereshes view
                Section(header: Text(pack.name + (self.refreshing ? "" : ""))) {
                    ForEach(self.fetchItems(pack)) { item in
                        Text(item.name)
                    }.onDelete(perform: self.getDeleteFunction(pack: pack))
                }
            }
            
            
            //Text(refreshing ? "" : "")
            }.navigationBarTitle(trip.name)
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        self.editTripDisplayed = true
                    }, label: {
                        Image(systemName: "info.circle")
                        }).padding()
                        .sheet(isPresented: $editTripDisplayed, content: {
                            EditTrip(trip: self.trip).environment(\.managedObjectContext, self.context)
                        })
                    Button(action: {
                        self.packModalDisplayed = true
                    }, label: {
                        Image(systemName: "plus.rectangle.on.rectangle")
                    }
                        // Learned a cool fact, .sheet gets an empty environment, so, gotta recreate it
                        ).padding()
                        .sheet(isPresented: $packModalDisplayed, content: {
                            AddPack(trip: self.trip).environment(\.managedObjectContext, self.context)
                        })
                    Button(action: {
                        self.modalDisplayed = true
                    }, label: {
                        Image(systemName: "plus")
                    }
                        // Learned a cool fact, .sheet gets an empty environment, so, gotta recreate it
                        ).padding()
                        .sheet(isPresented: $modalDisplayed, content: {
                            AddItem(packs: self.trip.packs.array as! [Pack]).environment(\.managedObjectContext, self.context)
                        })
            })
    }
    
    func fetchItems(_ pack: Pack) -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest() as! NSFetchRequest<Item>
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Item.pack), pack)
        
        do {
            return try self.context.fetch(request)
        } catch {
            print(error)
            return []
        }
        
    }
    
    func getDeleteFunction(pack: Pack) -> (IndexSet) -> Void {
        func delete(at offsets: IndexSet) {
            let items = self.fetchItems(pack)
            
            for offset in offsets {
                pack.removeFromItems(items[offset])
            }
                        
            saveContext(self.context)
            self.refreshing.toggle()
            
        }
        
        return delete
    }
    
    
}

struct TripItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("IMPLMENET PREVIEW PLS")
    }
}
