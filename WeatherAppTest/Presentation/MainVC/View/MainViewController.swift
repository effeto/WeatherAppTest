//
//  MainViewController.swift
//  WeatherAppTest
//
//  Created by Демьян on 23.12.2022.
//

import UIKit
import SnapKit
import CoreLocation


class MainViewController: UIViewController,
                          UICollectionViewDelegate,
                          UICollectionViewDataSource,
                          UITableViewDataSource,
                          UITableViewDelegate,
                          CLLocationManagerDelegate,
                          MapViewDelegate
{

    var coordinator: MainCoordinator?
    var viewModel: MainViewModel?
    private let mainView = MainView()
    public let locationManager = CLLocationManager()
    var timeIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.setView()
        if let location = self.viewModel?.location.string() {
            self.viewModel?.fetchHoursForecast(location: location) {
                self.mainView.hoursForecastCollectionView?.reloadData()
                self.timeIndex = self.viewModel?.getTimeIndex() ?? 0
                let i = IndexPath(row: (self.timeIndex) , section: 0)
                self.mainView.hoursForecastCollectionView?.scrollToItem(at: i,
                                                                        at: .centeredHorizontally,
                                                                        animated: true)
            }
            self.viewModel?.fetchTenDaysForecast(location: location) {
                self.mainView.tenDayForecastTableView?.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getLocation {
            print("ViewWillAppear getLocation")
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        switch UIDevice.current.orientation.isPortrait {
        case true:
            self.mainView.currentWeatherView.snp.updateConstraints { make in
                make.height.equalTo(self.mainView.screen.height/2)
            }
            
            self.mainView.tenDayForecastTableView?.snp.remakeConstraints({ make in
                make.top.equalTo(self.mainView.currentWeatherView.snp.bottom)
                make.width.equalTo(self.mainView)
                make.bottom.equalTo(self.mainView)
            })
            
            
        case false:
            self.mainView.currentWeatherView.snp.updateConstraints { make in
                make.height.equalTo(self.mainView.screen.height)
            }
            
            self.mainView.tenDayForecastTableView?.snp.remakeConstraints({ make in
                make.top.equalTo(self.mainView)
                make.leading.equalTo(self.mainView.currentWeatherView.snp.trailing)
                make.trailing.equalTo(self.mainView)
                make.bottom.equalTo(self.mainView)
            })
        }
    }
    
    private func setView() {
        self.view.addSubview(mainView)
        
        self.mainView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        if let location = self.viewModel?.location.string() {
            self.mainView.currentWeatherView.configureCurrentWeatherView(city: location)
        }
        
        self.mainView.changeLocationButtonAction = changeLocationButtonAction
    }
    
    private func setDelegates() {
        self.mainView.hoursForecastCollectionView?.dataSource = self
        self.mainView.hoursForecastCollectionView?.delegate = self
        self.mainView.tenDayForecastTableView?.dataSource = self
        self.mainView.tenDayForecastTableView?.delegate = self
        self.viewModel?.locationManager.delegate = self
    }
    
    private func getLocation(completion: @escaping () -> Void) {
        self.viewModel?.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.viewModel?.locationManager.startUpdatingLocation()
        completion()
    }
    
    private func changeLocationButtonAction() {
        coordinator?.openMapVC(delegate: self)
    }
    
    // MARK: -
    // MARK: CollectionView Delegate & DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.hoursForecast.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainView.hoursForecastCollectionView?.dequeueReusableCell(
            withReuseIdentifier: HourlyForecastCollectionViewCell.id,
            for: indexPath
        ) as? HourlyForecastCollectionViewCell else { return UICollectionViewCell() }
        let currentTime = viewModel?.getCurrentTime()
        let time = viewModel?.hoursForecast[indexPath.row].formattedTime
        let weatherImage = viewModel?.hoursForecast[indexPath.row].condition?.icon.orNotAvailable
        let temperature = viewModel?.hoursForecast[indexPath.row].temperatureString
        if let time = time{
            if (currentTime).orNotAvailable == time.prefix(2) {
                timeIndex = indexPath.row
            }
        }
     
        cell.configureHourlyForecastCell(time: time.orNotAvailable,
                                         weatherImage: weatherImage.orNotAvailable,
                                         temperature: temperature.orNotAvailable)
        
        return cell
    }
    // MARK: -
    // MARK: TableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel?.tenDaysForecast.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainView.tenDayForecastTableView?.dequeueReusableCell(withIdentifier: ForecastTableViewCell.id,
                                                                               for: indexPath
        ) as? ForecastTableViewCell else { return UITableViewCell() }
        let day = viewModel?.tenDaysForecast[indexPath.row].formattedDate
        let temperature = viewModel?.tenDaysForecast[indexPath.row].day?.maxMinTemperatureString
        let icon = viewModel?.tenDaysForecast[indexPath.row].day?.condition?.icon.orNotAvailable
        cell.configureCell(date: day.orNotAvailable, temperature: temperature.orNotAvailable, icon: icon.orNotAvailable)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if let location =  self.viewModel?.location.string() {
                self.mainView.currentWeatherView.configureCurrentWeatherView(city: location)
                self.viewModel?.fetchHoursForecast(location: location) {
                    self.mainView.hoursForecastCollectionView?.reloadData()
                    let i = IndexPath(row: self.timeIndex, section: 0)
                    self.mainView.hoursForecastCollectionView?.scrollToItem(at: i,
                                                                            at: .centeredHorizontally,
                                                                            animated: true)
                }
            }
        default:
            let date = self.viewModel?.tenDaysForecast[indexPath.row].formattedDayForDetails
            let temperature = self.viewModel?.tenDaysForecast[indexPath.row].day?.maxMinTemperatureString
            let humidity = self.viewModel?.tenDaysForecast[indexPath.row].day?.humidityString
            let windSpeed = self.viewModel?.tenDaysForecast[indexPath.row].day?.windSpeedString
            let icon = self.viewModel?.tenDaysForecast[indexPath.row].day?.condition?.icon
            let city = self.viewModel?.hoursForecast[indexPath.row]
            mainView.currentWeatherView.rebuildCurrentWeatherView(date: date.orNotAvailable,
                                                                  temperature: temperature.orNotAvailable,
                                                                  humidity: humidity.orNotAvailable,
                                                                  windSpeed: windSpeed.orNotAvailable,
                                                                  windDirection: "",
                                                                  icon: icon.orNotAvailable)
            let i = IndexPath(row: 0, section: 0)
            self.mainView.hoursForecastCollectionView?.scrollToItem(at: i,
                                                                    at: .centeredHorizontally,
                                                                    animated: true)
            self.viewModel?.hoursForecast = (viewModel?.tenDaysForecast[indexPath.row].hour)!
            self.mainView.hoursForecastCollectionView?.reloadData()
        }
    }
    // MARK: -
    // MARK: LocationManager Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.viewModel?.location = LocationData(latitude: locationValue.latitude, longitude: locationValue.longitude)
        if let location = self.viewModel?.location.string() {
            self.viewModel?.fetchHoursForecast(location: location) {
                self.mainView.hoursForecastCollectionView?.reloadData()
            }
            self.viewModel?.fetchTenDaysForecast(location: location) {
                self.mainView.tenDayForecastTableView?.reloadData()
            }
        }
        viewModel?.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
        
    func pushLocationBack(location: String, latitude: Double, longitude: Double) {
        self.viewModel?.location.longitude = longitude
        self.viewModel?.location.latitude = latitude
        if let newLocation = self.viewModel?.location.string() {
            self.mainView.currentWeatherView.configureCurrentWeatherView(city: newLocation)
        }
        
        self.viewModel?.fetchHoursForecast(location: location) {
            self.mainView.hoursForecastCollectionView?.reloadData()
        }
        self.viewModel?.fetchTenDaysForecast(location: location) {
            self.mainView.tenDayForecastTableView?.reloadData()
        }
        
        self.viewModel?.location = LocationData(latitude: latitude, longitude: longitude)
    }
}
