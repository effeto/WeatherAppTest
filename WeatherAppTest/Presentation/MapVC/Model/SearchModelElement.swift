//
//  SearchModelElement.swift
//  WeatherAppTest
//
//  Created by Демьян on 25.12.2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchModel = try? newJSONDecoder().decode(SearchModel.self, from: jsonData)

import Foundation

// MARK: - SearchModelElement


struct SearchModelElement: Codable {
    let id: Int?
    let name, region, country: String?
    let lat, lon: Double?
    let url: String?
}

typealias SearchModel = [SearchModelElement]

