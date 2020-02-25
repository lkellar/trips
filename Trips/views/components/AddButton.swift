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
    
    var body: some View {
        Button(action: self.action) {
                Text(text)
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(Color(UIColor.systemGray6))
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
