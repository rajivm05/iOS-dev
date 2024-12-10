//
//  LocationService.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/8/24.
//
import CoreLocation
import SwiftUI
import Combine

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var coordinate: LocationCoordinate
    @Published var locationViewModel: LocationViewModel
    
    private let geocodingService = GeocodingService.shared
//    private let weatherViewModel:WeatherViewModel
    
    init(weatherViewModel:WeatherViewModel) {
        self.coordinate = LocationCoordinate(latitude: 0.0, longitude: 0.0)
        self.locationViewModel = LocationViewModel(weatherViewModel: weatherViewModel)
        super.init()
        setupLocationManager()
        setupLocationBinding()
    }
    
    private func setupLocationBinding(){
            self.$coordinate.sink{ [weak self] newCoordinate in
                print("Coordinate changed to: \(newCoordinate.latitude), \(newCoordinate.longitude)")
                self?.locationViewModel.updateLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            }
            .store(in: &cancellables)
        }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        print("Location manager setup completed")
    }
    
    func startUpdatingLocation() {
            print("Starting location updates...")
            
            // Check authorization status
            let authStatus = locationManager.authorizationStatus
            print("Current authorization status: \(authStatus.rawValue)")
            
            if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways {
                locationManager.startUpdatingLocation()
                print("Location updates started")
            } else {
                print("Location authorization not granted")
                locationManager.requestWhenInUseAuthorization()
            }
        }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            print("Received location update: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            
            coordinate = LocationCoordinate(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            
            // Call reverse geocoding here
            geocodingService.reverseGeocode(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            ) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let address):
                        print("Address found: \(address)")
                        self?.locationViewModel.formattedAddress = address
                    case .failure(let error):
                        print("Geocoding error: \(error.localizedDescription)")
                    }
                }
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
