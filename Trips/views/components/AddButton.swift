//
//  AddButton.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-02-25.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct AddButton: View {
    var action: () -> Void
    var text: String
    var accent: Color
    
    init(action: @escaping () -> Void, text: String, accent: Color = Color.blue) {
        self.action = action
        self.text = text
        self.accent = accent
    }

    var body: some View {
        Button(action: self.action) {
                Text(text)
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                    .background(self.accent)
                    .foregroundColor(.white)
                    .cornerRadius(40)
                    .padding(20)
        }
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAAAAAAAAAAAAAAh")
    }
}
