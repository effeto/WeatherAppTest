//
//  Weather.swift
//  WeatherAppTest
//
//  Created by Демьян on 25.12.2022.
//

import Foundation

struct Weather {
    
    let location: String
    let temperature: Double
    let icon: String
    let humidity: Int
    let windSpeed: Double
    let windDirection: String
    let date: String
    
    var temperatureString: String {
        let temperatureInt = Int(self.temperature)
        return String("\(temperatureInt)°")
    }
    
    var humidityString: String {
        String(self.humidity)
    }
    
    var windSpeedStrig: String {
        String(self.windSpeed)
    }
    
    var formattedDate: String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "E, d MMMM"
        
        if let date = dateFormatterGet.date(from: self.date) {
            return dateFormatterPrint.string(from: date)
        } else {
            return self.date
        }
    }
}


