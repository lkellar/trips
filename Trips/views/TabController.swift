//
//  TabController.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-06-27.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import CoreData
import SwiftUI

struct TabController: View {
    @Environment(\.managedObjectContext) var context
    
    @Binding var primarySelectionType: PrimarySelectionType
    @Binding var primaryViewSelection: NSManagedObjectID?
    
    @Binding var accent: Color
    var body: some View {
        TabView {
            TripHome(primarySelectionType: $primarySelectionType, primaryViewSelection: $primaryViewSelection, accent: $accent)
                .environment(\.managedObjectContext, context)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Trips")
                }
            TemplateHome(selectionType: $primarySelectionType, viewSelection: $primaryViewSelection)
                .environment(\.managedObjectContext, context)
                .tabItem {
                    Image(systemName: "tray.full.fill")
                    Text("Templates")
                 }
        }.accentColor(accent)
    }
}

struct TabController_Previews: PreviewProvider {
    static var previews: some View {
        NoPreview()
    }
}
