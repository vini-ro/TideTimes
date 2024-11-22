import CoreLocation
import SwiftUI
import MapKit

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var searchResults: [Location] = []
    @Published var selectedLocation: Location?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        manager.delegate = self
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func searchLocations(_ query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        searchCompleter.queryFragment = query
    }
    
    func saveSelectedLocation() {
        guard let location = selectedLocation else { return }
        UserDefaults.standard.encode(location, forKey: "savedLocation")
    }
    
    func loadSavedLocation() {
        selectedLocation = UserDefaults.standard.decode(Location.self, forKey: "savedLocation")
    }
    
    private func convertToLocation(_ mapItem: MKMapItem) -> Location {
        Location(
            id: UUID(),
            name: mapItem.name ?? "Unknown Location",
            latitude: mapItem.placemark.coordinate.latitude,
            longitude: mapItem.placemark.coordinate.longitude
        )
    }
    
    private func performSearch(for result: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        
        Task { @MainActor in
            do {
                let response = try await search.start()
                if let firstItem = response.mapItems.first {
                    let location = convertToLocation(firstItem)
                    if !searchResults.contains(where: { $0.id == location.id }) {
                        searchResults.append(location)
                    }
                }
            } catch {
                print("Search failed with error: \(error.localizedDescription)")
            }
        }
    }
}

extension LocationManager: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = [] // Clear previous results
        completer.results.forEach { result in
            performSearch(for: result)
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Location search failed with error: \(error.localizedDescription)")
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
} 