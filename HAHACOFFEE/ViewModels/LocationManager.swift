//
//  LocationManager.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 14/1/25.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestAuthorization()
    }

    private func requestAuthorization() {
        // Check the current authorization status
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access restricted or denied.")
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            print("Unknown location authorization status.")
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
            switch manager.authorizationStatus {
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                print("Location access denied. Please enable location permissions in settings.")
            case .authorizedWhenInUse, .authorizedAlways:
                self.locationManager.startUpdatingLocation()
            @unknown default:
                print("Unknown location authorization status.")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                self.userLocation = location
                // Log the latitude and longitude for debugging
                print("User Location - Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            }
        } else {
            print("No locations found in the update.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting user location: \(error.localizedDescription)")
    }
}

extension LatnLon {
    func calculateNearestStore(userLocation: CLLocation) -> LatnLon_Store? {
        guard !lat_lon_store.isEmpty else {
            print("No stores available for calculation.")
            return nil
        }

        return lat_lon_store.min(by: { store1, store2 in
            let distance1 = CLLocation(latitude: store1.Lat, longitude: store1.Lon).distance(from: userLocation)
            let distance2 = CLLocation(latitude: store2.Lat, longitude: store2.Lon).distance(from: userLocation)
            return distance1 < distance2
        })
    }
}



