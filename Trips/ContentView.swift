//
//  ContentView.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-09-17.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TripHome(trips: exampleTrips)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
