//
//  Sidebar.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-06-27.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI
import CoreData
import os.log

let logger = Logger(subsystem: "org.kellar.trips", category: "Trips")

struct SidebarController: View {
    @Environment(\.managedObjectContext) var context

    @Binding var accent: Color
    @Binding var selection: SelectionConfig
    @State var refreshing: Bool = false

    var body: some View {
        NavigationView {
            Sidebar(selection: $selection)
            switch selection.viewSelectionType {
            case .trip:
                if let trip = fetchEntityByExisting(id: selection.viewSelection, entityType: Trip.self, context: context) {
                    iPadDetailController {
                        TripDetail(trip: trip, selection: $selection, globalAccent: $accent)
                    } right: {
                        switch selection.secondaryViewSelectionType {
                        case .addItem:
                            AddItem(categories: trip.categories.allObjects as! [Category], selectCategory: true, refreshing: $refreshing, accent: accent, selection: $selection)
                        case .addCategory:
                            AddCategory(trip: trip, refreshing: $refreshing, accent: accent, selection: $selection)
                        case .addTemplate:
                            AddTemplateToExisting(trip: trip, refreshing: $refreshing, accent: accent, selection: $selection)
                        case .editItem:
                            EditItem(selection: $selection, accent: $accent)
                        case .editTrip:
                            EditTrip(trip: trip, refreshing: $refreshing, globalAccent: $accent, selection: $selection)
                        default:
                            EmptyView()
                        }
                    }
                } else {
                    Text("No Trip Selected")
                }
            case .template:
                if let template = fetchEntityByExisting(id: selection.viewSelection, entityType: Category.self, context: context) {
                    iPadDetailController {
                        TemplateDetail(template: template, refreshing: $refreshing, selection: $selection, accent: $accent)
                    } right: {
                        switch selection.secondaryViewSelectionType {
                        case .editTemplate:
                            EditTemplate(template: template, refreshing: $refreshing, selection: $selection)
                        case .editItem:
                            EditItem(selection: $selection, accent: $accent)
                        case .addItem:
                            AddItem(categories: [template], selectCategory: false, refreshing: $refreshing, accent: accent, selection: $selection)
                        default:
                            EmptyView()
                        }
                    }
                } else {
                    Text ("No Template Selected")
                }
            case .addTrip:
                AddTrip(selection: $selection, modal: false)
            case .addTemplate:
                AddTemplate(selection: $selection, modal: false)
            }
        }
            
    }
    
    
}

struct SidebarController_Previews: PreviewProvider {
    static var previews: some View {
        NoPreview()
    }
}
