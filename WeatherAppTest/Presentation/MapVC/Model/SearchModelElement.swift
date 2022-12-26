//
//  SearchModelElement.swift
//  WeatherAppTest
//
//  Created by Демьян on 25.12.2022.
//

import Foundation

// MARK: - SearchModelElement

typealias SearchModel = [SearchModelElement]

struct SearchModelElement: Codable {
    
    let id: Int?
    let name, region, country: String?
    let lat, lon: Double?
    let url: String?
}
