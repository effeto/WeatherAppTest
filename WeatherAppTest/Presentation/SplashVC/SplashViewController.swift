//
//  SplashViewController.swift
//  WeatherAppTest
//
//  Created by Демьян on 23.12.2022.
//

import UIKit

class SplashViewController: UIViewController {
    
    // MARK: - Variables
    
    var coordinator: MainCoordinator?
    private let mainView = SplashView()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        mainView.startAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        goMainVC()
    }
    
    // MARK: - Override
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        setView()
    }
    
    // MARK: - Private
    
    private func setView() {
        mainView.frame = view.frame
        view.addSubview(mainView)
    }
    
    private func goMainVC() {
        if let animation = mainView.animationView.animation {
            DispatchQueue.main.asyncAfter(deadline: .now() + animation.duration) {
                self.coordinator?.openMainVC()
            }
        }
    }
}
