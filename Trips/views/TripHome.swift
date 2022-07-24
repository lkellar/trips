//
//  TripsHome.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-09-18.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI
import CoreData

struct TripHome: View {
    // ❇️ Core Data property wrappers
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var selection: SelectionConfig

    @Binding var accent: Color
    
    @FetchRequest(fetchRequest: Trip.allTripsFetchRequest()) var trips: FetchedResults<Trip>
    
    @State var showAddTrip = false
    @State var showDeleteAlert: Bool = false
    @State var tripToDelete: Trip? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                if (trips.count > 0) {
                    List {
                        ForEach(sortTrips(trips)) {trip in
                            NavigationLink(destination: TripDetail(trip: trip, selection: $selection, globalAccent: $accent), tag:trip.objectID, selection: $selection.viewSelection) {
                                    Button(action: {
                                        selection.viewSelectionType = .trip
                                        selection.viewSelection = trip.objectID
                                    }) {
                                        TripHomeRow(trip: trip)
                                            .contextMenu {
                                                Button(action: {
                                                    selection.viewSelectionType = .trip
                                                    selection.viewSelection = trip.objectID
                                                    selection.secondaryViewSelectionType = .editTrip
                                                }) {
                                                    Label("Edit Trip", systemImage: "info.circle")
                                                }
                                                Button(action: {
                                                    tripToDelete = trip
                                                    showDeleteAlert = true
                                                }) {
                                                    // Changing color to red does not work
                                                    Label("Delete Trip", systemImage: "trash")
                                                }
                                        }
                                    }
                                }
                            }
                    }.listStyle(InsetGroupedListStyle())
                } else {
                    AddButton(action: {
                        showAddTrip = true
                        selection = SelectionConfig(viewSelectionType: .addTrip, viewSelection: nil)
                    }, text: "Add a Trip!")
                    Button(action: {
                        SampleDataFactory(context: context).addSampleTrips()
                    }) {
                        Text("Or add example Trips.")
                    }
                    
                }
            }
            .navigationBarTitle("Trips")
        .navigationBarItems(
            trailing: HStack {
                Button(action: {
                    showAddTrip = true
                selection = SelectionConfig(viewSelectionType: .addTrip, viewSelection: nil)
                 }) {
                    Image(systemName: "plus")
                }.padding()
                .sheet(isPresented: $showAddTrip, content: {
                    NavigationView {
                        AddTrip(selection: $selection, modal: true).environment(\.managedObjectContext, self.context)}
                })
                .alert(isPresented: $showDeleteAlert, content: {
                    Alert(title: Text("Are you sure you want to delete \(tripToDelete?.name ?? "Unknown Trip")?"),
                          message: Text("This cannot be undone."),
                          primaryButton: Alert.Button.destructive(Text("Delete"), action: {
                            if let trip = tripToDelete {
                                Trip.deleteTrip(trip: trip, context: context)
                                saveContext(context)
                                
                                selection = SelectionConfig(viewSelectionType: .trip, viewSelection: nil)
                                tripToDelete = nil
                            }
                          }), secondaryButton: Alert.Button.cancel(Text("Cancel")))
                })
            }
            )
            
            Text("No Trip Selected").font(.subheadline).onAppear(perform: {
                accent = Color.blue
            })
        }.accentColor(accent)
        .onDisappear(perform: {
            accent = Color.blue
        })

    }
}

struct TripsHome_Previews: PreviewProvider {
    static var previews: some View {
        //TripHome()
        Text("Hello!")
    }
}
