//
//  TripDateSelector.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-12-22.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct TripDateSelector: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    @Binding var showStartDate: Bool
    @Binding var showEndDate: Bool
    
    var validDates: Bool
    
    var body: some View {
        Section(footer: Text(self.validDates ? "" : "These dates are invalid and cannot be saved")) {
            if !self.showStartDate {
                Button(action: {
                    self.showStartDate = true
                }) {
                    Text("Add Start Date")
                }
            } else {
                DatePicker(selection: $startDate, displayedComponents: .date, label: { Text("Start Date")
                }).foregroundColor(self.validDates ? .primary : .red)
            }
            
            if !self.showEndDate {
                Button(action: {
                    self.showEndDate = true
                }) {
                    Text("Add End Date")
                }
            } else {
                DatePicker(selection: $endDate, displayedComponents: .date, label: { Text("End Date")
                }).foregroundColor(self.validDates ? .primary : .red)
            }
        }
    }
    
    
}

struct TripDateSelector_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAH")
    }
}
