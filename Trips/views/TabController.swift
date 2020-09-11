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
    @State var selectedTab: Int
    
    init(selection: Binding<SelectionConfig>, accent: Binding<Color>) {
        _selection = selection
        _accent = accent
        self._selectedTab = State.init(initialValue: selection.wrappedValue.primaryViewSelection == .template ? 1 : 0)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TripHome(selection: $selection, accent: $accent)
                .environment(\.managedObjectContext, context)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Trips")
                }.tag(0)
            TemplateHome(selection: $selection)
                .environment(\.managedObjectContext, context)
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Templates")
                }.tag(1)
        }.accentColor(accent)
    }
}

struct TabController_Previews: PreviewProvider {
    static var previews: some View {
        NoPreview()
    }
}
