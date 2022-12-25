//
//  Coordinator.swift
//  WeatherAppTest
//
//  Created by Демьян on 23.12.2022.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    
    func start()
}
