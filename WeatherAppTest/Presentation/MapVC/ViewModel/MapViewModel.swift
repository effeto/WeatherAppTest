//
//  MapViewModel.swift
//  WeatherAppTest
//
//  Created by Демьян on 25.12.2022.
//

import Foundation

final class MapViewModel {
    public var searchResult: [SearchModelElement] = []
    
    public func fetchSearchResults(city: String, completion: @escaping () -> Void) {
        Networking.shared.fetchSearchLocation(city: city) { locationsSearch in
            self.searchResult = locationsSearch
            completion()
        } failure: { error in
            print(error)
        }

        
    }
}
