//
//  Optional + Extensions.swift
//  WeatherAppTest
//
//  Created by Демьян on 24.12.2022.
//

import Foundation

extension Optional where Wrapped == String {
    var orNotAvailable: String {
        self ?? "N/A"
    }
}
