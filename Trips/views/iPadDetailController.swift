//
//  iPadDetailController.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-09-18.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct iPadDetailController<Content: View, OtherContent: View>: View {
    let left: Content
    let right: OtherContent?
    
    @State var width = 0
    
    init(@ViewBuilder left: () -> Content, @ViewBuilder right: () -> OtherContent) {
        self.left = left()
        self.right = right()
    }
    
    init(@ViewBuilder left: () -> Content) {
        self.left = left()
        self.right = nil
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                left
                    .navigationBarHidden(width > 0)
                    .frame(width: CGFloat(width == 0 ? geo.size.width : (geo.size.width - CGFloat(max(400, Int(geo.size.width * 0.4))))))
                if (width > 0) {
                    Divider()
                }
                right
                .frame(width: CGFloat(width))
                .onAppear {
                    withAnimation {
                        width = max(400, Int(geo.size.width * 0.4))
                    }
                }
                .onDisappear {
                    withAnimation {
                        width = 0
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: (width > 0 ? 25 : 0)))
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }
}

struct iPadDetailController_Previews: PreviewProvider {
    static var previews: some View {
        NoPreview()
    }
}
