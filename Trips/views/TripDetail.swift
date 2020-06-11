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
    
    @State var addActionSheet = false
    @State var completedAlert = false
    
    @Binding var accent: Color
    
    var trip: Trip

    var categoryRequest : FetchRequest<Category>
    var itemRequest: FetchRequest<Item>
    
    var categories: FetchedResults<Category>{categoryRequest.wrappedValue}
    var items: FetchedResults<Item>{itemRequest.wrappedValue}
    
    init(trip: Trip, accent: Binding<Color>) {
        self.trip = trip
        self.categoryRequest = FetchRequest(entity: Category.entity(),sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate:
            NSPredicate(format: "%K == %@", #keyPath(Category.trip), trip))
        
        self.itemRequest = FetchRequest(fetchRequest: Item.itemsInTripFetchRequest(trip: trip))
        
        self._accent = accent
    }
    
    var body: some View {
        ZStack {
            VStack {
                if !(!self.trip.showCompleted && (self.items.filter {$0.completed == false}).count == 0 && self.items.count > 0) {
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
                                                EditItem(item: item, accent: self.accent, trip: self.trip).environment(\.managedObjectContext, self.context)
                                            })
                                            Spacer()
                                            Button(action: {
                                                self.toggleItemCompleted(item)
                                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                                impactMed.impactOccurred()
                                                
                                                // If there are no uncompleted items
                                                if (self.items.filter {$0.completed == false}).count == 0 {
                                                    self.completedAlert = true
                                                }
                                            }) {
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
                                        }.contextMenu(menuItems: {
                                            Button(action: {
                                                self.itemModalDisplayed = true
                                            }) {
                                                Text("Edit Item")
                                                Image(systemName: "pencil.circle")
                                            }
                                            Button(action: {
                                                self.toggleItemCompleted(item)
                                            }) {
                                                Text(item.completed ? "Uncheck Item" : "Check Item")
                                                Image(systemName: "checkmark.circle")
                                            }
                                        })
                                    }
                                }.onDelete(perform: self.getDeleteFunction(category: category))
                                    .onMove(perform: self.getMoveFunction(category: category))
                            }
                        }
                        Text("")
                        Text("")
                    }
                //Text(refreshing ? "" : "")
                } else {
                    if self.trip.categories.count > 0 && self.items.count > 0 {
                        AddButton(action: {
                            do {
                                try self.trip.beginNextLeg(context: self.context)
                            } catch {
                                print(error)
                            }
                        }, text: "Begin Next Leg", accent: self.accent)
                        Text("This will uncheck all items.").font(.callout)
                    }
                }
            }
            VStack {
                Spacer()
                HStack {
                    AddExpander(color: self.accent, showAddItem: self.$modalDisplayed, showAddCategory: self.$categoryModalDisplayed).padding()
                }
            }
        }
        .navigationBarTitle(trip.name)
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    print("Hidden 0.5")
                }) {
                    Spacer()
                }.alert(isPresented: $completedAlert, content: {
                    Alert(title: Text("All Items Checked"),
                          message: Text("Would you like to uncheck all items for the next leg of your Trip?"),
                          primaryButton: Alert.Button.default(Text("Begin Next Leg"), action: {
                            do {
                                try self.trip.beginNextLeg(context: self.context)
                            } catch {
                                print(error)
                            }
                          }), secondaryButton: Alert.Button.cancel(Text("Dismiss")))
                })
                Button(action: {
                    self.editTripDisplayed = true
                }, label: {
                    Image(systemName: "info.circle")
                    }).padding()
                    .sheet(isPresented: $editTripDisplayed, content: {
                        EditTrip(trip: self.trip, refreshing: self.$refreshing, accent: self.$accent).environment(\.managedObjectContext, self.context)
                    }).padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 0))
                Button(action: {
                    print("Hidden 1")
                }) {
                    Spacer()
                }
                .sheet(isPresented: $modalDisplayed, content: {
                    AddItem(categories: self.trip.categories.allObjects as! [Category], refreshing: self.$refreshing, accent: self.accent).environment(\.managedObjectContext, self.context)
                })
                Button(action: {
                    print("Hidden 2")
                }) {
                    Spacer()
                }
                .sheet(isPresented: $categoryModalDisplayed, content: {
                    AddCategory(trip: self.trip, refreshing: self.$refreshing, accent: self.accent).environment(\.managedObjectContext, self.context)
                })
                EditButton().padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 0))
            }).onAppear(perform: {
                self.accent = Color.fromString(color: self.trip.color ?? "blue")
            }).onDisappear(perform: {
                if (UIDevice.current.userInterfaceIdiom == .phone) {
                    self.accent = Color.blue
                }
            })
    }
    
    func getDeleteFunction(category: Category) -> (IndexSet) -> Void {
        func delete(at offsets: IndexSet) {
            let items = fetchItems(category, context)
            
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
                items.append(fetchItems(category, self.context)[index])
            }
            
            for item in items {
                Item.adjustItemIndex(source: item.index, index: destination, category: category, context: self.context)
                item.index = (fetchItems(category, self.context).count != destination ? destination : destination - 1)
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
