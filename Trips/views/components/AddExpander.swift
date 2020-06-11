//
//  AddExpander.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-04-19.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct AddExpander: View {
    @Environment(\.colorScheme) var colorScheme
    var color: Color
    var addCategory: Bool
    @State var width: CGFloat = 64
    @State var height: CGFloat = 64
    @State var radius: CGFloat = 90
    @State var expand: Bool = false
    @State var showExpandedText: Bool = false

    
    @Binding var showAddItem: Bool
    @Binding var showAddCategory: Bool
    
    init(color: Color, showAddItem: Binding<Bool>, showAddCategory: Binding<Bool>) {
        self.color = color
        self.addCategory = true
        self._showAddItem = showAddItem
        self._showAddCategory = showAddCategory
    }
    
    init(color: Color, showAddItem: Binding<Bool>) {
        self.color = color
        self._showAddItem = showAddItem
        self._showAddCategory = Binding.constant(false)
        self.addCategory = false
        
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: self.radius)
            .frame(width: self.width, height: self.height)
            .foregroundColor(self.color).overlay(
                VStack {
                    if self.showExpandedText {
                        Button(action: {
                            self.showAddItem = true
                            self.unExpand()
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Item")
                                Spacer()
                            }
                            .padding(.leading, 15)
                        }
                        Button(action: {
                            self.showAddCategory = true
                            self.unExpand()
                        }) {
                            HStack {
                                Image(systemName: "plus.square.fill.on.square.fill")
                                Text("Add Category")
                                Spacer()
                            }
                            .padding(.leading, 15)
                        }
                        Button(action: {
                            self.unExpand()
                        }) {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                Text("Cancel")
                                Spacer()
                            }
                            .padding(.leading, 15)
                        }
                    } else {
                        Button(action: {
                            if self.addCategory {
                                self.expand.toggle()
                                withAnimation() {
                                    self.width = 210
                                    self.height = 150
                                    self.radius = 15
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.225) {
                                    self.showExpandedText.toggle()
                                }
                            } else {
                                self.showAddItem = true
                            }
                        }) {
                        Image(systemName: "plus")
                            .font(.system(size: 40))
                        }
                    }
                }
                .foregroundColor(colorScheme == .dark && self.color == Color.primary ? Color.black : Color.white)
                .font(.system(size: 23))
        )
    }
    
    func unExpand() {
        self.expand = false
        self.showExpandedText = false
        withAnimation() {
            self.width = 64
            self.height = 64
            self.radius = 90
        }
    }
}

struct AddExpander_Previews: PreviewProvider {
    static var previews: some View {
        Text("Same thing about my computer not doing previews, etc etc.")
    }
}
