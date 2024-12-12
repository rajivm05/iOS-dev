//
//  FavoritePageView.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/12/24.
//

import SwiftUI
import Alamofire



struct FavoritePageView: View {
    @State private var isFavorite: Bool = true
    private var bible: FavoriteModel
    var favoriteFunctions:FavoriteFunctions = FavoriteFunctions()
    init(bible:FavoriteModel){
        self.bible = bible
        
    }
    var body: some View {
        if let weatherResponse = try? bible.getWeatherData() {
            if let currentWeather = weatherResponse.weatherData.data.timelines.first?.intervals.first?.values{
                VStack(spacing:20){
                    HStack{
                        Spacer()
                        FavoriteToggleButton(isFavorite: isFavorite, onToggle: {
                            Task{
                               try await favoriteFunctions.toggleDataFromFavorites(bible: bible, isFavorite: isFavorite)
                                isFavorite.toggle()
                            }
                            
                        })
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.thinMaterial)
                            .shadow(radius: 5)
                        VStack(alignment: .leading, spacing: 8){
                            HStack(spacing: 20){
                                Image("\(getWeatherStatus(code: currentWeather.weatherCode))").font(.system(size: 80, weight: .medium))
                                VStack(alignment: .leading, spacing: 15){
                                    Text("\(Int(currentWeather.temperature))°F")
                                        .font(.system(size: 36, weight: .medium))
                                    
                                    Text("\(getWeatherStatus(code: currentWeather.weatherCode))").font(.title3)
                                    //need to add formatted Text here
                                    Text(extractCity(from: bible.formattedAddress)).font(.title3).bold()
                                }
                                Spacer()
                                
                            }
                            
                        }
                        .padding()
                    }.frame(height: 150 )
                    HStack(spacing: 20) {
                        WeatherMetricItem(icon: "Humidity", value: "\(Int(currentWeather.humidity))%", label: "Humidity")
                        WeatherMetricItem(icon: "WindSpeed", value: "\(currentWeather.windSpeed) mph", label: "Wind Speed")
                        WeatherMetricItem(icon: "Visibility", value: "\(currentWeather.visibility) mi", label: "Visibility")
                        WeatherMetricItem(icon: "Pressure", value: "\(currentWeather.pressureSurfaceLevel) inHg", label: "Pressure")
                    }
                    ZStack{
                        if let allForecast = weatherResponse.weatherData.data.timelines.first?.intervals{
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
                .padding(.all, 16)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(
                    Image("App_background")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                )
            }
        }

    }
}

//#Preview {
//    FavoritePageView()
//}
