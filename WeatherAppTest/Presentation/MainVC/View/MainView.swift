//
//  MainView.swift
//  WeatherAppTest
//
//  Created by Демьян on 24.12.2022.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    internal let screen = UIScreen.main.bounds
    let currentWeatherView = CurrentWeatherView()
    weak var hoursForecastCollectionView: UICollectionView?
    weak var tenDayForecastTableView: UITableView?
    
    let changeLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_my_location"), for: .normal)
        return button
    }()
    
    var changeLocationButtonAction:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setCurrentWeatherView()
        setHoursForecastCollectionView()
        setTenDayForecastTableView()
        setChangeLocationButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCurrentWeatherView() {
        self.addSubview(currentWeatherView)
        if screen.width > 430 {
            currentWeatherView.snp.makeConstraints { make in
                make.top.leading.equalTo(self)
                make.height.equalTo(screen.height)
                make.width.equalTo(screen.width/2)
            }
        } else {
            currentWeatherView.snp.makeConstraints { make in
                make.top.leading.equalTo(self)
                make.width.equalTo(screen.width)
                make.height.equalTo(screen.height/2)
            }
        }
    }
    
    private func setHoursForecastCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        
        let collection = UICollectionView(frame: .zero , collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collection.isScrollEnabled = true
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(HourlyForecastCollectionViewCell.self, forCellWithReuseIdentifier: HourlyForecastCollectionViewCell.id)
        self.addSubview(collection)
        
        collection.snp.makeConstraints { make in
            make.top.equalTo(self.currentWeatherView.weatherImage.snp.bottom).offset(10)
            make.height.equalTo(100)
            make.width.equalTo(self.currentWeatherView)
        }
        self.hoursForecastCollectionView = collection
    }
    
    private func setTenDayForecastTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.id)
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.currentWeatherView.snp.bottom)
            make.width.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        self.tenDayForecastTableView = tableView
    }
    
    private func setChangeLocationButton() {
        self.addSubview(changeLocationButton)
        changeLocationButton.addTarget(self, action: #selector(changeLocationButtonTaped), for: .touchUpInside)
        
        changeLocationButton.snp.makeConstraints { make in
            make.centerY.equalTo(currentWeatherView.cityLabel)
            make.trailing.equalTo(currentWeatherView).offset(-20)
            make.width.height.equalTo(50)
        }
    }
    
    @objc func changeLocationButtonTaped() {
        changeLocationButtonAction?()
    }
}
