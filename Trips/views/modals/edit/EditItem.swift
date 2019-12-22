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
    //var pack: Pack
    
    @State var updatedName: String = ""
    // @State var refreshing: Bool = false
   
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Item Name", text: $updatedName)
                        .onAppear {
                            if self.item.name.count > 0 {
                                self.updatedName = self.item.name
                            }
                            print("I HAVE APPEARED")
                    }
                    //Text((self.refreshing ? "" : ""))
                }
            }
            .navigationBarTitle("Edit Item")
            .navigationBarItems(trailing:
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Close")
            }))
        }.onDisappear {
            self.item.name = self.updatedName
            saveContext(self.context)
        }
    }
}

struct EditItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAHHH MY COMPUTER CANT DO PREVIEWS, or not very well")
    }
}
