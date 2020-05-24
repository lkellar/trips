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
        self.templateRequest = FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate:
        NSPredicate(format: "%K == true", #keyPath(Category.isTemplate)))
        
        self.trip = trip
        
        self._refreshing = refreshing
        
        self.accent = accent
    }
    
    var body: some View {
        NavigationView {
            Form {
                if self.templates.count > 0 {
                    Section(header: Text("Templates")) {
                        ForEach(self.templates, id:\.self) {template in
                            Button(action: {
                                if self.selected == template {
                                    self.selected = nil
                                } else {
                                   self.selected = template
                                    return
                                }
                                
                            }) {
                                HStack {
                                    Text(template.name)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if self.selected == template {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                
                    Section {
                        Button(action: {
                            do {
                                if let tomplate = self.selected {
                                    try copyTemplateToTrip(template: tomplate, trip: self.trip, context: self.context)
                                } else {
                                    print("Template is null. Lol")
                                }
                            } catch {
                                print(error)
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save Template")
                        }.disabled(self.selected == nil)
                    }
                }
                
                Section(header: Text("Create Custom Category")) {
                    TextField("Category Name", text: $title)
                }
                Button(action: {
                    do {
                        let category = Category(context: self.context)
                        category.name = self.title
                        
                        category.index =  try Category.generateCategoryIndex(trip: self.trip, context: self.context)
                        
                        self.trip.addToCategories(category)
                        
                        try self.context.save()
                    } catch {
                        print(error)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Custom Category")
                }.disabled(self.title.count == 0 ? true : false)
            }.navigationBarTitle("Add Category")
                .navigationBarItems(trailing:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                    })
            )
        }.accentColor(self.accent)
        .onDisappear(perform: {
            self.refreshing.toggle()
        })
    }
}

struct AddCategory_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAH")
    }
}
