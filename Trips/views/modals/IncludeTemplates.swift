//
//  AddTemplates.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-02-04.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct IncludeTemplates: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(fetchRequest: Category.allTemplatesFetchRequest()) var templates: FetchedResults<Category>
    
    @Binding var included: [Category]
    
    var body: some View {
        List {
            Section(footer: Text("A copy of selected Templates will be added to your Trip")) {
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
        }.navigationBarTitle("Templates")
    }
}

struct IncludeTemplates_Previews: PreviewProvider {
    static var previews: some View {
        Text("I think it's faster for me to just run simulator than deal with the previews")
    }
}
