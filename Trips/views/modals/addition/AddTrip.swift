//
//  AddTrip.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-12-17.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

enum TripError : Error {
    case TemplateIsPackError(String)
}

struct AddTrip: View {
    @State var title: String = ""
    @State var color: String = ""
    @State var startDate: Date = Date()
    @State var showStartDate: Bool = false
    @State var endDate: Date = Date()
    @State var showEndDate: Bool = false
    @State var includedTemplates: [Pack] = []
    
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
        
        for tomplate in self.includedTemplates {
            do {
                try self.copyTemplateToTrip(template: tomplate, trip: pendingTrip)
            } catch {
                print(error)
            }
        }
        
        saveContext(self.context)
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func copyTemplateToTrip(template: Pack, trip: Trip) throws {
        guard template.isTemplate else {
            throw TripError.TemplateIsPackError("Provided \"template\" is NOT a template!")
        }
        let transitionPack = Pack(context: self.context)
        // completed and istemplate are by default set to false
        transitionPack.name = template.name
        for item in template.items {
            let itom = Item(context: self.context)
            itom.name = (item as! Item).name
            
            transitionPack.addToItems(itom)
        }
        
        trip.addToPacks(transitionPack)
    }
}

struct AddTrip_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAaH")
    }
}
