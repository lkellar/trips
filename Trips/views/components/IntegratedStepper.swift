//
//  IntegratedStepper.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-04-06.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct IntegratedStepper: View {
    @Binding var quantity: Int
    
    var upperLimit: Int
    var lowerLimit: Int
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Text("Quantity: ")
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 7.92)
                    .fill((colorScheme == .dark ? Color(UIColor(red:0.24, green:0.24, blue:0.26, alpha:1.00)) : Color(UIColor(red:0.93, green:0.93, blue:0.94, alpha:1.00))))
                    .frame(width: 120, height: 35)
                HStack {
                    Image(systemName: "minus")
                        .frame(height: 30)
                    .contentShape(Rectangle())
                        .onTapGesture {
                            if self.quantity > self.lowerLimit {
                                self.quantity -= 1
                            }
                        }
                    Spacer()
                        .frame(width: 10)
                    Text("|")
                        .foregroundColor(colorScheme == .dark ? Color(UIColor(red:0.29, green:0.29, blue:0.31, alpha:1.00)) : Color(UIColor(red:0.87, green:0.87, blue:0.88, alpha:1.00)))
                    Spacer()
                        .frame(width: 10)
                    Text("\(self.quantity)")
                    Spacer()
                        .frame(width: 10)
                    Text("|")
                    .foregroundColor(colorScheme == .dark ? Color(UIColor(red:0.29, green:0.29, blue:0.31, alpha:1.00)) : Color(UIColor(red:0.87, green:0.87, blue:0.88, alpha:1.00)))
                    Spacer()
                        .frame(width: 10)
                    Image(systemName: "plus")
                        .onTapGesture {
                            if self.quantity < self.upperLimit {
                                self.quantity += 1
                            }
                        }
                }
            }
        }
    }
}

struct IntegratedStepper_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAH")
    }
}
