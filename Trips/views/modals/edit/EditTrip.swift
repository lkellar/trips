//
//  EditTrip.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-11-15.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI
import CoreData

struct EditTrip: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Environment(\.managedObjectContext) var context
    
    @Environment(\.editMode) var editMode
    
    var categoryRequest : FetchRequest<Category>
    
    var trip: Trip
    
    @State var showCompleted: Bool
    @State var updatedTitle: String = ""
    
    @State var updatedStartDate: Date = Date()
    @State var updatedEndDate: Date = Date()
    
    @State var showStartDate: Bool = false
    @State var showEndDate: Bool = false
    
    @State var showDeleteAlert: Bool = false
    @State var updatedIcon: String
    
    @State var showAddTemplateExisting: Bool = false
    @Binding var refreshing: Bool
    
    @Binding var accent: Color
    @Binding var selection: NSManagedObjectID?
    
    var validDates: Bool {
        get {
            checkDateValidity(startDate: updatedStartDate, endDate: updatedEndDate, showStartDate: showStartDate, showEndDate: showEndDate)
        }
    }
    
    var categories: FetchedResults<Category>{categoryRequest.wrappedValue}
    init(trip: Trip, refreshing: Binding<Bool>, accent: Binding<Color>, selection: Binding<NSManagedObjectID?>) {
        self.trip = trip
        categoryRequest = FetchRequest(entity: Category.entity(),sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate:
            NSPredicate(format: "%K == %@", #keyPath(Category.trip), trip))
        _showCompleted = State.init(initialValue: trip.showCompleted)
        
        if let startDate = trip.startDate {
            _updatedStartDate = State.init(initialValue: startDate)
            _showStartDate = State.init(initialValue: true)
        } else {
            _updatedStartDate = State.init(initialValue: Date())
        }
        
        if let endDate = trip.endDate {
            _updatedEndDate = State.init(initialValue: endDate)
            _showEndDate = State.init(initialValue: true)
        } else {
            _updatedEndDate = State.init(initialValue: Date())
        }
        
        _refreshing = refreshing
        
        _accent = accent
        
        if let icon = trip.icon {
            _updatedIcon = State.init(initialValue: icon)
        } else {
            _updatedIcon = State.init(initialValue: "house.fill")
        }
        
        _selection = selection
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Trip Name", text: $updatedTitle)
                        .onAppear {
                            updatedTitle = trip.name
                    }
                }
                Toggle("Show Completed Items", isOn: $showCompleted)
                
                TripDateSelector(date: $updatedStartDate, showDate: $showStartDate, validDates: validDates, isEndDate: false)
                
                TripDateSelector(date: $updatedEndDate, showDate: $showEndDate, validDates: validDates, isEndDate: true)
                
                Section(header: Text("Color")) {
                    ColorPicker(updatedColor: $accent)
                }

                Section(header: Text("Icon")) {
                    IconPicker(selectedIcon: $updatedIcon)
                }
                
                if (categories.count > 0) {
                    Section(header: Text("Categories")) {
                        ForEach(categories, id: \.self) { category in
                            NavigationLink(destination: EditCategory(category: category, accent: accent)) {
                                Text(category.name)
                            }
                       }.onDelete(perform: deleteCategory)
                            .onMove(perform: moveCategory)
                    }
                }
                
                Section(footer: Text("This will uncheck all items")) {
                    Button(action: {
                        do {
                            try trip.beginNextLeg(context: context)
                        } catch {
                            print(error)
                        }
                    }) {
                        Text("Begin Next Leg")
                    }
                }
                
                Section {
                
                    Button(action: {
                        showDeleteAlert = true;
                    }) {
                        Text("Delete").foregroundColor(.red)
                    }.alert(isPresented: $showDeleteAlert, content: {
                        Alert(title: Text("Are you sure you want to delete \(updatedTitle)?"),
                              message: Text("This cannot be undone."),
                              primaryButton: Alert.Button.destructive(Text("Delete"), action: {
                                trip.categories.forEach {category in
                                    (category as! Category).items.forEach { item in
                                        context.delete(item as! NSManagedObject)
                                    }
                                    context.delete(category as! NSManagedObject)
                                }
                                context.delete(trip)
                                
                                selection = nil
                                presentationMode.wrappedValue.dismiss()
                              }), secondaryButton: Alert.Button.cancel(Text("Cancel")))
                    })
                }
            }
            .navigationBarTitle("Edit Trip")
            .navigationBarItems(leading:

                EditButton(), trailing:
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Close")
                })
            )
        }.navigationViewStyle(StackNavigationViewStyle())
        .accentColor(accent)
        .onDisappear {
            if !trip.isDeleted {
                trip.name = updatedTitle
                if validDates {
                    if showStartDate {
                        trip.startDate = updatedStartDate
                    } else {
                        trip.startDate = nil
                    }
                    if showEndDate {
                        trip.endDate = updatedEndDate
                    } else {
                        trip.endDate = nil
                    }
                }
                trip.showCompleted = showCompleted
                trip.color = accent.description
                trip.icon = updatedIcon
            }
            
            if trip.hasChanges {
                saveContext(context)
            }
        }
    }
    
    func deleteCategory(at offsets: IndexSet) {
        for offset in offsets {
            let category = categories[offset]
            trip.removeFromCategories(category)
            
            category.items.forEach {item in
                context.delete(item as! NSManagedObject)
            }
            context.delete(category)
        }
            
        saveContext(context)
    }
    
    func moveCategory(from source: IndexSet, to destination: Int) {
        var items: [Category] = []
        for index in source {
            items.append(categories[index])
        }
        
        for item in items {
            Category.adjustCategoryIndex(source: item.index, index: destination, trip: trip, context: context)
            item.index = (categories.count != destination ? destination : destination - 1)
        }
        
        saveContext(context)
    }
}

struct EditTrip_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAh")
    }
}
