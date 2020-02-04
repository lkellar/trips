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
    var second: Pack
}

struct TemplateHome: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(fetchRequest: Pack.allTemplatesFetchRequest()) var templates: FetchedResults<Pack>
    
    var pairs: [TemplatePair] {
        get {
            return stride(from: 0, to: templates.count, by: 2).map {
                TemplatePair(first: templates[$0], second: templates[$0.advanced(by: 1)])
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach (Array(self.pairs.enumerated()), id:\.element) { index, pair in
                    HStack {
                        Spacer()
                        NavigationLink(destination: TemplateDetail(template: pair.first)) {
                            PackRectangular(title: pair.first.name, color: (index % 2 == 0 ? .blue : .pink))
                        }.buttonStyle(PlainButtonStyle())

                            NavigationLink(destination: TemplateDetail(template: pair.second)) {
                                PackRectangular(title: pair.second.name, color: (index % 2 == 0 ? .pink : .blue))
                        }.buttonStyle(PlainButtonStyle())

                        Spacer()
                    }
                }
                Spacer()
            }
            .navigationBarTitle("Templates")
        }
    }
}

struct TemplateHome_Previews: PreviewProvider {
    static var previews: some View {
        TemplateHome()
    }
}
