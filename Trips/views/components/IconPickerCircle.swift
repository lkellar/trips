//
//  IconPickerCircle.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-06-14.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct IconPickerCircle: View {
    var icon: String
    @Binding var selectedColor: String
    
    var iconSize: CGFloat
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(determineColor(), lineWidth: 3)
                .opacity(colorScheme == .dark && icon != selectedColor ? 0 : 1)
                .frame(width: iconSize*2, height: iconSize*2)
            Button(action: {
                selectedColor = icon
            }) {
                Image(systemName: icon).font(.system(size:iconSize)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
    
    func determineColor() -> Color {
        if (colorScheme == .dark) {
            return icon == selectedColor ? Color.white : Color.black
        }
        return icon == selectedColor ? Color.black : Color.white
    }
}

struct IconPickerCircle_Previews: PreviewProvider {
    static var previews: some View {
        Text("No")
    }
}
