//
//  HourlyForecastCollectionViewCell.swift
//  WeatherAppTest
//
//  Created by Демьян on 25.12.2022.
//

import UIKit
import SnapKit

final class HourlyForecastCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    static let id = "HourlyForecastCollectionViewCell"
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_white_day_cloudy")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .light)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = AppHelper.lightBlue
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        setTimeLabel()
        setWeatherImage()
        setTemperatureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setTimeLabel() {
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(5)
            make.centerX.equalTo(self)
        }
    }
    
    private func setWeatherImage() {
        self.addSubview(weatherImage)
        weatherImage.snp.makeConstraints { make in
            make.top.equalTo(self.timeLabel.snp.bottom).offset(5)
            make.centerX.equalTo(self)
            make.height.equalTo(25)
            make.width.equalTo(50)
        }
    }
    
    private func setTemperatureLabel() {
        self.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(self.weatherImage.snp.bottom).offset(3)
            make.centerX.equalTo(self)
        }
    }
    
    // MARK: - Public
    
    public func configureHourlyForecastCell(time: String, weatherImage: String, temperature: String) {
        self.temperatureLabel.text = temperature
        self.timeLabel.text = time
        if weatherImage == "Sunny" {
            self.weatherImage.image = UIImage(named: "ic_white_day_bright")
        } else if weatherImage == "Cloudy" || weatherImage ==  "Partly cloudy" {
            self.weatherImage.image = UIImage(named: "ic_white_day_cloudy")
        } else if weatherImage == "Heavy rain" {
            self.weatherImage.image = UIImage(named: "ic_white_day_shower")
        } else if weatherImage == "Light rain" {
            self.weatherImage.image = UIImage(named: "ic_white_day_rain")
        } else if weatherImage == "Thundery outbreaks possible" {
            self.weatherImage.image = UIImage(named: "ic_white_day_thunder")
        } else {
            self.weatherImage.image = UIImage(named: "ic_white_day_bright")
        }
    }
}
