//
//  SplashView.swift
//  WeatherAppTest
//
//  Created by Демьян on 23.12.2022.
//

import UIKit
import Lottie
import SnapKit

class SplashView: UIView {
    
    let animationContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let animationView: AnimationView = {
        let view = AnimationView()
        let animation = Animation.named("weather-icon")
        view.animation = animation
        view.contentMode = .scaleToFill
        view.loopMode = .playOnce
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setAnimationContainer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAnimationContainer() {
        self.addSubview(animationContainer)
        animationContainer.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
            make.height.width.equalTo(300)
        }
    }
    
    func startAnimation() {
        animationContainer.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(animationContainer)
        }
        animationView.play()
    }
}
