//
//  Weather_App_2App.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/8/24.
//

import SwiftUI

@main
struct Weather_App_2App: App {
    @StateObject private var locationService = LocationService()
    @StateObject private var weatherViewModel = WeatherViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationService)
                .environmentObject(locationService.locationViewModel)
                .environmentObject(weatherViewModel)
        }
    }
}
