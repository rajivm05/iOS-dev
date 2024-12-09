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
    @EnvironmentObject private var locationService:LocationService
    @EnvironmentObject private var viewModel: LocationViewModel
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    
    var body: some View {
        Group {
                    if showSplash {
                        LaunchUI()
                    } else {
                        Group{
                            Text("Coordinates")
                            Text("Latitude:\(viewModel.coordinate.latitude, specifier: "%.6f")")
                            Text("Longitude:\(viewModel.coordinate.longitude, specifier: "%.6f")")
                        }
                        Group {
                            Text("Address").font(.headline)
                            Text(viewModel.formattedAddress).multilineTextAlignment(.center)
                        }
                        Group{
                            if let weatherData = weatherViewModel.weatherData{
                                Text("Temperature: \(weatherData.weatherData.data.timelines[0].intervals[0].values.temperature)")
                            }
                            else{
                                Text("Loading weather data")
                            }
                        }
                    }
                }
                .onAppear {
                    // Timer to hide the splash screen after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showSplash = false
                        }
                        print(viewModel.formattedAddress)
                        print(viewModel.coordinate)
                    }
                }
    }
}

#Preview {
    ContentView()
}
