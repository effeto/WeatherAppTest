//
//  MapViewController.swift
//  WeatherAppTest
//
//  Created by Демьян on 25.12.2022.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewDelegate: AnyObject {
    
    func pushLocationBack(location: String, latitude: Double, longitude: Double)
}

class MapViewController: UIViewController,
                         MKMapViewDelegate,
                         CLLocationManagerDelegate,
                         UIGestureRecognizerDelegate,
                         UITextFieldDelegate,
                         SearchDataSourceDelegate
{
    
    // MARK: - Variables
    
    var coordinator: MainCoordinator?
    private let mainView = MapView()
    var mapViewDelegate: MapViewDelegate?
    var searchDataSource: SearchDataSource?
    var viewModel: MapViewModel?
    let locationManager = CLLocationManager()
    let location = ""
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setView()
        self.setDelegates()
        self.getLocation()
    }
    
    // MARK: - Private
    
    private func setView() {
        self.view.addSubview(mainView)
        self.mainView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        self.mainView.searchBarView.backButtonAction = backButtonAction
        self.mainView.searchBarView.searchButtonAction = searchButtonAction
        self.mainView.searchBarView.searchTextField.addTarget(self,
                                                              action: #selector(textFieldDidChange(_:)),
                                                              for: .editingChanged)
        self.setMapviewLongPress()
    }
    
    private func setDelegates() {
        self.mainView.mapView.delegate = self
        self.locationManager.delegate = self
        self.searchDataSource?.delegate = self
        self.mainView.searchBarView.searchTextField.delegate = self
        self.mainView.searchTableView?.delegate = searchDataSource
        self.mainView.searchTableView?.dataSource = searchDataSource
    }
    
    private func backButtonAction() {
        self.coordinator?.goBack()
    }
    
    private func searchButtonAction() {
        self.locationManager.startUpdatingLocation()
    }
    
    private func getLocation() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
        if let coordinates = self.mainView.mapView.userLocation.location?.coordinate{
            self.mainView.mapView.setCenter(coordinates, animated: true)
        }
    }
    
    private func setMapviewLongPress(){
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self
        self.mainView.mapView.addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureReconizer.location(in: mainView.mapView)
            let locationCoordinate = mainView.mapView.convert(touchLocation,toCoordinateFrom: mainView.mapView)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            let loc = "\(locationCoordinate.latitude),\(locationCoordinate.longitude)"
            mapViewDelegate?.pushLocationBack(location: loc,
                                              latitude: locationCoordinate.latitude,
                                              longitude: locationCoordinate.longitude)
            coordinator?.goBack()
        }
        if gestureReconizer.state != UIGestureRecognizer.State.began {
            return
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.isEmpty == false {
            self.mainView.searchTableView?.isHidden = false
            guard let text = textField.text else {return}
            viewModel?.fetchSearchResults(city: text, completion: {
                guard let model = self.viewModel?.searchResult else { return }
                self.searchDataSource?.configure(with: model)
                self.mainView.searchTableView?.reloadData()
            })
        } else {
            self.mainView.searchTableView?.isHidden = true
        }
    }
    
    // MARK: - LocationManager Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        mainView.mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mainView.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "You are Here"
        mainView.mapView.addAnnotation(annotation)
        manager.stopUpdatingLocation()
    }
    
    // MARK: - SearchDataSource Delegate
    
    func didSelectRow(index: Int, model: SearchModelElement) {
        let longitude = self.viewModel?.searchResult[index].lon ?? 0.0
        let latitude = self.viewModel?.searchResult[index].lat ?? 0.0
        let city = self.viewModel?.searchResult[index].name.orNotAvailable
        mapViewDelegate?.pushLocationBack(location: city.orNotAvailable,
                                          latitude: latitude,
                                          longitude: longitude)
        coordinator?.goBack()
    }
}
