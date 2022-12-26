//
//  CurrentWeatherModel.swift
//  WeatherAppTest
//
//  Created by Демьян on 24.12.2022.
//
import Foundation

// MARK: - CurrentWeather

struct CurrentWeather: Codable {
    
    let location: Location?
    let current: Current?
    let forecast: Forecast?
}

// MARK: - Current

struct Current: Codable {
    
    let lastUpdatedEpoch: Int?
    let lastUpdated: String?
    let temp_c, temp_f: Double?
    let isDay: Int?
    let condition: Condition?
    let windMph: Int?
    let wind_kph: Double?
    let windDegree: Int?
    let wind_dir: String?
    let pressureMB: Int?
    let pressureIn: Double?
    let precipMm, precipIn, humidity, cloud: Int?
    let feelslikeC, feelslikeF: Double?
    let visKM, visMiles, uv: Int?
    let gustMph, gustKph: Double?
}

// MARK: - Condition

struct Condition: Codable {
    
    let text, icon: String?
    let code: Int?
}

// MARK: - Location

struct Location: Codable {
    
    let name, region, country: String?
    let lat, lon: Double?
    let tzID: String?
    let localtimeEpoch: Int?
    let localtime: String?
}
