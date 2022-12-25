//
//  WindDirections.swift
//  WeatherAppTest
//
//  Created by Демьян on 24.12.2022.
//

import UIKit

enum WindDirections: String {
    case south = "icon_wind_s"
    case north = "icon_wind_n"
    case west = "icon_wind_w"
    case east = "icon_wind_e"
    
    var value: String {
        self.rawValue
    }
}


