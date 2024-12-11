//
//  KeySubViewTop.swift
//  Weather Demo
//
//  Created by Rajiv Murali on 12/10/24.
//

import SwiftUI

struct KeySubViewTop: View {
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    var body: some View {
        HStack()
        {
            Spacer()
            LazyVGrid(columns: [
                GridItem(.flexible()),  // For icon
                GridItem(.flexible()),  // For text
                GridItem(.flexible())
                ], alignment: .leading, spacing: 12) {
                    if let currentWeather = weatherViewModel.weatherData?.weatherData.data.timelines[0].intervals[0].values {
                        // Precipitation row
                        Image("Precipitation")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 65, height: 65)
                        Text("Precipitation: ")
                        Text("\(Int(currentWeather.precipitationProbability))%")
                        
                        // Humidity row
                        Image("Humidity")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 65, height: 65)
                        Text("Humidity: ")
                        Text("\(Int(currentWeather.humidity))%")
                        
                        // Cloud Cover row
                        Image("CloudCover")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 65, height: 65)
                        Text("Cloud Cover: ")
                        Text("\(Int(currentWeather.cloudCover))%")
                    }
                }.padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.4))
        )
        .padding(.horizontal)
    }
}

#Preview {
    KeySubViewTop()
}
