//
//  AddTrip.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-12-17.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

enum TripError : Error {
    case TemplateIsCategoryError(String)
}

struct AddTrip: View {
    @State var title: String = ""
    @State var color: Color = Color.blue
    @State var icon: String = "house.fill"
    @State var startDate: Date = Date()
    @State var showStartDate: Bool = false
    @State var endDate: Date = Date()
    @State var showEndDate: Bool = false
    @State var includedTemplates: [Category] = []
    
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
                
                TripDateSelector(date: self.$startDate, showDate: self.$showStartDate, validDates: self.validDates, isEndDate: false)
                
                TripDateSelector(date: self.$endDate, showDate: self.$showEndDate, validDates: self.validDates, isEndDate: true)
                
                Section {
                    NavigationLink(destination: IncludeTemplates(included: $includedTemplates)) {
                        Text("Templates")
                    }
                }
                
                Section(header: Text("Color")) {
                    ColorPicker(updatedColor: $color)
                }
                
                Section(header: Text("Icon")) {
                    IconPicker(selectedIcon: self.$icon)
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
        }.navigationViewStyle(StackNavigationViewStyle())
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
        pendingTrip.color = self.color.description
        pendingTrip.icon = self.icon
        
        for tomplate in self.includedTemplates {
            do {
                try copyTemplateToTrip(template: tomplate, trip: pendingTrip, context: self.context)
            } catch {
                print(error)
            }
        }
        
        saveContext(self.context)
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddTrip_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAaH")
    }
}
