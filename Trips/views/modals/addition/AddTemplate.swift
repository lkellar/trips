//
//  AddTemplate.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-02-07.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct AddTemplate: View {
    @State var title: String = ""
    
    @Environment(\.managedObjectContext) var context
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Template Name", text: $title)
                }
                
                Section {
                    Button(action: {
                        let pendingTemplate = Category(context: self.context)
                        
                        pendingTemplate.name = self.title
                        pendingTemplate.isTemplate = true
                        
                        saveContext(self.context)
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                    }.disabled(title.count == 0)
                }
            }
        .navigationBarTitle("Add Template")
        .navigationBarItems(trailing:
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
            }))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AddTemplate_Previews: PreviewProvider {
    static var previews: some View {
        AddTemplate()
    }
}
