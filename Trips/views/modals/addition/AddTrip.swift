//
//  AddTrip.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-12-17.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct AddTrip: View {
    @State var title: String = ""
    @State var color: String = ""
    @State var startDate: Date = Date()
    @State var showStartDate: Bool = false
    @State var endDate: Date = Date()
    @State var showEndDate: Bool = false
    
    @Environment(\.managedObjectContext) var context
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var validDates: Bool {
        get {
            checkDateValidity(startDate: startDate, endDate: endDate, showStartDate: showStartDate, showEndDate: showEndDate)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Trip Name", text: $title)
                }
                
                TripDateSelector(startDate: self.$startDate, endDate: self.$endDate, showStartDate: self.$showStartDate, showEndDate: self.$showEndDate, validDates: self.validDates)
                
                Section {
                    ColorPicker(updatedColor: $color)
                }
                
                Section {
                    Button(action: {
                        self.saveTrip()
                    }) {
                        Text("Save")
                    }.disabled(!self.checkTripValidity())
                }
            }.navigationBarTitle("Add Trip")
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                }))
        }
    }
    
    func checkTripValidity() -> Bool {
        if !self.validDates {
            return false
        }
        if self.title.count == 0 {
            return false
        }
        return true
    }
    
    func saveTrip() {
        let pendingTrip = Trip(context: self.context)
        
        pendingTrip.name = self.title
        if self.showStartDate {
            pendingTrip.startDate = self.startDate
        }
        if self.showEndDate {
            pendingTrip.endDate = self.endDate
        }
        pendingTrip.color = self.color.count > 0 ? self.color : nil
        
        saveContext(self.context)
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddTrip_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAaH")
    }
}
