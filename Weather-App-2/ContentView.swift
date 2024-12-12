//
//  ContentView.swift
//  Weather-App-ios
//
//  Created by Rajiv Murali on 12/2/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State private var showSplash = true
    @State private var favorites: FavResult?
    
    @EnvironmentObject private var locationService:LocationService
    @EnvironmentObject private var viewModel: LocationViewModel
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    @EnvironmentObject private var favoriteFunctions: FavoriteFunctions
    
    
    var body: some View {
            if showSplash {
                LaunchUI()
                    .onAppear {
                        weatherViewModel.loadLocalWeatherData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSplash = false
                            }
                            print(viewModel.formattedAddress)
                            print(viewModel.coordinate)
                        }
                        Task{
                            try await favoriteFunctions.fetchFavorites()
                        }
                        
                    }
            } else {
                NavigationStack {
                    TabView{
                        ContentView_().tag(0).onAppear(){
                            Task{
                                try await favoriteFunctions.fetchFavorites()
                            }
                        }
                        if let favorites = favoriteFunctions.favorites {
                            ForEach(favorites.result, id: \.formattedAddress) { favorite in
                                FavoritePageView(bible: favorite)
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    
                }
                
//                ContentView_()
            }
            
    }
}

#Preview {
    ContentView()
        .environmentObject(LocationViewModel(weatherViewModel: WeatherViewModel()))
        .environmentObject(WeatherViewModel())
}
