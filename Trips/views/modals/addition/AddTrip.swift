//
//  AddTrip.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-12-17.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import CoreData
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

    @Binding var selection: SelectionConfig
    var modal: Bool
    
    @Environment(\.managedObjectContext) var context
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var validDates: Bool {
        get {
            checkDateValidity(startDate: startDate, endDate: endDate, showStartDate: showStartDate, showEndDate: showEndDate)
        }
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Trip Name", text: $title)
            }
            
            TripDateSelector(date: $startDate, showDate: $showStartDate, validDates: validDates, isEndDate: false)
            
            TripDateSelector(date: $endDate, showDate: $showEndDate, validDates: validDates, isEndDate: true)
            
            Section {
                NavigationLink(destination: IncludeTemplates(included: $includedTemplates)) {
                    Text("Templates")
                }
            }
            
            Section(header: Text("Color")) {
                ColorPicker(updatedColor: $color)
            }
            
            Section(header: Text("Icon")) {
                IconPicker(selectedIcon: $icon)
            }
            
            Section {
                Button(action: {
                    let objectId = saveTrip()
                    
                    selection = SelectionConfig(primaryViewSelection: .trip, viewSelection: objectId)
                    if (modal) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Save")
                }.disabled(!checkTripValidity())
            }
        }.navigationBarTitle("Add Trip")
        .navigationBarItems(trailing:
                        Button(action: {
                            selection = SelectionConfig(primaryViewSelection: .trip, viewSelection: nil)
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            if (modal) {
                                Text("Cancel")
                            } else {
                                EmptyView()
                            }
                        }))
    }
    
    func checkTripValidity() -> Bool {
        if !validDates {
            return false
        }
        if title.count == 0 {
            return false
        }
        return true
    }
    
    func saveTrip() -> NSManagedObjectID {
        let pendingTrip = Trip(context: context)
        
        pendingTrip.name = title
        if showStartDate {
            pendingTrip.startDate = startDate
        }
        if showEndDate {
            pendingTrip.endDate = endDate
        }
        pendingTrip.color = color.description
        pendingTrip.icon = icon
        
        for tomplate in includedTemplates {
            do {
                try copyTemplateToTrip(template: tomplate, trip: pendingTrip, context: context)
            } catch {
                print(error)
            }
        }
        
        saveContext(context)
        
        return pendingTrip.objectID
    }
}

struct AddTrip_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAaH")
    }
}
