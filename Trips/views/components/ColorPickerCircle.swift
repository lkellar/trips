//
//  ColorPickerCircle.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-12-17.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct ColorPickerCircle: View {
    var circleSize: CGFloat
    var color: Color
    @Binding var updatedColor: Color
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Button(action: {
                self.updatedColor = self.color
            }) {
                Circle().frame(width: self.circleSize, height: self.circleSize).foregroundColor(self.color)
            }.buttonStyle(BorderlessButtonStyle())
            if updatedColor == self.color {
                Image(systemName: "checkmark").foregroundColor(colorScheme == .dark && self.color == Color.primary ? .black : .white).font(.system(size: circleSize/3))
            }
        }
    }
}

struct ColorPickerCircle_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAAh")
    }
}
