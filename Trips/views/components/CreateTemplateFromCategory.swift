//
//  CreateTemplateFromPack.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-05-09.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct CreateTemplateFromCategory: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var category: Category
    
    @State var updatedName: String = ""
    @State var excluded: [Item] = []
    
    var itemRequest : FetchRequest<Item>
    var items: FetchedResults<Item>{itemRequest.wrappedValue}
    
    init(category: Category) {
        self.itemRequest = FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate:
        NSPredicate(format: "%K == %@", #keyPath(Item.category), category))
        
        self.category = category
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Template Name", text: $updatedName).onAppear {
                        self.updatedName = self.category.name
                    }
                }
                Section {
                    ForEach(self.items, id:\.self) { item in
                        Button(action: {
                            guard let index = self.excluded.firstIndex(of: item) else {
                                self.excluded.append(item)
                                return
                            }
                            self.excluded.remove(at: index)
                            
                        }) {
                            HStack {
                                Text(item.name)
                                    .foregroundColor(.primary)
                                Spacer()
                                if !self.excluded.contains(item) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                Section {
                    Button(action: {
                        let pendingTemplate = Category(context: self.context)
                        
                        pendingTemplate.name = self.updatedName
                        pendingTemplate.isTemplate = true
                        
                        do {
                            for itom in self.items {
                                if !self.excluded.contains(itom) {
                                    let item = Item(context: self.context)
                                    
                                    item.name = itom.name
                                    item.index = try Item.generateItemIndex(category: pendingTemplate, context: self.context)
                                    pendingTemplate.addToItems(item)
                                }
                            }
                        } catch {
                            print(error)
                        }
                        
                        saveContext(self.context)

                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                    }
                }
            }.navigationBarTitle(Text("Create Template"))
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                }))
        }
    }
}


struct CreateTemplateFromCategory_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAAAAH")
    }
}
