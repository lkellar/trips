//
//  IconPicker.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-06-14.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

let icons = ["house.fill", "airplane", "briefcase.fill", "map.fill", "gamecontroller.fill", "gift.fill", "studentdesk", "cart.fill", "car.fill", "person.2.fill", "tram.fill", "bicycle", "bag.fill", "cross.fill", "desktopcomputer", "book.fill", "ticket.fill", "graduationcap.fill", "bed.double.fill"]

struct IconPicker: View {
    @Binding var selectedIcon: String

    var iconSize: CGFloat
    var gridItemLayout: [GridItem]
    
    init(selectedIcon: Binding<String>) {
        iconSize = 32
        _selectedIcon = selectedIcon
        gridItemLayout = [GridItem(.adaptive(minimum: iconSize * 2))]
    }

    var body: some View {
        LazyVGrid(columns: gridItemLayout) {
            ForEach(icons, id: \.self) {icon in
                IconPickerCircle(icon: icon, selectedColor: $selectedIcon, iconSize: iconSize)
                
            }
        }
    }
}


struct IconPicker_Previews: PreviewProvider {
    static var previews: some View {
        Text("Not even going to try here")
    }
}
