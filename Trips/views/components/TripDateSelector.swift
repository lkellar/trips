//
//  TripDateSelector.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-12-22.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct TripDateSelector: View {
    @Binding var date: Date
    @Binding var showDate: Bool
    
    var validDates: Bool
    
    var isEndDate: Bool
    
    var body: some View {
        Section(footer: Text(!(!validDates && isEndDate) ? "" : "These dates are invalid and cannot be saved")) {
            if !showDate {
                Button(action: {
                    showDate = true
                }) {
                    Text("Add \(isEndDate ? "End" : "Start" ) Date")
                }
            } else {
                DatePicker(selection: $date, displayedComponents: .date, label: { Text("\(isEndDate ? "End" : "Start") Date")
                }).foregroundColor(validDates ? .primary : .red)
                Button(action: {
                    showDate = false
                }) {
                    Text("Reset \(isEndDate ? "End" : "Start" ) Date")
                }
            }
        }
    }
    
    
}

struct TripDateSelector_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAH")
    }
}
