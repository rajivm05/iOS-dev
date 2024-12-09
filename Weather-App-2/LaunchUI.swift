//
//  LaunchUI.swift
//  Weather-App-ios
//
//  Created by Rajiv Murali on 12/2/24.
//

import SwiftUI

struct LaunchUI: View {
    var body: some View {
        
        VStack(spacing:220) {
            Image("Mostly Clear")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
            Image("Powered_by_Tomorrow-Black")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(
            Image("App_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
        
    }
}

#Preview {
    LaunchUI()
}
