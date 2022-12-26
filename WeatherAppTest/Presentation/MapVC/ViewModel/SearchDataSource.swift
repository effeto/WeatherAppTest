//
//  SearchDataSource.swift
//  WeatherAppTest
//
//  Created by Демьян on 26.12.2022.
//

import UIKit

protocol SearchDataSourceDelegate: AnyObject {
    
    func didSelectRow(index: Int, model: SearchModelElement)
}

final class SearchDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SearchDataSourceDelegate?
    public var searchResult: [SearchModelElement] = []
    
    func configure(with searchResult: [SearchModelElement]) {
        self.searchResult = searchResult
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id,
                                                                       for: indexPath
        ) as? SearchTableViewCell else { return UITableViewCell() }
        let city = self.searchResult[indexPath.row].name.orNotAvailable
        let country = self.searchResult[indexPath.row].country.orNotAvailable
        cell.configureCell(city: city, country: country)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(index: indexPath.row, model: searchResult[indexPath.row])
    }
}

