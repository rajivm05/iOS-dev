//
//  WeatherMetrics.swift
//  Weather Demo
//
//  Created by Rajiv Murali on 12/9/24.
//

import SwiftUI

struct WeatherMetrics: View {
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    var body: some View {
        if let weatherData = weatherViewModel.weatherData,
           let currentWeather = weatherData.weatherData.data.timelines.first?.intervals.first?.values{
            HStack(spacing: 20) {
                WeatherMetricItem(icon: "Humidity", value: "\(Int(currentWeather.humidity))%", label: "Humidity")
                WeatherMetricItem(icon: "WindSpeed", value: "\(currentWeather.windSpeed) mph", label: "Wind Speed")
                WeatherMetricItem(icon: "Visibility", value: "\(currentWeather.visibility) mi", label: "Visibility")
                WeatherMetricItem(icon: "Pressure", value: "\(currentWeather.pressureSurfaceLevel) inHg", label: "Pressure")
                    }
        }
    }
    
}

struct WeatherMetricItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing:20) {
            Text(label)
                .font(.system(size: 14))
            Image(icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48)
            Text(value)
                .font(.system(size: 16))
            
        }
        
    }
}

#Preview {
    WeatherMetrics().environmentObject(WeatherViewModel())
}
