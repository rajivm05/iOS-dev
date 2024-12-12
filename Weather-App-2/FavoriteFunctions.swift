//
//  FavoriteFunctions.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/11/24.
//

import Foundation

import Alamofire
class FavoriteFunctions:ObservableObject {
    // Store API endpoint
    @Published var favorites:FavResult?
    
    private let baseURL = Config.shared.serverURL
    private var headers: HTTPHeaders {
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(Config.shared.serverKey)"
            ]
        }
    // Fetch all favorites
//    func fetchFavorites() async throws -> FavResult {
//        
//        return try await withCheckedThrowingContinuation { continuation in
//                    AF.request("\(baseURL)/fetchData",
//                              method: .get,
//                              headers: headers)
//                        .responseDecodable(of: FavResult.self) { response in
//                            switch response.result {
//                            case .success(let favorites):
//                                continuation.resume(returning: favorites)
//                            case .failure(let error):
//                                print("response: \(response)")
//                                continuation.resume(throwing: error)
//                            }
//                        }
//                }
//    }
    func fetchFavorites() async throws {
            let result = try await withCheckedThrowingContinuation { continuation in
                AF.request("\(baseURL)/fetchData",
                          method: .get,
                          headers: headers)
                    .responseDecodable(of: FavResult.self) { response in
                        switch response.result {
                        case .success(let favorites):
                            continuation.resume(returning: favorites)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
            }
            
            // Update the published property on the main thread
            DispatchQueue.main.async {
                self.favorites = result
            }
        }
    
    // Add favorite
    func addFavorite(formattedAddress: String, rawData: WeatherResponse, lat:String, lng:String) async throws {
//        guard let url = URL(string: "\(baseURL)/addData") else {
//            throw URLError(.badURL)
//        }
        // Create favorite object
        
        
        let jsonData = try! JSONEncoder().encode(rawData)
        let jsonString = String(data: jsonData, encoding: .utf8)!
//        print(jsonString)
        let favorite = [
            "formattedAddress": formattedAddress,
            "lat":lat,
            "lng":lng,
            "city":"",
            "state":"",
            "rawData":jsonString
        ] as [String : String]
//        try print(JSONEncoder().encode(rawData))
        return try await withCheckedThrowingContinuation { continuation in
                    AF.request("\(baseURL)/addData",
                              method: .post,
                               parameters: favorite,
                               encoding: JSONEncoding(),
                              headers: headers)
                        .response { response in
                            if let error = response.error {
                                continuation.resume(throwing: error)
                            } else {
                                continuation.resume()
                            }
                        }
                }
    }
    
    // Delete favorite
    func deleteFavorite(lat:String, lng:String) async throws {
        guard let url = URL(string: "\(baseURL)/removeData") else {
            throw URLError(.badURL)
        }
        let parameters = [
            "lat":lat,
            "lng":lng,
        ] as [String : Any]
        
        return try await withCheckedThrowingContinuation { continuation in
                    AF.request("\(baseURL)/removeData",
                               method: .post,
                               parameters: parameters,
                               encoding: JSONEncoding(),
                              headers: headers)
                        .response { response in
                            if let error = response.error {
                                continuation.resume(throwing: error)
                            } else {
                                continuation.resume()
                            }
                        }
                }
    }
    func addFavoriteFromFavorite(bible:FavoriteModel) async throws{
        let favorite = [
            "formattedAddress": bible.formattedAddress,
            "lat":bible.lat,
            "lng":bible.lng,
            "city":"",
            "state":"",
            "rawData":bible.rawData
        ] as [String : String]
        return try await withCheckedThrowingContinuation { continuation in
                    AF.request("\(baseURL)/addData",
                              method: .post,
                               parameters: favorite,
                               encoding: JSONEncoding(),
                              headers: headers)
                        .response { response in
                            if let error = response.error {
                                continuation.resume(throwing: error)
                            } else {
                                continuation.resume()
                            }
                        }
                }
    }
    func toggleDataFromFavorites(bible:FavoriteModel, isFavorite:Bool) async throws{
        if isFavorite {
            try await deleteFavorite(lat:bible.lat, lng:bible.lng)
        } else {
            try await addFavoriteFromFavorite(bible:bible)
        }
    }
    
}

