//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Kayo on 2025-03-27.
//

import Foundation
import CoreLocation

class HomeViewModel {
    
    func getWeatherForecast(from location: CLLocation) async throws -> Weather {
        do {
            let cityName = try await getCity(from: location)
            let weather = try await fetchWeather(for: Endpoints.forecast(cityName))
            return weather
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    private func getCity(from location: CLLocation) async throws -> String {
        let geocorder = CLGeocoder()
        do {
            let placemarks = try await geocorder.reverseGeocodeLocation(location)
            guard let placemark = placemarks.first,
                  let cityName = placemark.locality else {
                throw NSError(domain: "GetCity", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Failed to get city name"])
            }
            return cityName
        } catch {
            throw error
        }
    }
    
    private func fetchWeather(for endpoint: Endpoints) async throws -> Weather {
        do {
            guard let weather = try await HTTPClient.fetchWeather(of: endpoint) else {
                throw NSError(domain: "WeatherFetch", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch current weather"])
            }
            return weather

        } catch {
            throw error
        }
    }
    
}

