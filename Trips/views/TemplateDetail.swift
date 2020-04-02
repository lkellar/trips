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
    var template: Category
    
    @Binding var refreshing: Bool
    
    var itemRequest : FetchRequest<Item>
    var items: FetchedResults<Item>{itemRequest.wrappedValue}
    
    @State var addItemModalDisplayed = false;
    @State var editTemplateDisplayed = false;
    
    init(template: Category, refreshing: Binding<Bool>) {
        self.itemRequest = FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate:
        NSPredicate(format: "%K == %@", #keyPath(Item.category), template))
        
        self.template = template
        self._refreshing = refreshing
    }
    
    var body: some View {
        VStack {
            if (self.items.count > 0) {
                List {
                    ForEach(self.items) { item in
                        Text(item.name)
                    }.onDelete(perform: removeItem)
                        .onMove(perform: moveItem)
                }
            } else {
                AddButton(action: {self.addItemModalDisplayed = true}, text: "Add an Item!")
            }
                
        }.navigationBarTitle(self.template.name + (self.refreshing ? "" : ""))
        .navigationBarItems(trailing:
            HStack {
                Button(action: {
                    self.editTemplateDisplayed = true
                }, label: {
                    Image(systemName: "info.circle")
                    }).padding()
                    .sheet(isPresented: $editTemplateDisplayed, content: {
                        EditTemplate(template: self.template, refreshing: self.$refreshing).environment(\.managedObjectContext, self.context)
                    })
                Button(action: {
                    self.addItemModalDisplayed = true
                }, label: {
                    Image(systemName: "plus")
                }
                    // Learned a cool fact, .sheet gets an empty environment, so, gotta recreate it
                    ).padding()
                    .sheet(isPresented: $addItemModalDisplayed, content: {
                        AddItem(categories: [self.template], selectCategory: false, refreshing: self.$refreshing).environment(\.managedObjectContext, self.context)
            })
                if self.items.count > 0 {
                    EditButton()
                }
        })
    }
    
    func removeItem(at offsets: IndexSet) {
        self.template.removeFromItems(at: NSIndexSet(indexSet: offsets))
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
