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
    @Binding var primarySelectionType: PrimarySelectionType
    @Binding var primaryViewSelection: NSManagedObjectID?
    @State var refreshing: Bool = false

    var body: some View {
        NavigationView {
            Sidebar(selection: $primaryViewSelection, selectionType: $primarySelectionType)
            switch primarySelectionType {
            case .trip:
                if let trip = fetchEntityByExisting(id: primaryViewSelection, entityType: Trip.self) {
                    TripDetail(trip: trip, accent: $accent, primaryViewSelection: $primaryViewSelection).accentColor(Color.fromString(color: trip.color ?? "blue"))
                } else {
                    Text("No Trip Selected")
                }
            case .template:
                if let template = fetchEntityByExisting(id: primaryViewSelection, entityType: Category.self) {
                    TemplateDetail(template: template, refreshing: $refreshing, selection: $primaryViewSelection)
                } else {
                    Text ("No Template Selected")
                }
            case .addTrip:
                AddTrip(selectionType: $primarySelectionType, viewSelection: $primaryViewSelection)
            case .addTemplate:
                AddTemplate(selectionType: $primarySelectionType, viewSelection: $primaryViewSelection)
            }
        }
            
    }
    
    func fetchEntityByExisting<T: NSManagedObject>(id: NSManagedObjectID?, entityType: T.Type) -> T? {
        if let id = id {
            do {
                // We can force unwrap the selection, as there is a check in the parent to only use this view if selection is valid
                logger.info("Looking up existing entity by ID. ID is \(id, privacy: .private(mask: .hash))")
                let trip = try context.existingObject(with: id) as! T
                logger.info("Successfully found entity with ID:  \(id, privacy: .private(mask: .hash))")
                return trip
            } catch {
                logger.error("Looking up entity with ID: \(id, privacy: .private(mask: .hash)) failed. Error: \(error.localizedDescription, privacy: .public)")
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
