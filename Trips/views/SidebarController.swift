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
            switch selection.primaryViewSelection {
            case .trip:
                if let trip = fetchEntityByExisting(id: selection.viewSelection, entityType: Trip.self) {
                    TripDetail(trip: trip, selection: $selection)
                } else {
                    Text("No Trip Selected")
                }
            case .template:
                if let template = fetchEntityByExisting(id: selection.viewSelection, entityType: Category.self) {
                    TemplateDetail(template: template, refreshing: $refreshing, selection: $selection)
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
    
    func fetchEntityByExisting<T: NSManagedObject>(id: NSManagedObjectID?, entityType: T.Type) -> T? {
        if let id = id {
            do {
                // We can force unwrap the selection, as there is a check in the parent to only use this view if selection is valid
                logger.info("Looking up existing entity by ID. ID is \(id, privacy: .private(mask: .hash))")
                let entity = try context.existingObject(with: id) as? T
                if let unwrappedEntity = entity {
                    logger.info("Successfully found entity with ID:  \(id, privacy: .private(mask: .hash))")
                    return unwrappedEntity
                }
                logger.info("Couldn't found entity with ID for Given Type:  \(id, privacy: .private(mask: .hash))")

                return nil
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
