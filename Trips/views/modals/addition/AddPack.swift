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
    @State var selected: Pack? = nil
    
    var templateRequest : FetchRequest<Pack>
    var templates: FetchedResults<Pack>{templateRequest.wrappedValue}
    
    init(trip: Trip) {
        self.templateRequest = FetchRequest(entity: Pack.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate:
        NSPredicate(format: "%K == true", #keyPath(Pack.isTemplate)))
        
        self.trip = trip
    }
    
    var body: some View {
        NavigationView {
            Form {
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
                
                Section(header: Text("Create Custom Pack")) {
                    TextField("Pack Name", text: $title)
                }
                Button(action: {
                    do {
                        let pack = Pack(context: self.context)
                        pack.name = self.title
                        
                        pack.index =  try Pack.generatePackIndex(trip: self.trip, context: self.context)
                        
                        self.trip.addToPacks(pack)
                        
                        try self.context.save()
                    } catch {
                        print(error)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Custom Pack")
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
