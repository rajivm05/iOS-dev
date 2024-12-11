//
//  WeatherDataModel.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/8/24.
//

import Foundation

struct WeatherResponse:Codable{
    let weatherData:WeatherDataContainer
    private let weatherCodes: [Int: String] = [
        4201: "Heavy Rain",
        4001: "Rain",
        4200: "Light Rain",
        6201: "Heavy Freezing Rain",
        6001: "Freezing Rain",
        6000: "Light Freezing Rain",
        4000: "Drizzle",
        7101: "Heavy Ice Pallets",
        7000: "Ice Pallets",
        7102: "Light Ice Pallets",
        5101: "Heavy Snow",
        5000: "Snow",
        5100: "Light Snow",
        5001: "Flurries",
        8000: "Thunderstorm",
        2100: "Light Fog",
        2000: "Fog",
        1001: "Cloudy",
        1102: "Mostly Cloudy",
        1101: "Partly Cloudy",
        1100: "Mostly Clear",
        1000: "Clear"
    ]

    func getWeatherStatus(code: Int) -> String {
        return weatherCodes[code] ?? "Unknown"
    }
}

struct WeatherDataContainer: Codable {
    let data: WeatherDataContent
}

struct WeatherDataContent: Codable {
    let timelines: [Timeline]
    let warnings: [Warning]?
}

struct Timeline: Codable {
    let timestep: String
    let endTime: String
    let startTime: String
    let intervals: [Interval]
}

struct Interval: Codable {
    let startTime: String
    let values: WeatherValues
}

struct WeatherValues: Codable {
    let cloudCover: Double
    let humidity: Double
    let precipitationProbability: Double
    let precipitationType: Int
    let pressureSurfaceLevel: Double
    let sunriseTime: String
    let sunsetTime: String
    let temperature: Double
    let temperatureApparent: Double
    let uvIndex: Int?
    let visibility: Double
    let weatherCode: Int
    let windDirection: Double
    let windSpeed: Double
}
struct Warning: Codable {
    let code: Int
    let type: String
    let message: String
    let meta: WarningMeta
}

struct WarningMeta: Codable {
    let field: String
    let from: String
    let to: String
}


