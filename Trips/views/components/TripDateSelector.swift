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
        Section(footer: Text(!(!self.validDates && self.isEndDate) ? "" : "These dates are invalid and cannot be saved")) {
            if !self.showDate {
                Button(action: {
                    self.showDate = true
                }) {
                    Text("Add \(self.isEndDate ? "End" : "Start" ) Date")
                }
            } else {
                DatePicker(selection: $date, displayedComponents: .date, label: { Text("\(self.isEndDate ? "End" : "Start") Date")
                }).foregroundColor(self.validDates ? .primary : .red)
                Button(action: {
                    self.showDate = false
                }) {
                    Text("Reset \(self.isEndDate ? "End" : "Start" ) Date")
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
