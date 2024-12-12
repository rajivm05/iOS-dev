//
//  SearchService.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/11/24.
//

import Foundation
import MapKit

class SearchService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchResults: [LocationResult] = []
    private var completer: MKLocalSearchCompleter
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
    }
    
    func getCoordinates(for address: String) async throws -> CLLocationCoordinate2D {
            let geocoder = CLGeocoder()
            let placemarks = try await geocoder.geocodeAddressString(address)
            
            guard let location = placemarks.first?.location?.coordinate else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Location not found"])
            }
            return location
        }
    
    func searchLocation(_ query: String) {
        completer.queryFragment = query
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.searchResults = completer.results.map { result in
                LocationResult(
                    id: UUID(),
                    title: result.title,
                    subtitle: result.subtitle
                )
            }
        }
    }
}

// Location Result model
struct LocationResult: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
}
