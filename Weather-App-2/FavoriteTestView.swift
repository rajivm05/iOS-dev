//
//  FavoriteTestView.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/11/24.
//

import SwiftUI

struct FavoriteTestView: View {
    private var favoriteFunctions = FavoriteFunctions()
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    var body: some View {
        VStack(spacing: 20) {
            Button("Fetch Favorites") {
                Task {
                    do {
                        let favorites = try await favoriteFunctions.fetchFavorites()
                        print("Successfully fetched favorites:")
                        favorites.result.forEach { favorite in
                            print("Address: \(favorite.formattedAddress)")
                            print("Coordinates: \(favorite.lat), \(favorite.lng)")
//                            print("Raw: \(favorite.rawData)")
                            print("------------------------")
                        }
                    } catch {
                        print("Error fetching favorites: \(error)")
                    }
                }
            }
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)
            
            Button("Add Favorite") {
                Task {
                    do {
                        // Sample data matching screenshot format
                        try await favoriteFunctions.addFavorite(
                            formattedAddress: "Los Angeles, CA",
                            rawData: weatherViewModel.weatherData!,
                            lat: "34.0522",
                            lng: "-118.2437"
                        )
                        print("Successfully added favorite: Los Angeles")
                    } catch {
                        print("Error adding favorite: \(error)")
                    }
                }
            }
            .padding()
            .background(Color.green.opacity(0.2))
            .cornerRadius(10)
            
            Button("Delete Favorite") {
                Task {
                    do {
                        try await favoriteFunctions.deleteFavorite(
                            lat: "34.0522",
                            lng: "-118.2437"
                        )
                        print("Successfully deleted favorite: Los Angeles")
                    } catch {
                        print("Error deleting favorite: \(error)")
                    }
                }
            }
            .padding()
            .background(Color.red.opacity(0.2))
            .cornerRadius(10)
        }
        .padding()
        .onAppear(){
            weatherViewModel.loadLocalWeatherData()
        }
    }
}

#Preview {
    FavoriteTestView().environmentObject(WeatherViewModel())
}
