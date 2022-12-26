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
                          CLLocationManagerDelegate,
                          MainViewDataSourceDelegate,
                          MapViewDelegate
{
    
    // MARK: - Variables

    var coordinator: MainCoordinator?
    var viewModel: MainViewModel?
    var dataSource: MainViewDataSource?
    private let mainView = MainView()
    public let locationManager = CLLocationManager()
    var timeIndex = 0
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLocation {
        }
        self.setDelegates()
        self.setView()
        if let location = self.viewModel?.location.string() {
            self.viewModel?.fetchHoursForecast(location: location) {
                guard let model = self.viewModel?.hoursForecast else {return}
                self.dataSource?.configureCollectionView(with: model)
                self.mainView.hoursForecastCollectionView?.reloadData()
                self.timeIndex = self.viewModel?.getTimeIndex() ?? 0
                let i = IndexPath(row: (self.timeIndex) , section: 0)
                self.mainView.hoursForecastCollectionView?.scrollToItem(at: i,
                                                                        at: .centeredHorizontally,
                                                                        animated: true)
            }
            self.viewModel?.fetchTenDaysForecast(location: location) {
                guard let model = self.viewModel?.tenDaysForecast else {return}
                self.dataSource?.configureTableView(with: model)
                self.mainView.tenDayForecastTableView?.reloadData()
            }
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
    
    // MARK: - Private
    
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
        self.mainView.hoursForecastCollectionView?.dataSource = dataSource
        self.mainView.hoursForecastCollectionView?.delegate = dataSource
        self.mainView.tenDayForecastTableView?.dataSource = dataSource
        self.mainView.tenDayForecastTableView?.delegate = dataSource
        self.dataSource?.delegate = self
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
    
    // MARK: - DataSource Delegate
    
    func didSelectRow(index: Int, model: Forecastday) {
        switch index {
        case 0 :
            if let location =  self.viewModel?.location.string() {
                self.mainView.currentWeatherView.configureCurrentWeatherView(city: location)
                self.viewModel?.fetchHoursForecast(location: location) {
                    guard let model = self.viewModel?.hoursForecast else {return}
                    self.dataSource?.configureCollectionView(with: model)
                    self.mainView.hoursForecastCollectionView?.reloadData()
                    let i = IndexPath(row: self.timeIndex, section: 0)
                    self.mainView.hoursForecastCollectionView?.scrollToItem(at: i,
                                                                            at: .centeredHorizontally,
                                                                            animated: true)
                }
            }
        default:
            let date = self.viewModel?.tenDaysForecast[index].formattedDayForDetails
            let temperature = self.viewModel?.tenDaysForecast[index].day?.maxMinTemperatureString
            let humidity = self.viewModel?.tenDaysForecast[index].day?.humidityString
            let windSpeed = self.viewModel?.tenDaysForecast[index].day?.windSpeedString
            let icon = self.viewModel?.tenDaysForecast[index].day?.condition?.icon
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
            self.viewModel?.hoursForecast = (viewModel?.tenDaysForecast[index].hour)!
            self.mainView.hoursForecastCollectionView?.reloadData()
        }
    }
    
    func getTimeIndex(index: Int) {
        self.timeIndex = index
    }

    // MARK: - LocationManager Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        self.viewModel?.location = LocationData(latitude: locationValue.latitude, longitude: locationValue.longitude)
        
        if let location = self.viewModel?.location.string() {
            self.viewModel?.fetchHoursForecast(location: location) {
                guard let model = self.viewModel?.hoursForecast else { return }
                
                self.dataSource?.configureCollectionView(with: model)
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
    
    // MARK: - MapView Delegate
        
    func pushLocationBack(location: String, latitude: Double, longitude: Double) {
        self.viewModel?.location.longitude = longitude
        self.viewModel?.location.latitude = latitude
        
        if let newLocation = self.viewModel?.location.string() {
            self.mainView.currentWeatherView.configureCurrentWeatherView(city: newLocation)
        }
        
        self.viewModel?.fetchHoursForecast(location: location) {
            guard let model = self.viewModel?.hoursForecast else {return}
            self.dataSource?.configureCollectionView(with: model)
            self.mainView.hoursForecastCollectionView?.reloadData()
        }
        
        self.viewModel?.fetchTenDaysForecast(location: location) {
            guard let model = self.viewModel?.tenDaysForecast else {return}
            self.dataSource?.configureTableView(with: model)
            self.mainView.tenDayForecastTableView?.reloadData()
        }

        self.viewModel?.location = LocationData(latitude: latitude, longitude: longitude)
    }
}
