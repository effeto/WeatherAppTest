//
//  MainCoordinator.swift
//  WeatherAppTest
//
//  Created by Демьян on 23.12.2022.
//

import UIKit

class MainCoordinator: Coordinator {
    
    // MARK: - Variables
    
    var childCoordinators = [Coordinator]()
    var navigationController = UINavigationController()
    let window = UIWindow()
    
    // MARK: - Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Internal
    
    func start() {
        let vc = SplashViewController()
        vc.coordinator = self
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.pushViewController(vc, animated: false)
    }
    
    func openMainVC() {
        let vc = MainViewController()
        let vm = MainViewModel()
        let dataSource = MainViewDataSource()
        vc.viewModel = vm
        vc.dataSource = dataSource
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.pushViewController(vc, animated: false)
    }
    
    func openMapVC(delegate: MapViewDelegate) {
        let vc = MapViewController()
        let vm = MapViewModel()
        let dataSource = SearchDataSource()
        vc.coordinator = self
        vc.viewModel = vm
        vc.searchDataSource = dataSource
        vc.mapViewDelegate = delegate
        navigationController.navigationBar.isHidden = true
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
