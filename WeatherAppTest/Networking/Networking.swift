//
//  Networking.swift
//  WeatherAppTest
//
//  Created by Демьян on 24.12.2022.
//

import UIKit
import Alamofire

class Networking {
    
    static let shared = Networking()
    
    private let apiKey = "24cb3248af8c4ad3b40102008222412"
    private let baseURLCurrentWeather = "https://api.weatherapi.com/v1/forecast.json?key="
    private let tenDaysForecast = "&days=10&aqi=no&alerts=no"
    private let searchLocation = "https://api.weatherapi.com/v1/search.json?key=24cb3248af8c4ad3b40102008222412&q="
    
    //    &days=10&aqi=no&alerts=no
    
    func fetchCurrentWeather(
        city: String,
        completion: @escaping (Weather) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let url = "\(self.baseURLCurrentWeather)\(self.apiKey)&q=\(city)&aqi=no"
        print("### Request URL: \(url)")
        
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default
        )
        .validate().responseString(encoding: String.Encoding.utf8) { (response) in
            guard let data = response.data else {
                failure("No data")
                return
            }
            
            guard let decoded: CurrentWeather = try? JSONDecoder().decode(CurrentWeather.self, from: data),
                  let current = decoded.current
            else {
                failure("No current data")
                return
            }
            
            guard let forecast = decoded.forecast else {
                failure("No current data")
                return
            }
            
            guard let forecastDay = forecast.forecastday?[0] else {
                failure("No current data")
                return
            }
            
            
            let weather = Weather(
                location: decoded.location?.name ?? "",
                temperature: current.temp_c ?? 0.0,
                icon: current.condition?.text.orNotAvailable ?? "",
                humidity: current.humidity ?? 0,
                windSpeed: current.wind_kph ?? 0.0,
                windDirection: current.wind_dir.orNotAvailable,
                date: forecastDay.date.orNotAvailable
            )
            
            completion(weather)
        }
    }
    
    func fetchHourForecast(city: String, completion: @escaping (_ hoursForecast: [Hour]) -> (), failure: @escaping (String) -> ()) {
        let url = "\(self.baseURLCurrentWeather)\(self.apiKey)&q=\(city)&days=10&aqi=no&alerts=no"
        print("### Request URL: \(url)")
        
        AF.request(url, method: .get, encoding: JSONEncoding.default).validate().responseString(encoding: String.Encoding.utf8){ (response) in
            
            guard let _ = response.response else {
                failure("No response")
                return
            }
            
            guard let data = response.data else {
                failure("No data")
                return
            }
            
            let decoded: HourlyWeatherModel = try! JSONDecoder().decode(HourlyWeatherModel.self, from: data)
            
            guard decoded.forecast != nil else {
                failure("No current data forecast")
                return
            }
            
            guard decoded.forecast?.forecastday != nil else {
                failure("No current data forecastday")
                return
            }
            
            guard let hourlyForecast = decoded.forecast!.forecastday![0].hour else {
                failure("No data")
                return
            }
            
            completion(hourlyForecast)
            
        }
    }
    
    func fetchTenDaysForecast(city: String,
                              completion: @escaping (_ forecast: [Forecastday]) -> Void,
                              failure: @escaping (String) -> Void
    ) {
        let url = "\(self.baseURLCurrentWeather)\(self.apiKey)&q=\(city)&days=10&aqi=no&alerts=no"
        print("### Request URL: \(url)")
        
        AF.request(url, method: .get, encoding: JSONEncoding.default).validate().responseString(encoding: String.Encoding.utf8){ (response) in
            
            guard let _ = response.response else {
                failure("No response")
                return
            }
            
            guard let data = response.data else {
                failure("No data")
                return
            }
            
            let decoded: HourlyWeatherModel = try! JSONDecoder().decode(HourlyWeatherModel.self, from: data)
            
            guard decoded.forecast?.forecastday != nil else {
                failure("No current data forecastday")
                return
            }
            
            guard let tenDayForecast = decoded.forecast?.forecastday else {
                failure("No data")
                return
            }
            print(tenDayForecast.count)
            completion(tenDayForecast)
        }
    }
    
    func fetchSearchLocation(city: String,
                             completion: @escaping (_ locationsSearch: SearchModel) -> Void,
                             failure: @escaping (String) -> Void
    ) {
        let url = "\(self.searchLocation)\(city)"
        print("### Request URL: \(url)")
        AF.request(url, method: .get, encoding: JSONEncoding.default).validate().responseString(encoding: String.Encoding.utf8){ (response) in
            
            guard let data = response.data else {
                failure("No data")
                return
            }
            
            let decoded: SearchModel = try! JSONDecoder().decode(SearchModel.self, from: data)
            
            guard decoded != nil else {
                failure("No current data")
                return
            }
            
            print(decoded.count)
            completion(decoded)
        }
        
    }
}
