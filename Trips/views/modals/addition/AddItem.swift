//
//  AddItem.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-10-08.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct AddItem: View {
    var categories: [Category]
    var selectCategory = true
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Environment(\.managedObjectContext) var context
        
    @State var title: String = ""
    @State var selectedCategory: Int = 0
    
    @State var quantity: Int = 1
    
    @State var showTextField: Bool = true
    @Binding var refreshing: Bool
    var accent: Color
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    if showTextField {
                        TextField("Item Name", text: $title)
                            .id("primary")
                            .animation(Animation.default)
                            .transition(.move(edge: .bottom))
                    } else {
                        TextField("Item Name", text: $title)
                            .id("secondary")
                            .animation(Animation.default)
                            .transition(.move(edge: .bottom))
                    }
                    
                    IntegratedStepper(quantity: self.$quantity, upperLimit: 20, lowerLimit: 1)
                    
                }
                if selectCategory {
                    Section {
                        Picker(selection: $selectedCategory, label: Text("Category"),
                               content: {
                                if categories.count > 0 {
                                    ForEach(0 ..< categories.count, id:\.self) { index in
                                        Text(self.categories[index].name).tag(index)
                                    }
                                } else {
                                    Text("No Categories for this Trip. Please create a category before adding an Item.")
                                }
                        })
                    }
                }
                Section {
                    Button(action: {
                        let localTitle = self.title
                        self.title = ""
                        for _ in 1...self.quantity {
                            self.saveItem(title: localTitle)
                        }
                        
                        withAnimation {
                            self.showTextField.toggle()
                        }
                        self.quantity = 1
                    }) {
                        Text("Add Another")
                    }.disabled(checkForSave() ? false : true)
                }
                Section(footer: Text(selectCategory && categories.count == 0 ? "No Categories in Trip. Please create a Category before adding an Item." : "")) {
                    Button(action: {
                        for _ in 1...self.quantity {
                            self.saveItem(title: self.title)
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save!")
                    }.disabled(checkForSave() ? false : true)
                }
            }.navigationBarTitle("Add Item")
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                }))
        }.accentColor(self.accent)
            .onDisappear(perform: {
            self.refreshing.toggle()
        }).navigationViewStyle(StackNavigationViewStyle())
    }
    
    func checkForSave() -> Bool {
        if self.title.count == 0 {
            return false
        }
        if selectCategory && categories.count == 0 {
            return false
        }
        return true
    }
    
    func saveItem(title: String) {
        do {
            let category = self.categories[self.selectedCategory]
            let item = Item(context: self.context)
            
            item.name = title
            item.index = try Item.generateItemIndex(category: category, context: self.context)
            category.addToItems(item)
            
            try self.context.save()
        } catch {
            print(error)
        }
    }
}

struct AddItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("Rhis is rocky")
    }
}
