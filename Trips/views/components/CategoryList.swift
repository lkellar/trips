//
//  CategoryList.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-09-04.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import CoreData
import SwiftUI

struct CategoryList: View {
    @Environment(\.managedObjectContext) var context
    @Binding var accent: Color
    var trip: Trip
    
    var categoryRequest : FetchRequest<Category>
    var categories: FetchedResults<Category>{categoryRequest.wrappedValue}

    init(trip: Trip, accent: Binding<Color>) {
        self.trip = trip
        _accent = accent
        
        categoryRequest = FetchRequest(entity: Category.entity(),sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate:
            NSPredicate(format: "%K == %@", #keyPath(Category.trip), trip))
    }
    
    var body: some View {
        Form {
                List {
                    ForEach(categories, id: \.self) { category in
                        NavigationLink(destination: EditCategory(category: category, accent: accent)) {
                            Text(category.name)
                        }
                   }
                    .onMove(perform: moveCategory)
                    .onDelete(perform: deleteCategory)
                }
        }.navigationBarTitle("Categories")
        .navigationBarItems(trailing:
            EditButton()
                .foregroundColor(accent)
        )
    }
    
    func deleteCategory(at offsets: IndexSet) {
        for offset in offsets {
            let category = categories[offset]
            trip.removeFromCategories(category)
            
            category.items.forEach {item in
                context.delete(item as! NSManagedObject)
            }
            context.delete(category)
        }
            
        saveContext(context)
    }
    
    func moveCategory(from source: IndexSet, to destination: Int) {
        var items: [Category] = []
        for index in source {
            items.append(categories[index])
        }
        
        for item in items {
            Category.adjustCategoryIndex(source: item.index, index: destination, trip: trip, context: context)
            item.index = (categories.count != destination ? destination : destination - 1)
        }
        
        saveContext(context)
    }
}

struct CategoryList_Previews: PreviewProvider {
    static var previews: some View {
        NoPreview()
    }
}
