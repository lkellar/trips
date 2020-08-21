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
        itemRequest = FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate:
        NSPredicate(format: "%K == %@", #keyPath(Item.category), template))
        
        self.template = template
        _refreshing = refreshing
        _selection = selection
    }
    
    var body: some View {
        ZStack {
            if (items.count > 0) {
                List {
                    ForEach(items) { item in
                        Text(item.name)
                    }.onDelete(perform: removeItem)
                        .onMove(perform: moveItem)
                    // using grouped style here, even though there's no grouping, just because it looks better and matches TripDetail
                }.listStyle(GroupedListStyle())
                
                VStack {
                    Spacer()
                    HStack {
                        AddExpander(color: .accentColor, showAddItem: $addItemModalDisplayed).padding()
                    }
                }
            } else {
                AddButton(action: {addItemModalDisplayed = true}, text: "Add an Item!")
            }
                
        }.navigationBarTitle(template.name + (refreshing ? "" : ""))
        .navigationBarItems(trailing:
            HStack {
                Button(action: {
                    print("Hidden what?")
                }) {
                    Text("")
                }.sheet(isPresented: $addItemModalDisplayed, content: {
                            AddItem(categories: [template], selectCategory: false, refreshing: $refreshing, accent: Color.accentColor).environment(\.managedObjectContext, context)
                }).padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 0))

                Button(action: {
                    editTemplateDisplayed = true
                }, label: {
                    Image(systemName: "info.circle")
                    })
                    .sheet(isPresented: $editTemplateDisplayed, content: {
                        EditTemplate(template: template, refreshing: $refreshing, selection: $selection).environment(\.managedObjectContext, context)
                    }).padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 0))
                EditButton().padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 0))
                
        })
        .onDisappear(perform: {
            selection = nil
        })
    }
    
    func removeItem(at offsets: IndexSet) {
        for offset in offsets {
            let item = items[offset]
            template.removeFromItems(item)
            context.delete(item)
        }
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        var items: [Item] = []
        for index in source {
            items.append(items[index])
        }
        
        for item in items {
            Item.adjustItemIndex(source: item.index, index: destination, category: template, context: context)
            item.index = (items.count != destination ? destination : destination - 1)
        }
        
        saveContext(context)
    }
}

struct TemplateDetail_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test 123")
    }
}
