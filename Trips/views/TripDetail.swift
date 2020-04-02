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
    @Environment(\.editMode) var editMode
    
    @State var modalDisplayed = false
    @State var refreshing = false
    @State var showCompleted = false
    
    @State var itemModalDisplayed = false
    @State var categoryModalDisplayed = false
    @State var editTripDisplayed = false
    
    var trip: Trip

    var categoryRequest : FetchRequest<Category>
    
    var itemRequest : FetchRequest<Item>
    
    var categories: FetchedResults<Category>{categoryRequest.wrappedValue}
    var items: FetchedResults<Item>{itemRequest.wrappedValue}
    
    init(trip: Trip) {
        self.trip = trip
        self.categoryRequest = FetchRequest(entity: Category.entity(),sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate:
            NSPredicate(format: "%K == %@", #keyPath(Category.trip), trip))
        
        self.itemRequest = FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate:
            NSPredicate(format: "%K IN %@", #keyPath(Item.category), self.trip.categories))
    }
    
    var body: some View {
        List {
            ForEach(self.categories, id: \.self) {category in
                // Same hack used in TripHomeRow.swift, but A. it seems to work, and B. I can't find another way around it. Basically, it manually refereshes view
                Section(header: Text(category.name + (self.refreshing ? "" : ""))) {
                    ForEach(self.items.filter {$0.category == category}) { item in
                        if (!item.completed || self.trip.showCompleted) && !self.editTripDisplayed {
                            HStack {
                                Button(action: {self.itemModalDisplayed = true}) {
                                    Text(item.name)
                                }.sheet(isPresented: self.$itemModalDisplayed, content: {
                                    EditItem(item: item).environment(\.managedObjectContext, self.context)
                                })
                                Spacer()
                                Button(action: {self.toggleItemCompleted(item)}) {
                                    ZStack {
                                    RoundedRectangle(cornerRadius: CGFloat(15))
                                    .stroke(Color.secondary, lineWidth: CGFloat(3))
                                        
                                        if item.completed {
                                            Circle().fill(Color.secondary)
                                                .frame(width: CGFloat(16.0), height: CGFloat(16.0))
                                        }
                                        
                                    }.frame(width: CGFloat(26.0), height: CGFloat(26.0))
                                    .padding(EdgeInsets(top: CGFloat(0), leading: CGFloat(0), bottom: CGFloat(0), trailing: CGFloat(10)))
                                }.buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }.onDelete(perform: self.getDeleteFunction(category: category))
                        .onMove(perform: self.getMoveFunction(category: category))
                    
                    
                }
            }
            //Text(refreshing ? "" : "")
            }.navigationBarTitle(trip.name)
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    self.editTripDisplayed = true
                }, label: {
                    Image(systemName: "info.circle")
                    }).padding()
                    .sheet(isPresented: $editTripDisplayed, content: {
                        EditTrip(trip: self.trip, refreshing: self.$refreshing).environment(\.managedObjectContext, self.context)
                    })
                    Button(action: {
                        self.categoryModalDisplayed = true
                    }, label: {
                        Image(systemName: "plus.rectangle.on.rectangle")
                    }
                        // Learned a cool fact, .sheet gets an empty environment, so, gotta recreate it
                        ).padding()
                        .sheet(isPresented: $categoryModalDisplayed, content: {
                            AddCategory(trip: self.trip, refreshing: self.$refreshing).environment(\.managedObjectContext, self.context)
                        })
                    Button(action: {
                        self.modalDisplayed = true
                    }, label: {
                        Image(systemName: "plus")
                    }
                        // Learned a cool fact, .sheet gets an empty environment, so, gotta recreate it
                        ).padding()
                        .sheet(isPresented: $modalDisplayed, content: {
                            AddItem(categories: self.trip.categories.array as! [Category], refreshing: self.$refreshing).environment(\.managedObjectContext, self.context)
                        })
                    EditButton()
            })
    }
    
    func fetchItems(_ category: Category) -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest() as! NSFetchRequest<Item>
        
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Item.category), category)
        
        do {
            return try self.context.fetch(request)
        } catch {
            print(error)
            return []
        }
        
    }
    
    func getDeleteFunction(category: Category) -> (IndexSet) -> Void {
        func delete(at offsets: IndexSet) {
            let items = self.fetchItems(category)
            
            for offset in offsets {
                category.removeFromItems(items[offset])
                //self.context.delete(items[offset])
            }
                        
            saveContext(self.context)
            self.refreshing.toggle()
            
        }
        
        return delete
    }
    
    func toggleItemCompleted(_ item: Item) -> Void {
        item.completed.toggle()
        saveContext(self.context)
        self.refreshing.toggle()
    }
    
    func getMoveFunction(category: Category) -> (IndexSet, Int) -> Void {
        func moveItem(from source: IndexSet, to destination: Int) {
            var items: [Item] = []
            for index in source {
                items.append(fetchItems(category)[index])
            }
            
            for item in items {
                Item.adjustItemIndex(source: item.index, index: destination, category: category, context: self.context)
                item.index = (self.fetchItems(category).count != destination ? destination : destination - 1)
            }
            
            saveContext(self.context)
        }
        
        return moveItem
    }
    
    
}

struct TripItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("IMPLMENET PREVIEW PLS")
    }
}
