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
    
    @Binding var selection: SelectionConfig
    @Binding var accent: Color
    
    var body: some View {
        TabView(selection: $selection.viewSelectionType) {
            TripHome(selection: $selection, accent: $accent)
                .environment(\.managedObjectContext, context)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Trips")
                }.tag(PrimarySelectionType.trip)
            TemplateHome(selection: $selection)
                .environment(\.managedObjectContext, context)
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Templates")
                }.tag(PrimarySelectionType.template)
        }.accentColor(accent)
    }
}

struct TabController_Previews: PreviewProvider {
    static var previews: some View {
        NoPreview()
    }
}
