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
    
     var templateRequest : FetchRequest<Category>
     var templates: FetchedResults<Category>{templateRequest.wrappedValue}
    
    @State var included: [Category] = []
    
    @Binding var refreshing: Bool
    
    var trip: Trip
    
    init(trip: Trip, refreshing: Binding<Bool>) {
        templateRequest = FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate:
        NSPredicate(format: "%K == true", #keyPath(Category.isTemplate)))
        
        self.trip = trip
        _refreshing = refreshing
    }
    
    var body: some View {
        NavigationView {
            Form {
                List {
                    ForEach(templates, id:\.self) { template in
                        Button(action: {
                            guard let index = included.firstIndex(of: template) else {
                               included.append(template)
                                return
                            }
                            included.remove(at: index)
                            
                        }) {
                            HStack {
                                Text(template.name)
                                    .foregroundColor(.primary)
                                Spacer()
                                if included.contains(template) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                Section(footer: Text("A copy of selected Templates will be added to your Trip")) {
                    Button(action: {
                        for tomplate in included {
                            do {
                                try copyTemplateToTrip(template: tomplate, trip: trip, context: context)
                            } catch {
                                print(error)
                            }
                        }
                        refreshing.toggle()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                    })
                }
            }.navigationBarTitle("Templates")
            .navigationBarItems(trailing:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
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
