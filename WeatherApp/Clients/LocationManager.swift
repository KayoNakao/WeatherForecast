//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Kayo on 2025-03-27.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdatesLocation(_ location: CLLocation)
}

class LocationManager: NSObject {
    
    weak var delegate: LocationManagerDelegate?
    private let locationManger = CLLocationManager()
    
    override init() {
        super.init()
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
    }

}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        delegate?.didUpdatesLocation(location)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location has been approved")
            locationManger.requestLocation()
        case .denied, .restricted:
            print("Location access denied/restricted")
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        @unknown default:
            print("Location access unknown")
        }
    }
}
