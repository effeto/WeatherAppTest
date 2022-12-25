//
//  MapViewController.swift
//  WeatherAppTest
//
//  Created by Демьян on 25.12.2022.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController,
                         MKMapViewDelegate,
                         CLLocationManagerDelegate,
                         UIGestureRecognizerDelegate,
                         UITextFieldDelegate,
                         UITableViewDelegate,
                         UITableViewDataSource {
    
    var coordinator: MainCoordinator?
    private let mainView = MapView()
    var mapViewDelegate: MapViewDelegate?
    var viewModel: MapViewModel?
    let locationManager = CLLocationManager()
    let location = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
        setMapviewLongPress()
    }
    
    private func setView() {
        self.view.addSubview(mainView)
        self.mainView.mapView.delegate = self
        self.locationManager.delegate = self
        self.mainView.searchBarView.searchTextField.delegate = self
        self.mainView.searchTableView?.delegate = self
        self.mainView.searchTableView?.dataSource = self
        self.mainView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        self.mainView.searchBarView.backButtonAction = backButtonAction
        self.mainView.searchBarView.searchButtonAction = searchButtonAction
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
        self.mainView.searchBarView.searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                                     for: .editingChanged)
        if let coor = self.mainView.mapView.userLocation.location?.coordinate{
            self.mainView.mapView.setCenter(coor, animated: true)
        }
    }
    
    private func backButtonAction() {
        coordinator?.goBack()
    }
    
    private func searchButtonAction() {
        print("Search")
    }
    
    func setMapviewLongPress(){
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self
        self.mainView.mapView.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
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
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.isEmpty == false {
            self.mainView.searchTableView?.isHidden = false
            guard let text = textField.text else {return}
            viewModel?.fetchSearchResults(city: text, completion: {
                self.mainView.searchTableView?.reloadData()
            })
        } else {
            self.mainView.searchTableView?.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.searchResult.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainView.searchTableView?.dequeueReusableCell(withIdentifier: SearchTableViewCell.id,
                                                                       for: indexPath
        ) as? SearchTableViewCell else { return UITableViewCell() }
        let city = self.viewModel?.searchResult[indexPath.row].name.orNotAvailable
        let country = self.viewModel?.searchResult[indexPath.row].country.orNotAvailable
        cell.configureCell(city: city.orNotAvailable, country: country.orNotAvailable)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let longitude = self.viewModel?.searchResult[indexPath.row].lon ?? 0.0
        let latitude = self.viewModel?.searchResult[indexPath.row].lat ?? 0.0
        let city = self.viewModel?.searchResult[indexPath.row].name.orNotAvailable
        mapViewDelegate?.pushLocationBack(location: city.orNotAvailable,
                                          latitude: latitude,
                                          longitude: longitude)
        coordinator?.goBack()
    }
}

protocol MapViewDelegate: AnyObject {
    func pushLocationBack(location: String, latitude: Double, longitude: Double)
}
