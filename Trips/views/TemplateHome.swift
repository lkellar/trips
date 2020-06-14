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

struct TemplatePair: Hashable {
    var first: Category
    var second: Category?
}

struct TemplateHome: View {
    @State var addTemplateModalDisplayed = false
    
    @State var refreshing = false
    @State var selection: NSManagedObjectID? = nil
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(fetchRequest: Category.allTemplatesFetchRequest()) var templates: FetchedResults<Category>
    
    var pairs: [TemplatePair] {
        get {
            return stride(from: 0, to: templates.count, by: 2).map {
                TemplatePair(first: templates[$0], second: (templates.count > ($0 + 1) ? templates[$0.advanced(by: 1)] : nil))
            }
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                if (self.templates.count > 0) {
                    ScrollView {
                        ForEach (Array(self.pairs.enumerated()), id:\.element) { index, pair in
                            TemplatePairView(pair: pair, index: index, refreshing: self.$refreshing, width: Int(geo.size.width), selection: self.$selection).environment(\.managedObjectContext, self.context)
                        }
                        Spacer()
                    }
                } else {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            AddButton(action: {self.addTemplateModalDisplayed = true}, text: "Add a Template!")
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("Templates" + (self.refreshing ? "" : ""))
            .navigationBarItems(trailing:
            Button(action: {
                self.addTemplateModalDisplayed = true
            }, label: {
                Image(systemName: "plus")
            }
                // Learned a cool fact, .sheet gets an empty environment, so, gotta recreate it
                ).padding()
                .sheet(isPresented: $addTemplateModalDisplayed, content: {
                    AddTemplate().environment(\.managedObjectContext, self.context)
                }))
                Text("No Template Selected").font(.subheadline)
            }.onDisappear(perform: {
                self.selection = nil
            })
    }
}
    
struct TemplatePairView: View {
    var pair: TemplatePair
    var index: Int
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var refreshing: Bool
    
    var width: Int
    
    @Binding var selection: NSManagedObjectID?
    
    var body: some View {
        HStack {
            Spacer()
        
            NavigationLink(destination: TemplateDetail(template: pair.first, refreshing: self.$refreshing, selection: self.$selection).environment(\.managedObjectContext, self.context), tag: pair.first.objectID, selection: $selection) {
                CategoryRectangular(category: pair.first, color: (index % 2 == 0 ? iconGreen : iconBlue), width: self.width, selection: $selection)
        }
        
        if (pair.second != nil) {
            // SwiftUI won't let me do the if let xyz = etc etc, so If we know it's not nil, we can force unwrap (I think?)
            NavigationLink(destination: TemplateDetail(template: pair.second!, refreshing: self.$refreshing, selection: self.$selection).environment(\.managedObjectContext, self.context), tag: pair.second!.objectID, selection: $selection) {
                CategoryRectangular(category: pair.second!, color: (index % 2 == 0 ? iconBlue : iconGreen), width: self.width, selection: $selection)
            }
        } else {
            // Invisible box, to make it even, so an odd row (just one box) doesn't center
            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .frame(width: CGFloat(self.width < 375 ? 125 : 150), height: CGFloat(self.width < 375 ? 125 : 150))
                .padding()
        }
        Spacer()
        }
    }
}

struct TemplateHome_Previews: PreviewProvider {
    static var previews: some View {
        TemplateHome()
    }
}
