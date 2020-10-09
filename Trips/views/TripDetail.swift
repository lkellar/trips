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
    @State var templateModalDisplayed = false
    
    @State var addActionSheet = false
    @State var completedAlert = false
    @State var showModals = false
    
    @State var addItemToggle = false
    @State var addCategoryToggle = false
    @State var addTemplateToggle = false
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    #endif
    
    @Binding var globalAccent: Color
    @Binding var selection: SelectionConfig
    
    var trip: Trip
    
    var categoryRequest : FetchRequest<Category>
    var itemRequest: FetchRequest<Item>
    
    var categories: FetchedResults<Category>{categoryRequest.wrappedValue}
    var items: FetchedResults<Item>{itemRequest.wrappedValue}
    
    init(trip: Trip, selection: Binding<SelectionConfig>) {
        self.trip = trip
        categoryRequest = FetchRequest(entity: Category.entity(),sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate:
            NSPredicate(format: "%K == %@", #keyPath(Category.trip), trip))
        
        itemRequest = FetchRequest(fetchRequest: Item.itemsInTripFetchRequest(trip: trip))
        
        _globalAccent = Binding.constant(.blue)
        _selection = selection
    }
    
    init(trip: Trip, selection: Binding<SelectionConfig>, globalAccent: Binding<Color>) {
        self.trip = trip
        categoryRequest = FetchRequest(entity: Category.entity(),sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate:
            NSPredicate(format: "%K == %@", #keyPath(Category.trip), trip))
        
        itemRequest = FetchRequest(fetchRequest: Item.itemsInTripFetchRequest(trip: trip))
        
        _globalAccent = globalAccent
        _selection = selection
    }
        
    var body: some View {
        if trip.isDeleted {
            Text("No Trip Selected").font(.subheadline)
                .onAppear(perform: {
                    globalAccent = .blue
                })
                .navigationBarTitle("No Trip Selected")
                .navigationBarItems(trailing: EmptyView())
        } else {
            ZStack {
                VStack {
                    if !(!trip.showCompleted && (items.filter {$0.completed == false}).count == 0 && items.count > 0) {
                        List {
                            ForEach(categories, id: \.self) {category in
                                // Same hack used in TripHomeRow.swift, but A. it seems to work, and B. I can't find another way around it. Basically, it manually refereshes view
                                Section(header: Text(category.name + (refreshing ? "" : ""))) {
                                    ForEach(items.filter {$0.category == category}) { item in
                                        if (!item.completed || trip.showCompleted) && !editTripDisplayed {
                                            HStack {
                                                Button(action: {
                                                    selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection,
                                                                  secondaryViewSelectionType: selection.secondaryViewSelection == item.objectID ? nil : .editItem,
                                                                  secondaryViewSelection: selection.secondaryViewSelection == item.objectID ? nil : item.objectID)
                                                    if (showModals) {
                                                        itemModalDisplayed = true
                                                    }
                                                }) {
                                                    Text(item.name)
                                                        .accentColor(.primary)
                                                }
                                                Spacer()
                                                Button(action: {
                                                    toggleItemCompleted(item)
                                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                                    impactMed.impactOccurred()
                                                    
                                                    // If there are no uncompleted items
                                                    if (items.filter {$0.completed == false}).count == 0 {
                                                        completedAlert = true
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
                                            }
                                        }
                                    }.onDelete(perform: getDeleteFunction(category: category))
                                        .onMove(perform: getMoveFunction(category: category))
                                }
                            }
                        }.listStyle(GroupedListStyle())
                    } else {
                        if trip.categories.count > 0 && items.count > 0 {
                            AddButton(action: {
                                do {
                                    try trip.beginNextLeg(context: context)
                                } catch {
                                    print(error)
                                }
                            }, text: "Begin Next Leg", accent: .accentColor)
                            Text("This will uncheck all items.").font(.callout)
                        }
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        AddExpander(color: .accentColor, showAddItem: $addItemToggle, showAddCategory: $addCategoryToggle, showAddTemplate: $addTemplateToggle).padding()
                    }
                }
            }
            .accentColor(globalAccent)
            .navigationBarTitle(trip.name)
                .navigationBarItems(trailing: HStack {
                    Button(action: {
                        print("Hidden 0.5")
                    }) {
                        Text(refreshing ? "" : "")
                    }.alert(isPresented: $completedAlert, content: {
                        Alert(title: Text("All Items Checked"),
                              message: Text("Would you like to uncheck all items for the next leg of your Trip?"),
                              primaryButton: Alert.Button.default(Text("Begin Next Leg"), action: {
                                do {
                                    try trip.beginNextLeg(context: context)
                                } catch {
                                    print(error)
                                }
                              }), secondaryButton: Alert.Button.cancel(Text("Dismiss")))
                    })
                    Button(action: {
                        if (showModals) {
                            editTripDisplayed = true
                        }
                        selection.secondaryViewSelectionType = selection.secondaryViewSelectionType == .editTrip ? nil : .editTrip
                    }, label: {
                        Image(systemName: "info.circle").foregroundColor(globalAccent)
                        }).padding()
                        .sheet(isPresented: $editTripDisplayed, content: {
                            EditTrip(trip: trip, refreshing: $refreshing, globalAccent: $globalAccent, selection: $selection).environment(\.managedObjectContext, context)
                        }).padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 0))
                    Button(action: {
                        print("Hidden 1")
                    }) {
                        Spacer()
                    }
                    .sheet(isPresented: $modalDisplayed, content: {
                        AddItem(categories: trip.categories.allObjects as! [Category], selectCategory: true, refreshing: $refreshing, accent: globalAccent, selection: $selection).environment(\.managedObjectContext, context)
                    })
                    Button(action: {
                        print("Hidedn 1.5")
                    }) {
                        Spacer()
                    }.sheet(isPresented: $itemModalDisplayed, content: {
                        EditItem(selection: $selection, accent: $globalAccent).environment(\.managedObjectContext, context)
                    })
                    Button(action: {
                        print("Hidden 2")
                    }) {
                        Spacer()
                    }
                    .sheet(isPresented: $categoryModalDisplayed, content: {
                        AddCategory(trip: trip, refreshing: $refreshing, accent: globalAccent, selection: $selection).environment(\.managedObjectContext, context)
                    })
                    Button(action: {
                        print("Hidden 3")
                    }) {
                        Spacer()
                    }
                    .sheet(isPresented: $templateModalDisplayed, content: {
                        AddTemplateToExisting(trip: trip, refreshing: $refreshing, accent: globalAccent, selection: $selection).environment(\.managedObjectContext, context)
                    })
                    EditButton().foregroundColor(globalAccent).padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 25))
                })
            .onAppear(perform: {
                globalAccent = Color.fromString(color: trip.color ?? "blue")
                selection.viewSelection = trip.objectID
                #if os(iOS)
                if horizontalSizeClass == .compact {
                    showModals = true
                }
                #endif
            })
            .onChange(of: trip) { newTrip in
                globalAccent = Color.fromString(color: newTrip.color ?? "blue")
            }
            .onChange(of: addItemToggle) {newAddItemToggle in
                selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection,
                    secondaryViewSelectionType: selection.secondaryViewSelectionType == .addItem ? nil : .addItem,
                  secondaryViewSelection: nil)
                if (showModals) {
                    modalDisplayed = true
                }
            }
            .onChange(of: addCategoryToggle) {newAddCategoryToggle in
                selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection,
                    secondaryViewSelectionType: selection.secondaryViewSelectionType == .addCategory ? nil : .addCategory,
                  secondaryViewSelection: nil)
                if (showModals) {
                    categoryModalDisplayed = true
                }
            }
            .onChange(of: addTemplateToggle) {newAddTemplateToggle in
                selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection,
                    secondaryViewSelectionType: selection.secondaryViewSelectionType == .addTemplate ? nil : .addTemplate,
                  secondaryViewSelection: nil)
                if (showModals) {
                    modalDisplayed = true
                }
            }
            .onDisappear(perform: {
                globalAccent = Color.blue
            })
        }
    }
    
    func getDeleteFunction(category: Category) -> (IndexSet) -> Void {
        func delete(at offsets: IndexSet) {
            let items = fetchItems(category, context)
            
            for offset in offsets {
                let item = items[offset]
                category.removeFromItems(item)
                context.delete(item)
            }
                        
            saveContext(context)
            refreshing.toggle()
            
        }
        
        return delete
    }
    
    func toggleItemCompleted(_ item: Item) -> Void {
        item.completed.toggle()
        saveContext(context)
        refreshing.toggle()
    }
    
    func getMoveFunction(category: Category) -> (IndexSet, Int) -> Void {
        func moveItem(from source: IndexSet, to destination: Int) {
            var items: [Item] = []
            for index in source {
                items.append(fetchItems(category, context)[index])
            }
            
            for item in items {
                Item.adjustItemIndex(source: item.index, index: destination, category: category, context: context)
                item.index = (fetchItems(category, context).count != destination ? destination : destination - 1)
            }
            
            saveContext(context)
        }
        
        return moveItem
    }
    
    
}

struct TripItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("IMPLMENET PREVIEW PLS")
    }
}
