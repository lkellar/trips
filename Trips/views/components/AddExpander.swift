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
    @Binding var showAddTemplate: Bool
    
    init(color: Color, showAddItem: Binding<Bool>, showAddCategory: Binding<Bool>, showAddTemplate: Binding<Bool>) {
        self.color = color
        addCategory = true
        _showAddItem = showAddItem
        _showAddCategory = showAddCategory
        _showAddTemplate = showAddTemplate
    }
    
    init(color: Color, showAddItem: Binding<Bool>) {
        self.color = color
        _showAddItem = showAddItem
        _showAddCategory = Binding.constant(false)
        _showAddTemplate = Binding.constant(false)
        addCategory = false
        
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .frame(width: width, height: height)
            .foregroundColor(color).overlay(
                VStack {
                    if showExpandedText {
                        VStack {
                            Button(action: {
                                showAddItem.toggle()
                                unExpand()
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Add Item")
                                    Spacer()
                                }
                                .padding(.leading, 15)
                            }
                            Spacer()
                            Button(action: {
                                showAddCategory.toggle()
                                unExpand()
                            }) {
                                HStack {
                                    Image(systemName: "plus.square.fill.on.square.fill")
                                    Text("Add Category")
                                    Spacer()
                                }
                                .padding(.leading, 15)
                            }
                            Spacer()
                            Button(action: {
                                showAddTemplate.toggle()
                                unExpand()
                            }) {
                                HStack {
                                    Image(systemName: "plus.square.fill.on.square.fill")
                                    Text("Add Template")
                                    Spacer()
                                }
                                .padding(.leading, 15)
                            }
                            Spacer()
                            Button(action: {
                                unExpand()
                            }) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                    Text("Cancel")
                                    Spacer()
                                }
                                .padding(.leading, 15)
                            }
                        }.padding(.vertical, 20)
                    } else {
                        Button(action: {
                            if addCategory {
                                expand.toggle()
                                withAnimation() {
                                    width = 210
                                    height = 200
                                    radius = 15
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.225) {
                                    showExpandedText = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    if !expand {
                                        unExpand();
                                    }
                                }
                            } else {
                                showAddItem.toggle()
                            }
                        }) {
                        Image(systemName: "plus")
                            .font(.system(size: 40))
                        }
                    }
                }
                .foregroundColor(colorScheme == .dark && color == Color.primary ? Color.black : Color.white)
                .font(.system(size: 23))
        )
    }
    
    func unExpand() {
        expand = false
        showExpandedText = false
        withAnimation() {
            width = 64
            height = 64
            radius = 90
        }
    }
}

struct AddExpander_Previews: PreviewProvider {
    static var previews: some View {
        Text("Same thing about my computer not doing previews, etc etc.")
    }
}
