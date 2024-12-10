//
//  WeatherViewModel.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/8/24.
//
import SwiftyJSON
import Foundation

import SwiftyJSON

class WeatherViewModel: ObservableObject {
    @Published var weatherData:WeatherResponse?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let weatherService = WeatherService.shared
    
    func loadLocalWeatherData() {
            if let path = Bundle.main.path(forResource: "weatherResponse", ofType: "json"),
               let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                do {
                    let decoder = JSONDecoder()
                    let weather = try decoder.decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.weatherData = weather
                    }
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    
    func fetchWeather(latitude:Double, longitude:Double){
        print("Fetching weather in weatherViewModel")
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let data = try await weatherService.fetchWeatherData(latitude: latitude, longitude: longitude)
                print("Raw API Response received")
                
                let decoder = JSONDecoder()
                let weather = try decoder.decode(WeatherResponse.self, from:data)
                
                print("Weather Data Parsed Successfully:")
                print("Number of timelines: \(weather.weatherData.data.timelines.count)")
                
                if let firstTimeline = weather.weatherData.data.timelines.first {
                    print("Timeline step: \(firstTimeline.timestep)")
                    print("Number of intervals: \(firstTimeline.intervals.count)")
                    
                    if let firstInterval = firstTimeline.intervals.first {
                        print("First interval data:")
                        print("- Temperature: \(firstInterval.values.temperature)°")
                        print("- Humidity: \(firstInterval.values.humidity)%")
                        print("- Wind Speed: \(firstInterval.values.windSpeed) mph")
                    }
                }
                
                DispatchQueue.main.async{
                    self.weatherData = weather
                    self.isLoading = false
                    print("Dispatched Data")
                }
            }
            catch{
                DispatchQueue.main.async{
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
