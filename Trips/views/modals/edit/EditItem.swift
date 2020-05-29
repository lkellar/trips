//
//  ItemDetail.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-12-13.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI
import CoreData

struct EditItem: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var item: Item
    
    var accent: Color
    
    @State var updatedName: String = ""
    @State var selectedCategory: Int = -1
    
    var categoryRequest : FetchRequest<Category>
    var categories: FetchedResults<Category>{categoryRequest.wrappedValue}
    
    init(item: Item, accent: Color, trip: Trip) {
        self.item = item
        self.accent = accent
        
        self.categoryRequest = FetchRequest(entity: Category.entity(),sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate:
            NSPredicate(format: "%K == %@", #keyPath(Category.trip), trip))
    }
   
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Item Name", text: $updatedName)
                        .onAppear {
                            if self.item.name.count > 0 {
                                self.updatedName = self.item.name
                            }
                    }
                    //Text((self.refreshing ? "" : ""))
                }
                Section {
                    Picker(selection: self.$selectedCategory, label: Text("Category"),
                           content: {
                            ForEach(0 ..< categories.count, id:\.self) { index in
                                Text(self.categories[index].name).tag(index)
                            }
                    }).onAppear {
                        if self.selectedCategory == -1 {
                            self.selectedCategory = self.categories.firstIndex(of: self.item.category!) ?? 0
                        }
                    }
                }
            }
            .navigationBarTitle("Edit Item")
            .navigationBarItems(trailing:
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Close")
            }))
        }
        .accentColor(self.accent)
        .onDisappear {
            self.item.name = self.updatedName
            self.item.category = self.categories[self.selectedCategory]
            saveContext(self.context)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct EditItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAHHH MY COMPUTER CANT DO PREVIEWS, or not very well")
    }
}
