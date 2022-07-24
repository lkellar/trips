//
//  StackCounter.swift
//  Trips
//
//  Created by Lucas Kellar on 6/21/21.
//  Copyright © 2021 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct StackCounter: View {
    
    @Environment(\.colorScheme) var colorScheme
    var completedCount: Int
    var totalCount: Int
    
    var body: some View {
        if totalCount > 1 {
            ZStack {
                RoundedRectangle(cornerRadius: 7.92)
                    .fill(Color.accentColor)
                    // for each digit, add six, plus a base of thirty
                    .frame(width: 30 + (totalCount >= 10 ? 12 : 6) + (completedCount >= 10 ? 12 : 6), height: 30)
                    .animation(.easeOut)
                Text("\(completedCount)/\(totalCount)")
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
            }
            .padding(.trailing, 10)
        }
    }
}

struct StackCounter_Previews: PreviewProvider {
    static var previews: some View {
        NoPreview()
    }
}
