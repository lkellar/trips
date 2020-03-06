//
//  AddTemplateToExisting.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-03-04.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//
// 27

import SwiftUI

struct AddTemplateToExisting: View {
    @Environment(\.managedObjectContext) var context
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
     var templateRequest : FetchRequest<Pack>
     var templates: FetchedResults<Pack>{templateRequest.wrappedValue}
    
    @State var included: [Pack] = []
    
    @Binding var refreshing: Bool
    
    var trip: Trip
    
    init(trip: Trip, refreshing: Binding<Bool>) {
        self.templateRequest = FetchRequest(entity: Pack.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate:
        NSPredicate(format: "%K == true", #keyPath(Pack.isTemplate)))
        
        self.trip = trip
        self._refreshing = refreshing
    }
    
    var body: some View {
        NavigationView {
            Form {
                List {
                    ForEach(self.templates, id:\.self) { template in
                        Button(action: {
                            guard let index = self.included.firstIndex(of: template) else {
                               self.included.append(template)
                                return
                            }
                            self.included.remove(at: index)
                            
                        }) {
                            HStack {
                                Text(template.name)
                                    .foregroundColor(.primary)
                                Spacer()
                                if self.included.contains(template) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                Section(footer: Text("A copy of selected Templates will be added to your Trip")) {
                    Button(action: {
                        for tomplate in self.included {
                            do {
                                try copyTemplateToTrip(template: tomplate, trip: self.trip, context: self.context)
                            } catch {
                                print(error)
                            }
                        }
                        self.refreshing.toggle()
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                    })
                }
            }.navigationBarTitle("Templates")
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
            }))
        }
    }
}

struct AddTemplateToExisting_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAAAAAAAAAAAAAAAH")
    }
}
