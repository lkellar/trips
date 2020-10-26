//
//  AddTemplate.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-02-07.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import CoreData
import SwiftUI

struct AddTemplate: View {
    @State var title: String = ""
    
    @Binding var selection: SelectionConfig
    var modal: Bool
    
    @Environment(\.managedObjectContext) var context
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        Form {
            Section {
                TextField("Template Name", text: $title)
            }
            
            Section {
                Button(action: {
                    let pendingTemplate = Category(context: context)
                    
                    pendingTemplate.name = title
                    pendingTemplate.isTemplate = true
                    
                    saveContext(context)
                    
                    selection = SelectionConfig(viewSelectionType: .template, viewSelection: pendingTemplate.objectID)
                    if (modal) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Save")
                }.disabled(title.count == 0)
            }
        }
    .navigationBarTitle("Add Template")
        .navigationBarItems(trailing:
                        Button(action: {
                            selection = SelectionConfig(viewSelectionType: .template, viewSelection: nil)
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            if (modal) {
                                Text("Cancel")
                            }
                        }))
    }
}

struct AddTemplate_Previews: PreviewProvider {
    static var previews: some View {
        NoPreview()
    }
}
