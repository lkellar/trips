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

let logger = Logger(subsystem: "org.kellar.trips", category: "SidebarController")

struct SidebarController: View {
    @Environment(\.managedObjectContext) var context

    @Binding var accent: Color
    @Binding var viewSelection: NSManagedObjectID?
    @Binding var selectionType: SelectionType
    @State var refreshing: Bool = false

    var body: some View {
        NavigationView {
            Sidebar(selection: $viewSelection, selectionType: $selectionType)
            switch selectionType {
            case .trip:
                if let trip = fetchTripByExisting() {
                    TripDetail(trip: trip, accent: $accent, selection: $viewSelection).accentColor(Color.fromString(color: trip.color ?? "blue"))
                } else {
                    Text("No Trip Selected")
                }
            case .template:
                if let template = fetchTemplateByExisting() {
                    TemplateDetail(template: template, refreshing: $refreshing, selection: $viewSelection)
                } else {
                    Text ("No Template Selected")
                }
            case .addTrip:
                AddTrip(selectionType: $selectionType, viewSelection: $viewSelection)
            case .addTemplate:
                AddTemplate(selectionType: $selectionType, viewSelection: $viewSelection)
            }
        }
    }
    
    func fetchTripByExisting() -> Trip? {
        if let id = viewSelection {
            do {
                // We can force unwrap the selection, as there is a check in the parent to only use this view if selection is valid
                logger.info("Looking up existing Trip by ID. ID is \(id, privacy: .private(mask: .hash))")
                let trip = try context.existingObject(with: id) as! Trip
                logger.info("Successfully found Trip with ID:  \(id, privacy: .private(mask: .hash))")
                return trip
            } catch {
                logger.error("Looking up Trip with ID: \(id, privacy: .private(mask: .hash)) failed. Error: \(error.localizedDescription, privacy: .public)")
                return nil
            }
        } else {
            return nil
        }
    }
    
    func fetchTemplateByExisting() -> Category? {
        if let id = viewSelection {
            do {
                // We can force unwrap the selection, as there is a check in the parent to only use this view if selection is valid
                logger.info("Looking up existing Category by ID. ID is \(id, privacy: .private(mask: .hash))")
                let template = try context.existingObject(with: id) as! Category
                logger.info("Successfully found Category with ID:  \(id, privacy: .private(mask: .hash))")
                return template
            } catch {
                logger.error("Looking up Category with ID: \(id, privacy: .private(mask: .hash)) failed. Error: \(error.localizedDescription, privacy: .public)")
                return nil
            }
        } else {
            return nil
        }
    }
}

struct SidebarController_Previews: PreviewProvider {
    static var previews: some View {
        NoPreview()
    }
}
