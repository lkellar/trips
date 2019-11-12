//
//  AddPack.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-11-12.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct AddPack: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var context
    
    var trip: Trip
    @State var title: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Pack Name", text: $title)
                }
                Button(action: {
                    do {
                        let pack = Pack(context: self.context)
                        pack.name = self.title
                        
                        self.trip.addToPacks(pack)
                        
                        try self.context.save()
                    } catch {
                        print(error)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save!")
                }.disabled(self.title.count == 0 ? true : false)
            }.navigationBarTitle("Add Pack")
                .navigationBarItems(trailing:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                    })
            )
        }
    }
}

struct AddPack_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAH")
    }
}
