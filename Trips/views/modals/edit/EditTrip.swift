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
    
    var categoryRequest : FetchRequest<Category>
    
    var trip: Trip
    
    @State var showCompleted: Bool
    @State var updatedTitle: String = ""
    
    @State var updatedStartDate: Date = Date()
    @State var updatedEndDate: Date = Date()
    
    @State var showStartDate: Bool = false
    @State var showEndDate: Bool = false
    
    @State var updatedColor: String
    
    @State var showAddTemplateExisting: Bool = false
    @Binding var refreshing: Bool
    
    var validDates: Bool {
        get {
            checkDateValidity(startDate: updatedStartDate, endDate: updatedEndDate, showStartDate: showStartDate, showEndDate: showEndDate)
        }
    }
    
    var categories: FetchedResults<Category>{categoryRequest.wrappedValue}
    init(trip: Trip, refreshing: Binding<Bool>) {
        self.trip = trip
        self.categoryRequest = FetchRequest(entity: Category.entity(),sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate:
            NSPredicate(format: "%K == %@", #keyPath(Category.trip), trip))
        self._showCompleted = State.init(initialValue: trip.showCompleted)
        if let color = trip.color {
            self._updatedColor = State.init(initialValue: color)
        } else{
            self._updatedColor = State.init(initialValue: "none")
        }
        
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
                    ColorPicker(updatedColor: $updatedColor)
                }
                Section(header: Text("Categories")) {
                    ForEach(self.categories, id: \.self) { category in
                    Text(category.name)
                   }.onDelete(perform: self.deleteCategory)
                }
                
                Button(action: {
                    do {
                        self.context.delete(self.trip)
                        try self.context.save()
                    } catch {
                        print(error)
                    }
                    
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Delete").foregroundColor(.red)
                }
                
                
            }
            .navigationBarTitle("Edit Trip")
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Close")
                }))
        }.onDisappear {
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
            self.trip.color = self.updatedColor
            
            saveContext(self.context)
        }
    }
    
    func deleteCategory(at offsets: IndexSet) {
        for offset in offsets {
            self.trip.removeFromCategories(self.categories[offset])
        }
            
        saveContext(self.context)
    }
}

struct EditTrip_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAh")
    }
}
