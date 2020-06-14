//
//  EditTrip.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-11-15.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

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
    
    var validDates: Bool {
        get {
            checkDateValidity(startDate: updatedStartDate, endDate: updatedEndDate, showStartDate: showStartDate, showEndDate: showEndDate)
        }
    }
    
    var categories: FetchedResults<Category>{categoryRequest.wrappedValue}
    init(trip: Trip, refreshing: Binding<Bool>, accent: Binding<Color>) {
        self.trip = trip
        self.categoryRequest = FetchRequest(entity: Category.entity(),sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate:
            NSPredicate(format: "%K == %@", #keyPath(Category.trip), trip))
        self._showCompleted = State.init(initialValue: trip.showCompleted)
        
        if let startDate = trip.startDate {
            self._updatedStartDate = State.init(initialValue: startDate)
            self._showStartDate = State.init(initialValue: true)
        } else {
            self._updatedStartDate = State.init(initialValue: Date())
        }
        
        if let endDate = trip.endDate {
            self._updatedEndDate = State.init(initialValue: endDate)
            self._showEndDate = State.init(initialValue: true)
        } else {
            self._updatedEndDate = State.init(initialValue: Date())
        }
        
        self._refreshing = refreshing
        
        self._accent = accent
        
        if let icon = trip.icon {
            self._updatedIcon = State.init(initialValue: icon)
        } else {
            self._updatedIcon = State.init(initialValue: "house.fill")
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Trip Name", text: $updatedTitle)
                        .onAppear {
                            self.updatedTitle = self.trip.name
                    }
                }
                Toggle("Show Completed Items", isOn: $showCompleted)
                
                TripDateSelector(date: self.$updatedStartDate, showDate: self.$showStartDate, validDates: self.validDates, isEndDate: false)
                
                TripDateSelector(date: self.$updatedEndDate, showDate: self.$showEndDate, validDates: self.validDates, isEndDate: true)
                
                Section(header: Text("Color")) {
                    ColorPicker(updatedColor: $accent)
                }

                Section(header: Text("Icon")) {
                    IconPicker(selectedIcon: self.$updatedIcon)
                }
                
                if (self.categories.count > 0) {
                    Section(header: Text("Categories")) {
                        ForEach(self.categories, id: \.self) { category in
                            NavigationLink(destination: EditCategory(category: category, accent: self.accent)) {
                                Text(category.name)
                            }
                       }.onDelete(perform: self.deleteCategory)
                            .onMove(perform: self.moveCategory)
                    }
                }
                
                Section(footer: Text("This will uncheck all items")) {
                    Button(action: {
                        do {
                            try self.trip.beginNextLeg(context: self.context)
                            self.presentationMode.wrappedValue.dismiss()
                        } catch {
                            print(error)
                        }
                    }) {
                        Text("Begin Next Leg")
                    }
                }
                
                Section {
                
                    Button(action: {
                        self.showDeleteAlert = true;
                    }) {
                        Text("Delete").foregroundColor(.red)
                    }.alert(isPresented: self.$showDeleteAlert, content: {
                        Alert(title: Text("Are you sure you want to delete \(self.updatedTitle)?"),
                              message: Text("This cannot be undone."),
                              primaryButton: Alert.Button.destructive(Text("Delete"), action: {
                            do {
                                self.context.delete(self.trip)
                                try self.context.save()
                            } catch {
                                print(error)
                            }
                            
                            self.presentationMode.wrappedValue.dismiss()
                              }), secondaryButton: Alert.Button.cancel(Text("Cancel")))
                    })
                }
            }
            .navigationBarTitle("Edit Trip")
            .navigationBarItems(leading:

                EditButton(), trailing:
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Close")
                })
            )
        }.navigationViewStyle(StackNavigationViewStyle())
        .accentColor(self.accent)
        .onDisappear {
            self.trip.name = self.updatedTitle
            if self.validDates {
                if self.showStartDate {
                    self.trip.startDate = self.updatedStartDate
                } else {
                    self.trip.startDate = nil
                }
                if self.showEndDate {
                    self.trip.endDate = self.updatedEndDate
                } else {
                    self.trip.endDate = nil
                }
            }
            self.trip.showCompleted = self.showCompleted
            self.trip.color = self.accent.description
            self.trip.icon = self.updatedIcon
            
            saveContext(self.context)
        }
    }
    
    func deleteCategory(at offsets: IndexSet) {
        for offset in offsets {
            self.trip.removeFromCategories(self.categories[offset])
        }
            
        saveContext(self.context)
    }
    
    func moveCategory(from source: IndexSet, to destination: Int) {
        var items: [Category] = []
        for index in source {
            items.append(self.categories[index])
        }
        
        for item in items {
            Category.adjustCategoryIndex(source: item.index, index: destination, trip: self.trip, context: self.context)
            item.index = (self.categories.count != destination ? destination : destination - 1)
        }
        
        saveContext(self.context)
    }
}

struct EditTrip_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAh")
    }
}
