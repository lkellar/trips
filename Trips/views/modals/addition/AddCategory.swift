//
//  AddCategory.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-11-12.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct AddCategory: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var context
    
    var trip: Trip
    @State var title: String = ""
    @State var selected: Category? = nil
    
    var templateRequest : FetchRequest<Category>
    var templates: FetchedResults<Category>{templateRequest.wrappedValue}
    
    @Binding var refreshing: Bool
    @Binding var selection: SelectionConfig
    
    var accent: Color
    
    init(trip: Trip, refreshing: Binding<Bool>, accent: Color, selection: Binding<SelectionConfig>) {
        templateRequest = FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate:
        NSPredicate(format: "%K == true", #keyPath(Category.isTemplate)))
        
        self.trip = trip
        
        _refreshing = refreshing
        _selection = selection
        
        self.accent = accent
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Create Custom Category")) {
                    TextField("Category Name", text: $title)
                }
                Button(action: {
                    do {
                        let category = Category(context: context)
                        category.name = title
                        
                        category.index =  try Category.generateCategoryIndex(trip: trip, context: context)
                        
                        trip.addToCategories(category)
                        
                        try context.save()
                    } catch {
                        print(error)
                    }
                    selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection, secondaryViewSelectionType: nil, secondaryViewSelection: nil)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Category")
                }.disabled(title.count == 0 ? true : false)
            }.navigationBarTitle("Add Category")
                .navigationBarItems(trailing:
                    Button(action: {
                        selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection, secondaryViewSelectionType: nil, secondaryViewSelection: nil)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                    })
            )
        }.accentColor(accent)
        .onDisappear(perform: {
            selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection, secondaryViewSelectionType: nil, secondaryViewSelection: nil)
            refreshing.toggle()
        }).navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AddCategory_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAH")
    }
}
