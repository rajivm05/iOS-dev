//
//  OverviewView.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/9/24.
//

import SwiftUI

struct OverviewView: View {
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
//    init(){
//        weatherViewModel.loadLocalWeatherData()
//    }
    var body: some View {
        if let weatherData = weatherViewModel.weatherData{
            Text("Temperature: \(weatherData.weatherData.data.timelines[0].intervals[0].values.temperature)")
        }
        else{
            Text("Loading weather data")
        }
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        let weatherViewModel = WeatherViewModel()
        OverviewView()
            .environmentObject(LocationService(weatherViewModel: weatherViewModel))
            .environmentObject(weatherViewModel)
            .environmentObject(LocationViewModel(weatherViewModel: weatherViewModel))
    }
}

//#Preview {
//    OverviewView()
//}
