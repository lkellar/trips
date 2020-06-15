//
//  TemplateDetail.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-01-21.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI
import CoreData

struct TemplateDetail: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.editMode) var editMode
    
    var template: Category
    
    @Binding var refreshing: Bool
    @Binding var selection: NSManagedObjectID?
    
    var itemRequest : FetchRequest<Item>
    var items: FetchedResults<Item>{itemRequest.wrappedValue}
    
    @State var addItemModalDisplayed = false;
    @State var editTemplateDisplayed = false;
    
    init(template: Category, refreshing: Binding<Bool>, selection: Binding<NSManagedObjectID?>) {
        self.itemRequest = FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate:
        NSPredicate(format: "%K == %@", #keyPath(Item.category), template))
        
        self.template = template
        self._refreshing = refreshing
        self._selection = selection
    }
    
    var body: some View {
        ZStack {
            if (self.items.count > 0) {
                List {
                    ForEach(self.items) { item in
                        Text(item.name)
                    }.onDelete(perform: removeItem)
                        .onMove(perform: moveItem)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        AddExpander(color: .accentColor, showAddItem: self.$addItemModalDisplayed).padding()
                    }
                }
            } else {
                AddButton(action: {self.addItemModalDisplayed = true}, text: "Add an Item!")
            }
                
        }.navigationBarTitle(self.template.name + (self.refreshing ? "" : ""))
        .navigationBarItems(trailing:
            HStack {
                Button(action: {
                    print("Hidden what?")
                }) {
                    Text("")
                }.sheet(isPresented: $addItemModalDisplayed, content: {
                            AddItem(categories: [self.template], selectCategory: false, refreshing: self.$refreshing, accent: Color.accentColor).environment(\.managedObjectContext, self.context)
                }).padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 0))

                Button(action: {
                    self.editTemplateDisplayed = true
                }, label: {
                    Image(systemName: "info.circle")
                    })
                    .sheet(isPresented: $editTemplateDisplayed, content: {
                        EditTemplate(template: self.template, refreshing: self.$refreshing, selection: self.$selection).environment(\.managedObjectContext, self.context)
                    }).padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 0))
                EditButton().padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 0))
                
        })
        .onDisappear(perform: {
            self.selection = nil
        })
    }
    
    func removeItem(at offsets: IndexSet) {
        for offset in offsets {
            let item = self.items[offset]
            self.template.removeFromItems(item)
            self.context.delete(item)
        }
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        var items: [Item] = []
        for index in source {
            items.append(self.items[index])
        }
        
        for item in items {
            Item.adjustItemIndex(source: item.index, index: destination, category: self.template, context: self.context)
            item.index = (self.items.count != destination ? destination : destination - 1)
        }
        
        saveContext(self.context)
    }
}

struct TemplateDetail_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test 123")
    }
}
