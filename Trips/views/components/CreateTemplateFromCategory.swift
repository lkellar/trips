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
    var accent: Color
    
    @State var updatedName: String = ""
    @State var excluded: [Item] = []
    
    var itemRequest : FetchRequest<Item>
    var items: FetchedResults<Item>{itemRequest.wrappedValue}
    
    init(category: Category, accent: Color) {
        itemRequest = FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate:
        NSPredicate(format: "%K == %@", #keyPath(Item.category), category))
        
        self.category = category
        self.accent = accent
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Template Name", text: $updatedName).onAppear {
                        updatedName = category.name
                    }
                }
                Section {
                    if (items.count > 0) {
                        ForEach(items, id:\.self) { item in
                            Button(action: {
                                guard let index = excluded.firstIndex(of: item) else {
                                    excluded.append(item)
                                    return
                                }
                                excluded.remove(at: index)
                                
                            }) {
                                HStack {
                                    Text(item.name)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if !excluded.contains(item) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                        }
                    } else {
                        Text("No Items in Category")
                    }
                }
                Section {
                    Button(action: {
                        let pendingTemplate = Category(context: context)
                        
                        pendingTemplate.name = updatedName
                        pendingTemplate.isTemplate = true
                        
                        do {
                            for itom in items {
                                if !excluded.contains(itom) {
                                    let item = Item(context: context)
                                    
                                    item.name = itom.name
                                    item.index = try Item.generateItemIndex(category: pendingTemplate, context: context)
                                    pendingTemplate.addToItems(item)
                                }
                            }
                        } catch {
                            print(error)
                        }
                        
                        saveContext(context)

                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                    }.disabled(updatedName.count == 0 ? true : false)
                }
            }.navigationBarTitle(Text("Create Template"))
            .navigationBarItems(trailing:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                }))
        }.navigationViewStyle(StackNavigationViewStyle())
        .accentColor(accent)
    }
}


struct CreateTemplateFromCategory_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAAAAH")
    }
}
