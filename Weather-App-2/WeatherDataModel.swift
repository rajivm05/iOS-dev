//
//  WeatherDataModel.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/8/24.
//

import Foundation

struct WeatherResponse:Codable{
    let weatherData:WeatherDataContainer
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
