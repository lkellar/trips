//
//  AppView.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-01-02.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct AppView: View {
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        TabView {
            TripHome()
                .environment(\.managedObjectContext, context)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Trips")
                }
            TemplateHome()
                .environment(\.managedObjectContext, context)
                .tabItem {
                    Image(systemName: "tray.full.fill")
                    Text("Templates")
                 }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        Text("My Macintosh Can't do PReviews very well")
    }
}
