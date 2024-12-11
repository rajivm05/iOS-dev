//
//  GridView.swift
//  Weather Demo
//
//  Created by Rajiv Murali on 12/10/24.
//

import SwiftUI

struct GridView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    var body: some View {
        ZStack {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                if let currentWeather = weatherViewModel.weatherData?.weatherData.data.timelines[0].intervals[0].values {
                    WeatherMetricBox(
                        icon: "WindSpeed",
                        value: "\(String(format: "%.2f", currentWeather.windSpeed)) mph",
                        label: "Wind Speed"
                    )
                    
                    WeatherMetricBox(
                        icon: "Pressure",
                        value: "\(String(format: "%.2f", currentWeather.pressureSurfaceLevel)) inHG",
                        label: "Pressure"
                    )
                    
                    WeatherMetricBox(
                        icon: "Precipitation",
                        value: "\(Int(currentWeather.precipitationProbability))%",
                        label: "Precipitation"
                    )
                    
                    WeatherMetricBox(
                        icon: "Temperature",
                        value: "\(Int(currentWeather.temperature))°F",
                        label: "Temperature"
                    )
                    
                    WeatherMetricBox(
                        icon: weatherViewModel.weatherData?.getWeatherStatus(code: currentWeather.weatherCode) ?? "",
                        value: "",
                        label: weatherViewModel.weatherData?.getWeatherStatus(code: currentWeather.weatherCode) ?? ""
                    )
                    
                    WeatherMetricBox(
                        icon: "Humidity",
                        value: "\(Int(currentWeather.humidity))%",
                        label: "Humidity"
                    )
                    
                    WeatherMetricBox(
                        icon: "Visibility",
                        value: "\(String(format: "%.2f", currentWeather.visibility)) mi",
                        label: "Visibility"
                    )
                    
                    WeatherMetricBox(
                        icon: "CloudCover",
                        value: "\(Int(currentWeather.cloudCover))%",
                        label: "Cloud Cover"
                    )
                    
                    WeatherMetricBox(
                        icon: "UVIndex",
                        value: "\(currentWeather.uvIndex ?? 0)",
                        label: "UV Index"
                    )
                }
            }
            .padding()
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Image("App_background").resizable().aspectRatio(contentMode:.fill)
//            .edgesIgnoringSafeArea(.bottom)
            )
    }
}

struct WeatherMetricBox: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack {
            Image(icon).resizable().aspectRatio(contentMode: .fit)
                .padding(.bottom, 18)
            Text(value)
                .font(.system(size: 16, weight: .medium)).padding(.bottom, 1)
            Text(label)
                .font(.system(size: 14, weight: .medium))
        }
        .frame(maxWidth: .infinity)
        .frame(height:120)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.4))
        )
    }
}


#Preview {
    GridView().environmentObject(WeatherViewModel())
}
