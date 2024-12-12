//
//  FavoriteToggleButton.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/12/24.
//

import SwiftUI

struct FavoriteToggleButton: View {
    @State private var isFavorite: Bool
    let onToggle: () async throws -> Void
    
    init(isFavorite: Bool, onToggle: @escaping () async throws -> Void) {
        self._isFavorite = State(initialValue: isFavorite)
        self.onToggle = onToggle
    }
    
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await onToggle()
                    isFavorite.toggle()
                } catch {
                    print("Error toggling favorite: \(error)")
                }
            }
        }) {
            Image(systemName: isFavorite ? "xmark" : "plus")
                .foregroundColor(.black)
                .font(.system(size: 20, weight: .bold))
                .frame(width: 24, height: 24)
                .background(Color.white.opacity(1))
                .clipShape(Circle())
        }
    }
}

//#Preview {
//    FavoriteToggleButton()
//}
