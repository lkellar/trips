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
    
    @State var showTextField: Bool = true
    
    var body: some View {
        NavigationView {
            Form {
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
                Section {
                    if selectCategory {
                        Picker(selection: $selectedCategory, label: Text("Category"),
                               content: {
                                ForEach(0 ..< categories.count, id:\.self) { index in
                                    Text(self.categories[index].name).tag(index)
                                }
                        })
                    }
                }
                Section {
                    Button(action: {
                        let localTitle = self.title
                        self.title = ""
                        self.saveItem(title: localTitle)
                        
                        withAnimation {
                            self.showTextField.toggle()
                        }
                    }) {
                        Text("Add Another")
                    }.disabled(self.title.count == 0 ? true : false)
                }
                Section {
                    Button(action: {
                        self.saveItem(title: self.title)
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save!")
                    }.disabled(self.title.count == 0 ? true : false)
                }
            }.navigationBarTitle("Add Item")
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                }))
        }
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
