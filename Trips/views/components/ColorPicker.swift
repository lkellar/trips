//
//  ColorPicker.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-12-17.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct ColorPicker: View {
    @Binding var updatedColor: String
    
    var circleSize: CGFloat = CGFloat(64)
    
    var body: some View {
        HStack {
            VStack {
                ColorPickerCircle(circleSize: self.circleSize, color: "blue", updatedColor: self.$updatedColor)
                ColorPickerCircle(circleSize: self.circleSize, color: "green", updatedColor: self.$updatedColor)
            }
            VStack {
                ColorPickerCircle(circleSize: self.circleSize, color: "red", updatedColor: self.$updatedColor)
                ColorPickerCircle(circleSize: self.circleSize, color: "orange", updatedColor: self.$updatedColor)
            }
            VStack {
                ColorPickerCircle(circleSize: self.circleSize, color: "pink", updatedColor: self.$updatedColor)
                ColorPickerCircle(circleSize: self.circleSize, color: "purple", updatedColor: self.$updatedColor)
            }
            VStack {
                ColorPickerCircle(circleSize: self.circleSize, color: "black", updatedColor: self.$updatedColor)
                ColorPickerCircle(circleSize: self.circleSize, color: "yellow", updatedColor: self.$updatedColor)
            }
        }
    }
}

struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAh")
    }
}
