//
//  HTTPClient.swift
//  WeatherApp
//
//  Created by Kayo on 2025-03-27.
//

import Foundation

enum Endpoints {
    case current(String)
    case forecast(String)
    

    var stringUrl: String {
        switch self {
        case .current(let city):
            return HTTPClient.baseURL + "current?access_key=\(HTTPClient.apiKey)&query=\(city)&units=m"
        case .forecast(let city):
            return HTTPClient.baseURL + "forecast?access_key=\(HTTPClient.apiKey)&query=\(city)&units=m"
        }
    }
}

struct HTTPClient {
    
    static let baseURL = "https://api.weatherstack.com/"

    static var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            print("No key found")
            return ""
        }
            return key
    }
    
    
    static func fetchWeather(of endpoint: Endpoints) async throws -> Weather?  {
        guard let url = URL(string: endpoint.stringUrl) else {
            return nil
        }
        let request = URLRequest(url: url)
        print(url)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            print(response.statusCode)
            let weather = try JSONDecoder().decode(Weather.self, from: data)
            return weather
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
