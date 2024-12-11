//
//  SummaryCard.swift
//  Weather Demo
//
//  Created by Rajiv Murali on 12/9/24.
//

import SwiftUI

struct SummaryCard: View {
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    @EnvironmentObject private var viewModel: LocationViewModel
    @State private var navigateToDetails = false
    
    var body: some View {
        NavigationLink(destination:WeatherDetailsView(), isActive:$navigateToDetails) {
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .fill(.thinMaterial)
                    .shadow(radius: 5)
                if let weatherData = weatherViewModel.weatherData,
                   let currentWeather = weatherData.weatherData.data.timelines.first?.intervals.first?.values{
                    VStack(alignment: .leading, spacing: 8){
                        HStack(spacing: 20){
                            
                            Image("\(weatherData.getWeatherStatus(code: currentWeather.weatherCode))").font(.system(size: 80, weight: .medium))
                            VStack(alignment: .leading, spacing: 15){
                                Text("\(Int(currentWeather.temperature))°F")
                                    .font(.system(size: 36, weight: .medium))
                                
                                Text("\(weatherData.getWeatherStatus(code: currentWeather.weatherCode))").font(.title3)
                                //need to add formatted Text here
                                Text(extractCity(from: viewModel.formattedAddress)).font(.title3).bold()
                            }
                            Spacer()
                            
                        }
                        
                    }
                    .padding()
                }
            }
            .frame(height: 150 )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SummaryCard().environmentObject(WeatherViewModel())
}

func extractCity(from address: String) -> String {
    // Split the address by comma and get the first part (city)
    let components = address.components(separatedBy: ", ")
    return components.first ?? ""
}
