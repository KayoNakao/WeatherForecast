//
//  Weather.swift
//  WeatherApp
//
//  Created by Kayo on 2025-03-27.
//

import Foundation

struct Weather: Decodable {
    let location: Location
    let current: Current
    let forecast: [String: Forecast]
    
    struct Location: Decodable {
        let name: String
        let country: String
    }
    
    struct Current: Decodable {
        let observation_time: String
        let temperature: Int
        let weather_icons: [String]
        let weather_descriptions: [String]
        let feelslike: Int
    }
    
    struct Astro: Decodable {
        let sunrise: String
        let sunset: String
    }
    
    struct Forecast: Decodable {
        let mintemp: Int
        let maxtemp: Int
        let avgtemp: Int
        let astro: Astro
    }
}
