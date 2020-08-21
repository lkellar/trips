//
//  CategoryRectangular.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-01-10.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI
import CoreData

struct CategoryRectangular: View {
    var category: Category
    var color: Color
    
    var size: Int
    
    @Binding var selection: NSManagedObjectID?
    
    init(category: Category, color: Color,  width: Int, selection: Binding<NSManagedObjectID?>) {
        self.category = category
        self.color = color
        // If we have a smaller view, set the Rectangle size smaller
        size = width < 375 ? 125 : 150
        _selection = selection
    }
    
    var body: some View {
        Button(action: {
            selection = category.objectID
        }) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 30)
                    .fill(color)
                    .frame(width: CGFloat(size), height: CGFloat(size))
                    .padding()
                
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.secondary)
                    .frame(width: CGFloat(size), height: CGFloat(size / 2))
                    .padding()
                Rectangle()
                    .fill(color)
                    .frame(width: CGFloat(size), height: CGFloat(size / 5))
                    .padding()
                    .offset(y: CGFloat(-(size / 3)))
                Text(category.name).font(.title)
                    .offset(y: CGFloat(-(size / 6)))
                    .foregroundColor(Color(UIColor.systemGray5))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .allowsTightening(true)
                    .frame(width: CGFloat(Double(size) * 0.93))
            }
        }.buttonStyle(PlainButtonStyle())
    }
}

struct CategoryRectangular_Previews: PreviewProvider {
    static var previews: some View {
        Text("Now even the rectangle is too complicated for the preview")
    }
}
