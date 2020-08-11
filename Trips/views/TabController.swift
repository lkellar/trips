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
    
    @Binding var selectionType: SelectionType
    @Binding var viewSelection: NSManagedObjectID?
    @Binding var accent: Color
    var body: some View {
        TabView {
            TripHome(selectionType: $selectionType, viewSelection: $viewSelection, accent: $accent)
                .environment(\.managedObjectContext, context)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Trips")
                }
            TemplateHome(selectionType: $selectionType, viewSelection: $viewSelection)
                .environment(\.managedObjectContext, context)
                .tabItem {
                    Image(systemName: "tray.full.fill")
                    Text("Templates")
                 }
        }.accentColor(self.accent)
    }
}

struct TabController_Previews: PreviewProvider {
    static var previews: some View {
        NoPreview()
    }
}
