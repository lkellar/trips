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
            VStack {
                List (self.pairs, id:\.self) { pair in
                    HStack {
                        Spacer()
                        PackRectangular(title: pair.first.name, color: .fromString(color: pair.first.color ?? "primary"))
                        PackRectangular(title: pair.second.name, color: .fromString(color: pair.second.color ?? "primary"))
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
