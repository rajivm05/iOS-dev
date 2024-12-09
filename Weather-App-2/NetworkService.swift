//
//  NetworkService.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/8/24.
//

import Foundation
import Alamofire


enum WeatherError:Error{
    case invalidURL
    case networkError(String)
}

class WeatherService{
    static let shared = WeatherService()
    private let baseURL = Config.shared.serverURL
    
    private init(){}
    
    func fetchWeatherData(latitude:Double, longitude:Double) async throws -> Data{
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw WeatherError.invalidURL
        }
        
        urlComponents.path = "/weatherAPI"
        urlComponents.queryItems = [
            URLQueryItem(name:"lat", value:String(latitude)),
            URLQueryItem(name:"lng", value:String(longitude)),
            URLQueryItem(name:"formattedAddress", value:"")
        ]
        guard let url = urlComponents.url else{
            throw WeatherError.invalidURL
        }
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(Config.shared.serverKey)"
        ]
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: .get,
                parameters: nil,
                encoding: URLEncoding.default,
                headers: headers
            )
            .validate()
            .responseData{
                response in
                switch response.result{
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing : WeatherError.networkError(error.localizedDescription))
                }
            }
        }
    }
}

class GeocodingService{
    static let shared = GeocodingService()
    private init(){}
    
    func geocodeAddress(address: String, completion: @escaping (Result<(lat: Double, lng: Double), Error>) -> Void) {
        let baseURL = "https://maps.googleapis.com/maps/api/geocode/json"
        let parameters: [String: Any] = [
            "address": address,
            "key": Config.shared.googleMapsKey
        ]
        
        AF.request(
            baseURL,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default
        ).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let firstResult = results.first,
                   let geometry = firstResult["geometry"] as? [String: Any],
                   let location = geometry["location"] as? [String: Any],
                   let lat = location["lat"] as? Double,
                   let lng = location["lng"] as? Double {
                    completion(.success((lat: lat, lng: lng)))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func reverseGeocode(latitude:Double, longitude: Double, completion: @escaping (Result<String, Error>) -> Void){
        let baseURL = Config.shared.googleMapsBaseURL
        let parameters: [String:Any] = [
            "latlng":"\(latitude),\(longitude)",
            "key": Config.shared.googleMapsKey
        ]
        
        AF.request(
            baseURL,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default
        ).responseJSON{
            response in switch response.result{
            case .success(let value):
                if let json = value as? [String: Any],
                       let results = json["results"] as? [[String: Any]],
                       let firstResult = results.first {
                        
                        // Try to get city and state first
                        if let addressComponents = firstResult["address_components"] as? [[String: Any]] {
                            var locality = ""
                            var state = ""
                            
                            for component in addressComponents {
                                if let types = component["types"] as? [String],
                                   let longName = component["long_name"] as? String {
                                    if types.contains("locality") {
                                        locality = longName
                                    } else if types.contains("administrative_area_level_1") {
                                        state = longName
                                    }
                                }
                            }
                            
                            if !locality.isEmpty && !state.isEmpty {
                                let formattedAddress = "\(locality), \(state)"
                                completion(.success(formattedAddress))
                                return
                            }
                        }
                        
                        // Fallback to Google's formatted address
                        if let googleFormattedAddress = firstResult["formatted_address"] as? String {
                            completion(.success(googleFormattedAddress))
                        } else {
                            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                        }
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                    }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
