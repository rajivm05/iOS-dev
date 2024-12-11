//
//  WeeklySummaryCard.swift
//  Weather Demo
//
//  Created by Rajiv Murali on 12/10/24.
//

import SwiftUI

struct WeeklySummaryCard: View {
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(.thinMaterial)
                .shadow(radius: 5)
            if let weatherData = weatherViewModel.weatherData,
               let currentWeather = weatherData.weatherData.data.timelines.first?.intervals.first?.values{
                VStack(alignment: .leading, spacing: 8){
                    HStack(spacing: 20){
                        
                        Image("\(weatherData.getWeatherStatus(code: currentWeather.weatherCode))").font(.system(size: 80, weight: .medium))
                        Spacer()
                        VStack(alignment: .leading, spacing: 15){
                            Text("\(weatherData.getWeatherStatus(code: currentWeather.weatherCode))").font(.system(size: 28))
                                .padding(.bottom, 20)
                            Text("\(Int(currentWeather.temperature))°F")
                                .font(.system(size: 36, weight: .medium))
                            
                            
                        }
                        Spacer()
                        
                    }
                    
                }
                .padding()
            }
        }
        .frame(height: 150 )
    }
}

#Preview {
    WeeklySummaryCard().environmentObject(WeatherViewModel())
}
