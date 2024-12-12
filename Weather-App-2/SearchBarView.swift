//
//  SearchBarView.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/11/24.
//

import SwiftUI

//struct SearchBarView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}

struct SearchBarView: View {
    @State private var searchText: String = ""
    @StateObject private var searchService = SearchService()
    @State private var showSearchResults = false
    @State private var selectedLocation: String?
    
    var body: some View {
        
        NavigationView {
                    // Custom search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search City", text: $searchText)
                            .onChange(of: searchText) { query in
                                if !query.isEmpty {
                                    searchService.searchLocation(query)
                                }
                            }
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                showSearchResults = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(8)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(10)
                    
                    // Search results overlay
                    if !searchText.isEmpty {
                        List(searchService.searchResults) { result in
                            Button(action: {
                                selectedLocation = result.title
                                showSearchResults = true
                            }) {
                                VStack(alignment: .leading) {
                                    Text(result.title)
                                        .foregroundColor(.primary)
                                    if !result.subtitle.isEmpty {
                                        Text(result.subtitle)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.white.opacity(0.2))
                        .frame(height: min(CGFloat(searchService.searchResults.count * 50), 200))
                    }
                    
                    // Navigation link to search results
                    NavigationLink(
                        destination: SearchResultView(),
                        isActive: $showSearchResults
                    ) {
                        EmptyView()
                    }
            }
            .navigationBarHidden(true)
        }
    
}

#Preview {
    SearchBarView()
}
