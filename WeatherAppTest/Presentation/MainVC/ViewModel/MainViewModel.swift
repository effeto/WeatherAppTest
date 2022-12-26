//
//  MainViewModel.swift
//  WeatherAppTest
//
//  Created by Демьян on 25.12.2022.
//

import Foundation
import CoreLocation

struct LocationData {
    
    var latitude: Double
    var longitude: Double
    
    func string() -> String {
        return "\(self.latitude),\(self.longitude)"
    }
    
    static func empty() -> Self {
        return LocationData(latitude: -1, longitude: -1)
    }
}

final class MainViewModel {
    
    // MARK: - Variables
    
    public var hoursForecast: [Hour] = []
    public var tenDaysForecast: [Forecastday] = []
    public let locationManager = CLLocationManager()
    
    public var location: LocationData = .empty() {
        didSet {
            print("*** \(self.location.string())")
        }
    }
    
    // MARK: - Internal
    
    func fetchHoursForecast(location: String, completion: @escaping () -> Void) {
        Networking.shared.fetchHourForecast(city: location) {
            self.hoursForecast = $0
            completion()
        } failure: { error in
            print(error)
        }
    }
    
    func fetchTenDaysForecast(location: String, completion: @escaping () -> Void) {
        Networking.shared.fetchTenDaysForecast(city: location) { forecast in
            self.tenDaysForecast = forecast
            completion()
        } failure: { error in
            print(error)
        }
    }
    
    func getCurrentTime() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "HH"
        let dateString = df.string(from: date)
        return dateString
    }
    
    func getTimeIndex() -> Int {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "HH"
        let dateString = df.string(from: date)
        return Int(dateString) ?? 0
    }
}
