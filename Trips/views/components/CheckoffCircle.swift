//
//  CheckoffCircle.swift
//  Trips
//
//  Created by Lucas Kellar on 6/21/21.
//  Copyright © 2021 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct CheckoffCircle: View {
    var status: ItemCompletionStatus
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CGFloat(15))
            .stroke(Color.secondary, lineWidth: CGFloat(3))
                Circle()
                .trim(from: statusToVal(status, from: true), to: statusToVal(status, from: false))
                    .fill(Color.secondary)
                    .animation(.default)
                    .frame(width: CGFloat(16.0), height: CGFloat(16.0))
            }.frame(width: CGFloat(26.0), height: CGFloat(26.0))
        .padding(EdgeInsets(top: CGFloat(0), leading: CGFloat(0), bottom: CGFloat(0), trailing: CGFloat(10)))
    }
    
    func statusToVal(_ status: ItemCompletionStatus, from: Bool) -> CGFloat {
        switch status {
        case .completed:
            return from ? 0 : 1
        case .partial:
            return from ? 0.25 : 0.75
        case .notcompleted:
            return 0.5
        }
    }
}

struct CheckoffCircle_Previews: PreviewProvider {
    static var previews: some View {
        NoPreview()
    }
}
