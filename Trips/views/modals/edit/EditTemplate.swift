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
                            if self.template.name.count > 0 {
                                self.updatedName = self.template.name
                            }
                    }
                    //Text((self.refreshing ? "" : ""))
                }
                Button(action: {
                    self.showDeleteAlert = true;
                }) {
                    Text("Delete").foregroundColor(.red)
                }.alert(isPresented: self.$showDeleteAlert, content: {
                    Alert(title: Text("Are you sure you want to delete \(self.updatedName)?"),
                          message: Text("This cannot be undone."),
                          primaryButton: Alert.Button.destructive(Text("Delete"), action: {
                            self.presentationMode.wrappedValue.dismiss()

                            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                                self.template.items.forEach {item in
                                    self.context.delete(item as! NSManagedObject)
                                }
                                self.context.delete(self.template)
                                self.selection = nil
                            })
                          }), secondaryButton: Alert.Button.cancel(Text("Cancel")))
                })
            }
            .navigationBarTitle("Edit Template")
            .navigationBarItems(trailing:
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Close")
            }))
        }.onDisappear {
            if !self.template.isDeleted && self.template.name != self.updatedName {
                self.template.name = self.updatedName
            }
            if self.template.hasChanges {
                saveContext(self.context)
                self.refreshing.toggle()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct EditTemplate_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAHHH MY COMPUTER CANT DO PREVIEWS, or not very well")
    }
}
