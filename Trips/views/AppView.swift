//
//  AppView.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-01-02.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import CoreData
import SwiftUI

struct AppView: View {
    @Environment(\.managedObjectContext) var context
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    @State var selection: SelectionConfig = SelectionConfig(viewSelectionType: .trip, viewSelection: nil, secondaryViewSelectionType: nil, secondaryViewSelection: nil)
    
    @State var accentColor: Color = Color.blue
    
    @ViewBuilder var body: some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            TabController(selection: $selection, accent: $accentColor)
        } else {
            SidebarController(accent: $accentColor, selection: $selection)
        }
        #else
        SidebarController(accent: $accentColor, selection: $selection)
        #endif
        
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        NoPreview()
    }
}
