//
//  HourlyForeCastModel.swift
//  WeatherAppTest
//
//  Created by Демьян on 25.12.2022.
//

import Foundation

// MARK: - HourlyWeatherModel

struct HourlyWeatherModel: Decodable {
    
    let location: Location?
    let current: Current?
    let forecast: Forecast?
}
// MARK: - Forecast

struct Forecast: Codable {
    
    let forecastday: [Forecastday]?
}

// MARK: - Forecastday

struct Forecastday: Codable {
    
    let date: String?
    let dateEpoch: Int?
    let day: Day?
    let astro: Astro?
    let hour: [Hour]?
    
    var formattedDate: String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "E"
        
        if let date = dateFormatterGet.date(from: self.date.orNotAvailable) {
            return dateFormatterPrint.string(from: date)
        } else {
            return self.date.orNotAvailable
        }
    }
    
    var formattedDayForDetails: String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "E, d MMMM"
        
        if let date = dateFormatterGet.date(from: self.date.orNotAvailable) {
            return dateFormatterPrint.string(from: date)
        } else {
            return self.date.orNotAvailable
        }
    }
}

// MARK: - Astro

struct Astro: Codable {
    
    let sunrise, sunset, moonrise, moonset: String?
    let moonPhase, moonIllumination: String?
}

// MARK: - Day

struct Day: Codable {
    
    let maxtemp_c, maxtempF, mintemp_c, mintempF: Double?
    let avgtempC, avgtempF, maxwindMph, maxwindKph: Double?
    let totalprecipMm, totalprecipIn: Double?
    let totalsnowCM: Int?
    let avgvis_km: Double?
    let avgvisMiles, avghumidity, dailyWillItRain, dailyChanceOfRain: Int?
    let dailyWillItSnow, dailyChanceOfSnow: Int?
    let condition: Condition?
    let uv: Int?
    
    var maxMinTemperatureString: String {
        let maxTemperatureInt = Int(self.maxtemp_c ?? 0.0)
        let minTemperatureInt = Int(self.mintemp_c ?? 0.0)
        return String("\(maxTemperatureInt)/\(minTemperatureInt)°")
    }
    
    var humidityString: String {
        String(self.avghumidity ?? 0)
    }
    
    var windSpeedString: String {
        String(self.avgvis_km ?? 0.0)
    }
}

// MARK: - Hour

struct Hour: Codable {
    
    let timeEpoch: Int?
    let time: String?
    let temp_c, tempF: Double?
    let isDay: Int?
    let condition: Condition?
    let windMph, windKph: Double?
    let windDegree: Int?
    let windDir: String?
    let pressureMB: Int?
    let pressureIn, precipMm, precipIn: Double?
    let humidity, cloud: Int?
    let feelslikeC, feelslikeF, windchillC, windchillF: Double?
    let heatindexC, heatindexF, dewpointC, dewpointF: Double?
    let willItRain, chanceOfRain, willItSnow, chanceOfSnow: Int?
    let visKM, visMiles: Int?
    let gustMph, gustKph: Double?
    let uv: Int?
    
    var temperatureString: String {
        let temperatureInt = Int(self.temp_c ?? 0.0)
        return String("\(temperatureInt)°")
    }
    
    var formattedTime: String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm"
        
        if let date = dateFormatterGet.date(from: self.time.orNotAvailable) {
            return dateFormatterPrint.string(from: date)
        } else {
            return self.time.orNotAvailable
        }
    }
}
