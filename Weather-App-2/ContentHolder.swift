//
//  ContentHolder.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/11/24.
//

import SwiftUI


struct ContentView_: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @State private var searchText: String = ""
    @StateObject private var searchService = SearchService()
    @State private var showSearchResults = false
    @State private var selectedLocation: String?
    @EnvironmentObject private var viewModel: LocationViewModel
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Background
                Image("App_background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                // Main Content
                VStack(spacing: 0) {
                    // Search Bar
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
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(100)
                    .padding(.horizontal)
                    SummaryCompile()
                    
                }.padding()
                
                // Search Results Overlay
                if !searchText.isEmpty {
                    VStack {
                        Spacer().frame(height: 50)
                        List(searchService.searchResults) { result in
                            Button(action: {
                                selectedLocation = result.title
                                showSearchResults = true
                                Task{
                                    await loadLocationWeather(result: result)
                                }
                                
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
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                    }
                }
                
                // Navigation link
                NavigationLink(
                    destination: SearchResultView(),
                    isActive: $showSearchResults
                ) {
                    EmptyView()
                }
            }
        }
//        .onAppear {
//            weatherViewModel.loadLocalWeatherData()
//        }
    }
    func loadLocationWeather(result: LocationResult) async {
            // Extract city from address
            let city = extractCity(from: result.title)
            print("result.title: \(result.title)")
            print("City \(city)")
            
            // Get coordinates
//            let coordinates = try await searchService.getCoordinates(for: result.title)
//            print("Coordinates found \(coordinates)")
            
        // Clear search
//        searchText = ""
//        showSearchResults = false
        viewModel.geocodeAddress(address: result.title)
            
//            weatherViewModel.loadLocalWeatherData()
            
//            viewModel.weatherViewModel?.fetchWeatherData(
//                latitude: coordinates.latitude,
//                longitude: coordinates.longitude
//            )
            
            
    }
}




