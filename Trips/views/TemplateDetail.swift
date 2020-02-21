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
    var template: Pack
    
    @Binding var refreshing: Bool
    
    var itemRequest : FetchRequest<Item>
    var items: FetchedResults<Item>{itemRequest.wrappedValue}
    
    @State var addItemModalDisplayed = false;
    @State var editTemplateDisplayed = false;
    
    init(template: Pack, refreshing: Binding<Bool>) {
        self.itemRequest = FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate:
        NSPredicate(format: "%K == %@", #keyPath(Item.pack), template))
        
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
                }
            } else {
                Button(action: {
                    self.addItemModalDisplayed = true
                }) {
                    Text("Add an Item!")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color(UIColor.systemGray6))
                        .cornerRadius(40)
                        .padding(20)
                        .sheet(isPresented: $addItemModalDisplayed, content: {
                            AddItem(packs: [self.template], selectPack: false).environment(\.managedObjectContext, self.context)
                        })
                }
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
                        AddItem(packs: [self.template], selectPack: false).environment(\.managedObjectContext, self.context)
            })})
    }
    
    func removeItem(at offsets: IndexSet) {
        self.template.removeFromItems(at: NSIndexSet(indexSet: offsets))
    }
}

struct TemplateDetail_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test 123")
    }
}
