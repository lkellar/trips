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
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Item Name", text: $title)
                    if (selectCategory) {
                        Picker(selection: $selectedCategory, label: Text("Category"),
                               content: {
                                ForEach(0 ..< categories.count, id:\.self) { index in
                                    Text(self.categories[index].name).tag(index)
                                }
                        })
                    }
                }
                Button(action: {
                    do {
                        let category = self.categories[self.selectedCategory]
                        let item = Item(context: self.context)
                        
                        item.name = self.title
                        item.index = try Item.generateItemIndex(category: category, context: self.context)
                        category.addToItems(item)
                        
                        try self.context.save()
                    } catch {
                        print(error)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save!")
                }.disabled(self.title.count == 0 ? true : false)
            }.navigationBarTitle("Add Item")
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                }))
        }
    }
}

struct AddItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("Rhis is rocky")
    }
}
