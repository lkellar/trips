//
//  Util.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-10-04.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import Foundation
import SwiftUI

extension Date {
    var formatted_date: String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: Locale.current.languageCode!)
        return dateFormatter.string(from: self)
    }
}

extension Color {
    // So basically, as far as I can tell, there's no way to create a Color from a string, and it's hard to store a Color in core data, and I plan to use only named colors, so this will allow me to store strings and convert to color.
    static func fromString(color: String) -> Color {
        switch color {
        case "black":
            return Color.black
        case "blue":
            return Color.blue
        case "clear":
            return Color.clear
        case "gray":
            return Color.gray
        case "green":
            return Color.green
        case "orange":
            return Color.orange
        case "pink":
            return Color.pink
        case "primary":
            return Color.primary
        case "purple":
            return Color.purple
        case "red":
            return Color.red
        case "secondary":
            return Color.secondary
        case "white":
            return Color.white
        case "yellow":
            return Color.yellow
        default:
            // Don't want to raise an error, so returning primary color seems like best option
            return Color.primary
        }
    }
}
