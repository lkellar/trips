//
//  Trip.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-09-18.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI
import Foundation

struct Trip: Hashable {
    var name: String
    var startDate: Date
    var endDate: Date
    var color: Color
    // Icon is a String that corresponds to a SF Symbols icon
    var icon: String
    var packs: [Pack]
}

extension Date {
    var formatted_date: String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: Locale.current.languageCode!)
        return dateFormatter.string(from: self)
    }
}
