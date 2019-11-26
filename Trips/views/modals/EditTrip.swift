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
    
    var trip: Trip
    
    @State var updatedTitle: String = ""
    @State var updatedStartDate: Date = Date()
    @State var updatedEndDate: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Trip Name", text: $updatedTitle)
                        .onAppear {
                            self.updatedTitle = self.trip.name
                    }
                }
                Section {
                    DatePicker(selection: $updatedStartDate, in: ...updatedEndDate, displayedComponents: .date, label: { Text("Start Date")
                    }).onAppear {
                        self.updatedStartDate = self.trip.startDate
                    }
                    DatePicker(selection: $updatedEndDate, in: updatedStartDate..., displayedComponents: .date, label: { Text("End Date")
                    }).onAppear {
                        self.updatedEndDate = self.trip.endDate
                    }
                }
                Button(action: {
                    self.trip.name = self.updatedTitle
                    self.trip.startDate = self.updatedStartDate
                    self.trip.endDate = self.updatedEndDate
                    
                    do {
                        try self.context.save()
                    } catch {
                        print(error)
                    }
                    
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save!")
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
                    Text("Cancel")
                }))
        }
    }
}

struct EditTrip_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAh")
    }
}
