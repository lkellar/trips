//
//  Sidebar.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-06-27.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import CoreData
import SwiftUI

struct Sidebar: View {
    @Environment(\.managedObjectContext) var context

    @Binding var selection: SelectionConfig
    @State var tripsExpanded: Bool = true
    @State var templatesExpanded: Bool = true
    @State var addTripExpanded: Bool = false
    @State var addTemplateExpanded: Bool = false
    
    @FetchRequest(fetchRequest: Trip.allTripsFetchRequest()) var trips: FetchedResults<Trip>
    
    @FetchRequest(fetchRequest: Category.allTemplatesFetchRequest()) var templates: FetchedResults<Category>
    
    var templateCount: Int {
        get {
            return templates.count
        }
    }
    
    var tripCount: Int {
        get {
            return trips.count
        }
    }
    
    var body: some View {
        List {
            DisclosureGroup(isExpanded: $tripsExpanded) {
                ForEach(sortTrips(trips)) { trip in
                    Button(action: {
                        selection = SelectionConfig(primaryViewSelection: .trip, viewSelection: trip.objectID)
                    }) {
                        Label(trip.name, systemImage: trip.icon?.replacingOccurrences(of: ".fill", with: "") ?? "house").accentColor(Color.fromString(color: trip.color ?? "default"))
                    } 
                }
            } label: {
                Label("Trips", systemImage: "house")
            }
            DisclosureGroup(isExpanded: $templatesExpanded) {
                ForEach(templates) { template in
                    Button(action: {
                        selection = SelectionConfig(primaryViewSelection: .template, viewSelection: template.objectID)
                    }) {
                        Text(template.name)
                    }
                }
            } label: {
                Label("Templates", systemImage: "square.grid.2x2")
            }
            Spacer()
            DisclosureGroup(isExpanded: $addTripExpanded) {
                Button(action: {
                    SampleDataFactory(context: context).addSampleTrips()
                }) {
                    Label("Add Example Trips", systemImage: "plus.rectangle.on.rectangle")
                }
            } label: {
                Button(action: {
                    selection = SelectionConfig(primaryViewSelection: .addTrip, viewSelection: nil)
                }) {
                    Label("Add Trip", systemImage: "plus")
                }
            }
            .onChange(of: tripCount) { newTripCount in
                if (newTripCount == 0) {
                    addTripExpanded = true
                } else {
                    addTripExpanded = false
                }
            }
            DisclosureGroup(isExpanded: $addTemplateExpanded) {
                Button(action: {
                    SampleDataFactory(context: context).addSampleTemplates()
                }) {
                    Label("Add Example Templates", systemImage: "plus.rectangle.on.rectangle")
                }
            } label: {
                Button(action: {
                    selection = SelectionConfig(primaryViewSelection: .addTemplate, viewSelection: nil)
                }) {
                    Label("Add Template", systemImage: "plus")
                }
            }
            .onChange(of: templateCount) { newTemplateCount in
                if (newTemplateCount == 0) {
                    addTemplateExpanded = true
                } else {
                    addTemplateExpanded = false
                }
            }
        }.onAppear {
            if (tripCount == 0) {
                addTripExpanded = true
            } else {
                addTripExpanded = false
            }

            if (templateCount == 0) {
                addTemplateExpanded = true
            } else {
                addTemplateExpanded = false
            }
        }
        .listStyle(SidebarListStyle())
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        NoPreview()
    }
}
