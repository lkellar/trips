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
    
    var packRequest : FetchRequest<Pack>
    
    var trip: Trip
    
    @State var showCompleted: Bool
    @State var updatedTitle: String = ""
    
    @State var updatedStartDate: Date = Date()
    @State var updatedEndDate: Date = Date()
    
    @State var showStartDate: Bool = false
    @State var showEndDate: Bool = false
    
    @State var updatedColor: String
    
    var validDates: Bool {
        get {
            checkDateValidity(startDate: updatedStartDate, endDate: updatedEndDate, showStartDate: showStartDate, showEndDate: showEndDate)
        }
    }
    
    var packs: FetchedResults<Pack>{packRequest.wrappedValue}
    init(trip: Trip) {
        self.trip = trip
        self.packRequest = FetchRequest(entity: Pack.entity(),sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate:
            NSPredicate(format: "%K == %@", #keyPath(Pack.trip), trip))
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
                
                TripDateSelector(startDate: self.$updatedStartDate, endDate: self.$updatedEndDate, showStartDate: self.$showStartDate, showEndDate: self.$showEndDate, validDates: self.validDates)
                
                Section(header: Text("Color")) {
                    ColorPicker(updatedColor: $updatedColor)
                }
                Section(header: Text("Packs")) {
                   ForEach(self.packs) { pack in
                    Text(pack.name)
                   }.onDelete(perform: self.deletePack)
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
                }
                if self.showEndDate {
                    self.trip.endDate = self.updatedEndDate
                }
            }
            self.trip.showCompleted = self.showCompleted
            self.trip.color = self.updatedColor
            
            saveContext(self.context)
        }
    }
    
    func deletePack(at offsets: IndexSet) {
        for offset in offsets {
            self.trip.removeFromPacks(self.packs[offset])
        }
            
        saveContext(self.context)
    }
}

struct EditTrip_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAh")
    }
}
