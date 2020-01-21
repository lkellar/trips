//
//  PackRectangular.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-01-10.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct PackRectangular: View {
    var title: String
    var color: Color
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 30)
                .fill(self.color)
                .frame(width: 150, height: 150)
                .padding()
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.secondary)
                .frame(width: 150, height: 75)
                .padding()
            Rectangle()
                .fill(self.color)
                .frame(width: 150, height: 30)
                .padding()
                .offset(y: -50)
            Text(title).font(.title)
                .offset(y: -25)
                .foregroundColor(Color(UIColor.systemGray5))
                .lineLimit(1)
                .truncationMode(.tail)
                .allowsTightening(true)
                .frame(width: 140)
        }
    }
}

struct PackRectangular_Previews: PreviewProvider {
    static var previews: some View {
        PackRectangular(title: "Test 123", color: .red)
    }
}
