//
//  FavoritePageView.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/12/24.
//

import SwiftUI

struct FavoritePageView: View {
    private var bible: FavoriteModel
    init(bible:FavoriteModel){
        self.bible = bible
    }
    var body: some View {
        Text(bible.formattedAddress)
    }
}

//#Preview {
//    FavoritePageView()
//}
