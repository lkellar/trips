//
//  TemplateHome.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-01-07.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct TemplatePair: Hashable {
    var first: Pack
    var second: Pack?
}

struct TemplateHome: View {
    @State var addTemplateModalDisplayed = false
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(fetchRequest: Pack.allTemplatesFetchRequest()) var templates: FetchedResults<Pack>
    
    var pairs: [TemplatePair] {
        get {
            return stride(from: 0, to: templates.count, by: 2).map {
                TemplatePair(first: templates[$0], second: (templates.count > ($0 + 1) ? templates[$0.advanced(by: 1)] : nil))
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if (self.templates.count > 0) {
                    ScrollView {
                        ForEach (Array(self.pairs.enumerated()), id:\.element) { index, pair in
                            TemplatePairView(pair: pair, index: index)
                        }
                        Spacer()
                    }
                } else {
                    Button(action: {
                            self.addTemplateModalDisplayed = true
                        }) {
                            Text("Add a Template!")
                                .fontWeight(.bold)
                                .font(.title)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(Color(UIColor.systemGray6))
                                .cornerRadius(40)
                                .padding(20)
                                .sheet(isPresented: $addTemplateModalDisplayed, content: {
                                    AddTemplate().environment(\.managedObjectContext, self.context)
                            })
                        }
                    }
                }
            .navigationBarTitle("Templates")
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
            }
        }
    }
    
struct TemplatePairView: View {
    var pair: TemplatePair
    var index: Int
    
    var body: some View {
        HStack {
            Spacer()
        
            NavigationLink(destination: TemplateDetail(template: pair.first)) {
                PackRectangular(title: pair.first.name, color: (index % 2 == 0 ? .blue : .pink), sneaky: false)
        }.buttonStyle(PlainButtonStyle())
        
        if (pair.second != nil) {
            // SwiftUI won't let me do the if let xyz = etc etc, so If we know it's not nil, we can force unwrap (I think?)
            NavigationLink(destination: TemplateDetail(template: pair.second!)) {
                PackRectangular(title: pair.second!.name, color: (index % 2 == 0 ? .pink : .blue), sneaky: false)
            }.buttonStyle(PlainButtonStyle())
        } else {
            PackRectangular(title: "", color: Color.white, sneaky: true)
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
