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
    
    @State var updatedColor: Color
    @Binding var globalAccent: Color
    @Binding var selection: SelectionConfig
    
    
    var validDates: Bool {
        get {
            checkDateValidity(startDate: updatedStartDate, endDate: updatedEndDate, showStartDate: showStartDate, showEndDate: showEndDate)
        }
    }
    
    init(trip: Trip, refreshing: Binding<Bool>, globalAccent: Binding<Color>, selection: Binding<SelectionConfig>) {
        self.trip = trip
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
        _globalAccent = globalAccent
        _selection = selection
        
        _updatedColor = State.init(initialValue: Color.fromString(color: trip.color ?? "blue"))
        
        if let icon = trip.icon {
            _updatedIcon = State.init(initialValue: icon)
        } else {
            _updatedIcon = State.init(initialValue: "house.fill")
        }
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
                    ColorPicker(updatedColor: $updatedColor)
                }

                Section(header: Text("Icon")) {
                    IconPicker(selectedIcon: $updatedIcon)
                }
                
                
                if (trip.categories.count > 0) {
                    NavigationLink(destination: CategoryList(trip: trip, accent: $updatedColor)) {
                        Text("Categories")
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
                                presentationMode.wrappedValue.dismiss()
                                selection = SelectionConfig(primaryViewSelection: .trip, viewSelection: nil)
                                DispatchQueue.main.async {
                                    trip.categories.forEach {category in
                                        (category as! Category).items.forEach { item in
                                            context.delete(item as! NSManagedObject)
                                        }
                                        context.delete(category as! NSManagedObject)
                                    }
                                    context.delete(trip)
                                    saveContext(context)
                                }
                              }), secondaryButton: Alert.Button.cancel(Text("Cancel")))
                    })
                }
            }
            .navigationBarTitle("Edit Trip")
            .navigationBarItems(trailing:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Close")
                        .foregroundColor(updatedColor)
                })
            )
        }.accentColor(updatedColor)
        .navigationViewStyle(StackNavigationViewStyle())
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
                trip.color = updatedColor.description
                globalAccent = updatedColor
                trip.icon = updatedIcon
            }
            
            if trip.hasChanges {
                saveContext(context)
            }
            refreshing.toggle()
        }
    }
}

struct EditTrip_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAh")
    }
}
