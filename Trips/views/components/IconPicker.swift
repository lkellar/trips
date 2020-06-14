//
//  IconPicker.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-06-14.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct IconPicker: View {
    @Binding var selectedIcon: String

    var iconSize: CGFloat = CGFloat(32)

    var body: some View {
        VStack {
            HStack {
                IconPickerCircle(icon: "house.fill", selectedColor: self.$selectedIcon, iconSize: self.iconSize)
                IconPickerCircle(icon: "airplane", selectedColor: self.$selectedIcon, iconSize: self.iconSize)
                IconPickerCircle(icon: "briefcase.fill", selectedColor: self.$selectedIcon, iconSize: self.iconSize)
                IconPickerCircle(icon: "map.fill", selectedColor: self.$selectedIcon, iconSize: self.iconSize)
                IconPickerCircle(icon: "gamecontroller.fill", selectedColor: self.$selectedIcon, iconSize: self.iconSize)
            }
            HStack {
            
            IconPickerCircle(icon: "gift.fill", selectedColor: self.$selectedIcon, iconSize: self.iconSize)
            IconPickerCircle(icon: "studentdesk", selectedColor: self.$selectedIcon, iconSize: self.iconSize)
            IconPickerCircle(icon: "cart.fill", selectedColor: self.$selectedIcon, iconSize: self.iconSize)
            IconPickerCircle(icon: "car.fill", selectedColor: self.$selectedIcon, iconSize: self.iconSize)
            IconPickerCircle(icon: "person.2.fill", selectedColor: self.$selectedIcon, iconSize: self.iconSize)
            }
        }
    }
}


struct IconPicker_Previews: PreviewProvider {
    static var previews: some View {
        Text("Not even going to try here")
    }
}
