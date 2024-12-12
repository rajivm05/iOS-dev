//
//  ForecastTable.swift
//  Weather Demo
//
//  Created by Rajiv Murali on 12/9/24.
//

import SwiftUI

struct ForecastTable: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    var body: some View {
        ZStack{
            if let weatherData = weatherViewModel.weatherData,
               let allForecast = weatherData.weatherData.data.timelines.first?.intervals{
                VStack{
                    ForEach(allForecast.prefix(6), id:\.startTime){
                        interval in HStack{
                            Text(formatDateTime(interval.startTime).date).padding(.horizontal)
                            Image(getWeatherStatus(code: interval.values.weatherCode))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                            Text(formatDateTime(interval.values.sunriseTime).time)
                            Image("sun-rise")
                            Text(formatDateTime(interval.values.sunsetTime).time)
                            Image("sun-set")
                        }.font(.system(size: 12))
                        .padding(.vertical, 8)
                        Divider()
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15).fill(.thinMaterial)
                )
            }
        }
        }
    
        
}

func formatDateTime(_ dateString:String) -> (date:String, time:String){
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return ("Invalid Date", "Invalid Time")
        }
        
        // Format date as MM/dd/yyyy
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        
        // Format time as h:mm a (e.g., 6:30 PM)
        dateFormatter.dateFormat = "h:mm a"
        let formattedTime = dateFormatter.string(from: date)
        
        return (formattedDate, formattedTime)
}

#Preview {
    ForecastTable()
}
