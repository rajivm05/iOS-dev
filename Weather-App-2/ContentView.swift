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
    private var favoriteFunctions = FavoriteFunctions()
    
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
                            do{
                                favorites = try await favoriteFunctions.fetchFavorites()
                                print("Printing Favorites:")
                            }
                            catch{
                                print("Error fetching favorites")
                            }
                        }
                    }
            } else {
//                TabView{
//                    NavigationStack {
//                        ContentView_()
//                    }.tag(0)
//                    FavoriteTestView().tag(1)
//                }
//                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                ContentView_()
            }
            
    }
}

#Preview {
    ContentView()
        .environmentObject(LocationViewModel(weatherViewModel: WeatherViewModel()))
        .environmentObject(WeatherViewModel())
}
