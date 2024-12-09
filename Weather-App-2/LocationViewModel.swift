//
//  LocationViewModel.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/8/24.
//
import Foundation
class LocationViewModel: ObservableObject {
    @Published var coordinate: LocationCoordinate
    @Published var formattedAddress: String
    @Published var isLoading: Bool
    @Published var errorMessage: String?
    @Published var weatherViewModel : WeatherViewModel
    
    private let geocodingService = GeocodingService.shared
//    private let weatherService = WeatherService.shared
    
    init() {
        self.coordinate = LocationCoordinate(latitude: 0.0, longitude: 0.0)
        self.formattedAddress = ""
        self.isLoading = false
        self.weatherViewModel = WeatherViewModel()
    }
    
    func updateLocation(latitude: Double, longitude: Double) {
        self.coordinate = LocationCoordinate(latitude: latitude, longitude: longitude)
        fetchAddress()
    }
    
    private func fetchAddress() {
        isLoading = true
        errorMessage = nil
        
        geocodingService.reverseGeocode(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let address):
                    self?.formattedAddress = address
                    self?.weatherViewModel.fetchWeather(
                        latitude:self?.coordinate.latitude ?? 0.0,
                        longitude: self?.coordinate.longitude ?? 0.0
                    )
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func geocodeAddress(address: String) {
        isLoading = true
        errorMessage = nil
        
        geocodingService.geocodeAddress(address: address) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let coordinates):
                    self?.coordinate = LocationCoordinate(
                        latitude: coordinates.lat,
                        longitude: coordinates.lng
                    )
                    self?.formattedAddress = address
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
