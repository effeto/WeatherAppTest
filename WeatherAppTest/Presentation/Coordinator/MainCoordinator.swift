//
//  MainCoordinator.swift
//  WeatherAppTest
//
//  Created by Демьян on 23.12.2022.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController = UINavigationController()
    let window = UIWindow()

    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SplashViewController()
        vc.coordinator = self
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.pushViewController(vc, animated: false)
    }
    
    func openMainVC() {
        let vc = MainViewController()
        let vm = MainViewModel()
        vc.viewModel = vm        
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.pushViewController(vc, animated: false)
    }
    
    func openMapVC(delegate: MapViewDelegate) {
        let vc = MapViewController()
        let vm = MapViewModel()
        vc.coordinator = self
        vc.viewModel = vm
        vc.mapViewDelegate = delegate
        navigationController.navigationBar.isHidden = true
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
