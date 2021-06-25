//
//  TemplateHome.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-01-07.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI
import CoreData

//let iconBlue = Color(UIColor(red: 0.46, green: 0.79, blue: 0.99, alpha: 1.00))
let iconGreen = Color(UIColor(red: 0.30, green: 0.86, blue: 0.75, alpha: 1.00))

//let iconGreen = Color.green
let iconBlue = Color.blue

struct TemplateHome: View {
    @Binding var selection: SelectionConfig
    @State var detailSelection: NSManagedObjectID? = nil

    @State var addTemplateModalDisplayed = false
    
    @State var refreshing = false
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(fetchRequest: Category.allTemplatesFetchRequest()) var templates: FetchedResults<Category>
    
    var columnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                if (templates.count > 0) {
                    ScrollView {
                        LazyVGrid(columns: columnGrid) {
                            ForEach(Array(templates.enumerated()), id: \.element) {index, template in
                                NavigationLink(destination: TemplateDetail(template: template, refreshing: $refreshing, selection: $selection, accent: Binding.constant(Color.blue)), tag: template.objectID, selection: $selection.viewSelection) {
                                    Button(action: {
                                        selection.viewSelection = template.objectID
                                        selection.viewSelectionType = .template
                                    }) {
                                        CategoryRectangular(name: template.name, color: (index % 4 == 1 || index % 4 == 2 ? iconBlue : iconGreen), width: Int(geo.size.width))
                                    }.buttonStyle(PlainButtonStyle())
                                    
                                    .contextMenu {
                                        Button(action: {
                                            selection = SelectionConfig(viewSelectionType: .template, viewSelection: template.objectID, secondaryViewSelectionType: .editTemplate, secondaryViewSelection: nil)
                                            
                                        }) {
                                            Label("Edit Template", systemImage: "info.circle")
                                        }
                                        Button(action: {
                                            template.items.forEach {item in
                                                context.delete(item as! NSManagedObject)
                                            }
                                            context.delete(template)
                                            saveContext(context)
                                        }) {
                                            Label("Delete Template", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            AddButton(action: {
                                addTemplateModalDisplayed = true
                                selection = SelectionConfig(viewSelectionType: .addTemplate, viewSelection: nil, secondaryViewSelectionType: .none)
                            }, text: "Add a Template!")
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                SampleDataFactory(context: context).addSampleTemplates()
                            }) {
                                Text("Or add example Templates.")
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("Templates" + (refreshing ? "" : ""))
            .navigationBarItems(trailing:
            Button(action: {
                addTemplateModalDisplayed = true
                selection = SelectionConfig(viewSelectionType: .addTemplate, viewSelection: nil)
            }, label: {
                Image(systemName: "plus")
            }
                // Learned a cool fact, .sheet gets an empty environment, so, gotta recreate it
                ).padding()
                .sheet(isPresented: $addTemplateModalDisplayed, content: {
                    NavigationView {
                        AddTemplate(selection: $selection, modal: true).environment(\.managedObjectContext, self.context)
                    }
                                }))
                Text("No Template Selected").font(.subheadline)
            }
    }
}

struct TemplateHome_Previews: PreviewProvider {
    static var previews: some View {
        NoPreview()
    }
}
