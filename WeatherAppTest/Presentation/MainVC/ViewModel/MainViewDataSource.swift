//
//  MainViewDataSource.swift
//  WeatherAppTest
//
//  Created by Демьян on 26.12.2022.
//

import UIKit

protocol MainViewDataSourceDelegate: AnyObject {
    
    func didSelectRow(index: Int, model: Forecastday)
    func getTimeIndex(index: Int)
}

final class MainViewDataSource: NSObject,
                                UITableViewDelegate,
                                UITableViewDataSource,
                                UICollectionViewDelegate,
                                UICollectionViewDataSource
{
    
    // MARK: - Variables
    
    weak var delegate: MainViewDataSourceDelegate?
    public var hoursForecast: [Hour] = []
    public var tenDaysForecast: [Forecastday] = []
    
    // MARK: - Public
    
    public func configureTableView(with tenDaysDorecast: [Forecastday]) {
        self.tenDaysForecast = tenDaysDorecast
    }
    
    public func configureCollectionView(with hoursForecast: [Hour]) {
        self.hoursForecast = hoursForecast
    }
    
    // MARK: - Internal
    
    func getCurrentTime() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "HH"
        let dateString = df.string(from: date)
        return dateString
    }
    
    //MARK: - TableView Delegates & Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tenDaysForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.id,
                                                       for: indexPath
        ) as? ForecastTableViewCell else { return UITableViewCell() }
        
        let day = self.tenDaysForecast[indexPath.row].formattedDate
        let temperature = self.tenDaysForecast[indexPath.row].day?.maxMinTemperatureString
        let icon = self.tenDaysForecast[indexPath.row].day?.condition?.icon.orNotAvailable
        cell.configureCell(date: day, temperature: temperature.orNotAvailable, icon: icon.orNotAvailable)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(index: indexPath.row, model: tenDaysForecast[indexPath.row])
    }
    
    //MARK: - CollectionView Delegates & Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.hoursForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourlyForecastCollectionViewCell.id,
            for: indexPath
        ) as? HourlyForecastCollectionViewCell else { return UICollectionViewCell() }
        
        let currentTime = self.getCurrentTime()
        let time = hoursForecast[indexPath.row].formattedTime
        let weatherImage = hoursForecast[indexPath.row].condition?.icon
        let temperature = hoursForecast[indexPath.row].temperatureString
        
        if currentTime == time.prefix(2) {
            let timeIndex = indexPath.row
            delegate?.getTimeIndex(index: timeIndex)
        }
        
        cell.configureHourlyForecastCell(time: time,
                                         weatherImage: weatherImage.orNotAvailable,
                                         temperature: temperature)
        
        return cell
    }
}
