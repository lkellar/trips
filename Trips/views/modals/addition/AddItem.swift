//
//  AddItem.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-10-08.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct AddItem: View {
    var packs: [Pack]
    var selectPack = true
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Environment(\.managedObjectContext) var context
        
    @State var title: String = ""
    @State var selectedPack: Int = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Item Name", text: $title)
                    if (selectPack) {
                        Picker(selection: $selectedPack, label: Text("Pack"),
                               content: {
                                ForEach(0 ..< packs.count, id:\.self) { index in
                                    Text(self.packs[index].name).tag(index)
                                }
                        })
                    }
                }
                Button(action: {
                    do {
                        let pack = self.packs[self.selectedPack]
                        let item = Item(context: self.context)
                        
                        item.name = self.title
                        pack.addToItems(item)
                        
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
