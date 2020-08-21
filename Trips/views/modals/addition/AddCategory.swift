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
    
    var accent: Color
    
    init(trip: Trip, refreshing: Binding<Bool>, accent: Color) {
        templateRequest = FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate:
        NSPredicate(format: "%K == true", #keyPath(Category.isTemplate)))
        
        self.trip = trip
        
        _refreshing = refreshing
        
        self.accent = accent
    }
    
    var body: some View {
        NavigationView {
            Form {
                if templates.count > 0 {
                    Section(header: Text("Templates")) {
                        ForEach(templates, id:\.self) {template in
                            Button(action: {
                                if selected == template {
                                    selected = nil
                                } else {
                                   selected = template
                                    return
                                }
                                
                            }) {
                                HStack {
                                    Text(template.name)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if selected == template {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(accent)
                                    }
                                }
                            }
                        }
                    }
                
                    Section {
                        Button(action: {
                            do {
                                if let tomplate = selected {
                                    try copyTemplateToTrip(template: tomplate, trip: trip, context: context)
                                } else {
                                    print("Template is null. Lol")
                                }
                            } catch {
                                print(error)
                            }
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save Template")
                        }.disabled(selected == nil)
                    }
                }
                
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
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Custom Category")
                }.disabled(title.count == 0 ? true : false)
            }.navigationBarTitle("Add Category")
                .navigationBarItems(trailing:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                    })
            )
        }.accentColor(accent)
        .onDisappear(perform: {
            refreshing.toggle()
        }).navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AddCategory_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAH")
    }
}
