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
                .stroke(self.determineColor(), lineWidth: 3)
                .opacity(self.colorScheme == .dark && self.icon != self.selectedColor ? 0 : 1)
                .frame(width: self.iconSize*2, height: self.iconSize*2)
            Button(action: {
                self.selectedColor = self.icon
            }) {
                Image(systemName: self.icon).font(.system(size:self.iconSize)).foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
    
    func determineColor() -> Color {
        if (self.colorScheme == .dark) {
            return self.icon == self.selectedColor ? Color.white : Color.black
        }
        return self.icon == self.selectedColor ? Color.black : Color.white
    }
}

struct IconPickerCircle_Previews: PreviewProvider {
    static var previews: some View {
        Text("No")
    }
}
