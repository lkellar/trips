//
//  ColorPicker.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-12-17.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct ColorPicker: View {
    @Binding var updatedColor: Color
    
    var circleSize: CGFloat = CGFloat(64)
    
    var body: some View {
        HStack {
            VStack {
                ColorPickerCircle(circleSize: circleSize, color: .blue, updatedColor: $updatedColor)
                ColorPickerCircle(circleSize: circleSize, color: .green, updatedColor: $updatedColor)
            }
            VStack {
                ColorPickerCircle(circleSize: circleSize, color: .red, updatedColor: $updatedColor)
                ColorPickerCircle(circleSize: circleSize, color: .orange, updatedColor: $updatedColor)
            }
            VStack {
                ColorPickerCircle(circleSize: circleSize, color: .pink, updatedColor: $updatedColor)
                ColorPickerCircle(circleSize: circleSize, color: .purple, updatedColor: $updatedColor)
            }
            VStack {
                ColorPickerCircle(circleSize: circleSize, color: .primary, updatedColor: $updatedColor)
                ColorPickerCircle(circleSize: circleSize, color: .yellow, updatedColor: $updatedColor)
            }
        }
    }
}

struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAh")
    }
}
