//
//  EditTemplate.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-01-28.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI
import CoreData

struct EditTemplate: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var template: Category
    @Binding var refreshing: Bool
    
    @State var showDeleteAlert: Bool = false
    
    @State var updatedName: String = ""
    
    @Binding var selection: NSManagedObjectID?
   
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Template Name", text: $updatedName)
                        .onAppear {
                            if template.name.count > 0 {
                                updatedName = template.name
                            }
                    }
                    //Text((refreshing ? "" : ""))
                }
                Button(action: {
                    showDeleteAlert = true;
                }) {
                    Text("Delete").foregroundColor(.red)
                }.alert(isPresented: $showDeleteAlert, content: {
                    Alert(title: Text("Are you sure you want to delete \(updatedName)?"),
                          message: Text("This cannot be undone."),
                          primaryButton: Alert.Button.destructive(Text("Delete"), action: {
                            presentationMode.wrappedValue.dismiss()

                            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                                template.items.forEach {item in
                                    context.delete(item as! NSManagedObject)
                                }
                                context.delete(template)
                                selection = nil
                            })
                          }), secondaryButton: Alert.Button.cancel(Text("Cancel")))
                })
            }
            .navigationBarTitle("Edit Template")
            .navigationBarItems(trailing:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Close")
            }))
        }.onDisappear {
            if !template.isDeleted && template.name != updatedName {
                template.name = updatedName
            }
            if template.hasChanges {
                saveContext(context)
                refreshing.toggle()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct EditTemplate_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAHHH MY COMPUTER CANT DO PREVIEWS, or not very well")
    }
}
