//
//  TemplateDetail.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-01-21.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI
import CoreData

struct TemplateDetail: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.editMode) var editMode
    
    var template: Category
    
    @Binding var refreshing: Bool
    
    var itemRequest : FetchRequest<Item>
    var items: FetchedResults<Item>{itemRequest.wrappedValue}

    @State var editItemModalDisplayed = false
    @State var addItemModalDisplayed = false;
    @State var editTemplateDisplayed = false;
    @State var addItemToggle = false;
    
    @Binding var selection: SelectionConfig
    @Binding var accent: Color
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    #endif
    @State var showModals: Bool = false
    
    init(template: Category, refreshing: Binding<Bool>, selection: Binding<SelectionConfig>, accent: Binding<Color>) {
        itemRequest = FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate:
        NSPredicate(format: "%K == %@", #keyPath(Item.category), template))
        
        self.template = template
        _refreshing = refreshing
        _selection = selection
        _accent = accent
    }
    
    var body: some View {
        ZStack {
            if (items.count > 0) {
                List {
                    ForEach(items) { item in
                        Button(action: {
                            selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection,
                                          secondaryViewSelectionType: selection.secondaryViewSelection == item.objectID ? nil : .editItem,
                                          secondaryViewSelection: selection.secondaryViewSelection == item.objectID ? nil : item.objectID)
                            if (showModals) {
                                editItemModalDisplayed = true
                            }
                    }) {
                        Text(item.name)
                            .contextMenu {
                                Button(action: {
                                    selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection, secondaryViewSelectionType: .editItem, secondaryViewSelection: item.objectID)
                                    
                                    if (showModals) {
                                        editItemModalDisplayed = true
                                    }
                                }) {
                                    Label("Edit Item", systemImage: "info.circle")
                                }
                                Button(action: {
                                    do {
                                        let newItem = Item(context: context)
                                        newItem.name = item.name
                                        newItem.index = try Item.generateItemIndex(category: template, context: context)
                                        template.addToItems(item)
                                        newItem.category = template
                                        
                                        saveContext(context)
                                    } catch {
                                        print(error)
                                    }
                                }) {
                                    Label("Duplicate Item", systemImage: "doc.on.doc")
                                }
                                Button(action: {
                                    template.removeFromItems(item)
                                    context.delete(item)
                                    saveContext(context)
                                }) {
                                    Label("Delete Item", systemImage: "trash")
                                }
                            }
                            .accentColor(.primary)
                    }
                    }.onDelete(perform: getDeleteFunction(category: template, context: context))
                        .onMove(perform: getMoveFunction(category: template, context: context))
                    // using grouped style here, even though there's no grouping, just because it looks better and matches TripDetail
                }.listStyle(GroupedListStyle())
                
                VStack {
                    Spacer()
                    HStack {
                        AddExpander(color: .accentColor, showAddItem: $addItemToggle).padding()
                    }
                }
            } else {
                VStack {
                    Spacer()
                    AddButton(action: {
                        addItemToggle.toggle()
                    }, text: "Add an Item!")
                    Spacer()
                }
            }
                
        }.navigationBarTitle(template.name + (refreshing ? "" : ""))
        .navigationBarItems(trailing:
            HStack {
                Button(action: {
                    print("Hidden what?")
                }) {
                    Text("")
                }.sheet(isPresented: $addItemModalDisplayed, content: {
                    AddItem(categories: [template], selectCategory: false, refreshing: $refreshing, accent: Color.accentColor, selection: $selection).environment(\.managedObjectContext, context)
                }).padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 0))
                
                Button(action: {
                    print("Hidedn 1.5")
                }) {
                    Spacer()
                }.sheet(isPresented: $editItemModalDisplayed, content: {
                    EditItem(selection: $selection, accent: $accent).environment(\.managedObjectContext, context)
                })
                Button(action: {
                    if (showModals) {
                        editTemplateDisplayed = true
                    }
                    selection.secondaryViewSelectionType = selection.secondaryViewSelectionType == .editTemplate ? nil : .editTemplate
                }, label: {
                    Image(systemName: "info.circle")
                    })
                    .sheet(isPresented: $editTemplateDisplayed, content: {
                        EditTemplate(template: template, refreshing: $refreshing, selection: $selection).environment(\.managedObjectContext, context)
                    }).padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 0))
                EditButton().padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 0))
                
            }).onChange(of: addItemToggle) {newAddItemToggle in
                selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection,
                    secondaryViewSelectionType: selection.secondaryViewSelectionType == .addItem ? nil : .addItem,
                  secondaryViewSelection: nil)
                if (showModals) {
                    addItemModalDisplayed = true
                }
            }
        .onAppear {
            #if os(iOS)
            if horizontalSizeClass == .compact {
                showModals = true
                if (selection.secondaryViewSelectionType == .editTemplate) {
                    editTemplateDisplayed = true
                }
            }
            #endif
        }
    }
}

struct TemplateDetail_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test 123")
    }
}
