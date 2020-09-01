//
//  EditItemCategorySelector.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-08-28.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct EditItemCategorySelector: View {
    @Environment(\.managedObjectContext) var context
    @Binding var selectedCategory: Int

    var categoryRequest : FetchRequest<Category>
    var categories: FetchedResults<Category>{categoryRequest.wrappedValue}
    
    var item: Item
    
    init(item: Item, trip: Trip, selectedCategory: Binding<Int>) {
        self._selectedCategory = selectedCategory
        self.item = item

        categoryRequest = FetchRequest(entity: Category.entity(),sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate: NSPredicate(format: "%K == %@", #keyPath(Category.trip), trip))
    }
    var body: some View {
        Section {
            Picker(selection: $selectedCategory, label: Text("Category"),
                   content: {
                    ForEach(0 ..< categories.count, id:\.self) { index in
                        Text(categories[index].name).tag(index)
                    }
            }).onAppear {
                if selectedCategory == -1 {
                    selectedCategory = categories.firstIndex(of: item.category!) ?? 0
                }
            }
        }.onDisappear {
            if selectedCategory != -1 && item.category != categories[selectedCategory] {
                item.category = categories[selectedCategory]
            }
            if item.hasChanges {
                saveContext(context)
            }
        }
    }
}

struct EditItemCategorySelector_Previews: PreviewProvider {
    static var previews: some View {
        NoPreview()
    }
}
