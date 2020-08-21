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
    @Binding var selection: NSManagedObjectID?
    @Binding var selectionType: PrimarySelectionType
    @State var tripsExpanded: Bool = true
    @State var templatesExpanded: Bool = true
    
    @FetchRequest(fetchRequest: Trip.allTripsFetchRequest()) var trips: FetchedResults<Trip>
    
    @FetchRequest(fetchRequest: Category.allTemplatesFetchRequest()) var templates: FetchedResults<Category>
    
    var body: some View {
        List {
            DisclosureGroup(isExpanded: $tripsExpanded) {
                ForEach(sortTrips(trips)) { trip in
                    Button(action: {
                        selection = trip.objectID
                        selectionType = .trip
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
                        selection = template.objectID
                        selectionType = .template
                    }) {
                        Text(template.name)
                    }
                }
            } label: {
                Label("Templates", systemImage: "tray.full")
            }
            Spacer()
            Button(action: {
                selectionType = .addTrip
            }) {
                Label("Add Trip", systemImage: "plus")
            }
            Button(action: {
                selectionType = .addTemplate
            }) {
                Label("Add Template", systemImage: "plus")
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
