//
//  CurrentWeatherView.swift
//  WeatherAppTest
//
//  Created by Демьян on 24.12.2022.
//

import UIKit
import SnapKit

final class CurrentWeatherView: UIView {
    
    // MARK: - Variables
    
    let screen = UIScreen.main.bounds
    
    let locationIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_place")
        return imageView
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let currentDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = "CБ, 24 Грудня"
        return label
    }()
    
    let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_white_day_cloudy")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let temperatureImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_temp")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    let humidityImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_humidity")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let humidityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    let windImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_wind")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    let windDirectionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = AppHelper.darkBlue
        
        setLocationIcon()
        setCityLabel()
        setCurrentDayLabel()
        setWeatherImage()
        setTemperatureImage()
        setTemperatureLabel()
        setHumidityImage()
        setHumidityLabel()
        setWindImage()
        setWindSpeedLabel()
        setWindDirectionImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    public func setTemperatureLabel() {
        self.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.centerY.equalTo(temperatureImage)
            make.leading.equalTo(temperatureImage.snp.trailing).offset(3)
        }
    }
    
    public func configureCurrentWeatherView(city: String) {
        Networking.shared.fetchCurrentWeather(city: city) { weather in
            self.currentDateLabel.text = weather.formattedDate
            self.temperatureLabel.text = weather.temperatureString
            self.humidityLabel.text = weather.humidityString
            self.windSpeedLabel.text = "\(weather.windSpeedStrig) km/h"
            self.cityLabel.text = weather.location
            
            if weather.windDirection == "N" {
                self.windDirectionImage.image = UIImage(named: "icon_wind_n")
            } else if weather.windDirection == "S" {
                self.windDirectionImage.image = UIImage(named: "icon_wind_s")
            } else if weather.windDirection == "E" {
                self.windDirectionImage.image = UIImage(named: "icon_wind_e")
            } else {
                self.windDirectionImage.image = UIImage(named: "icon_wind_w")
            }
            
            if weather.icon == "Sunny" {
                self.weatherImage.image = UIImage(named: "ic_white_day_bright")
            } else if weather.icon == "Cloudy" || weather.icon ==  "Partly cloudy" {
                self.weatherImage.image = UIImage(named: "ic_white_day_cloudy")
            } else if weather.icon == "Heavy rain" {
                self.weatherImage.image = UIImage(named: "ic_white_day_shower")
            } else if weather.icon == "Light rain" {
                self.weatherImage.image = UIImage(named: "ic_white_day_rain")
            } else if weather.icon == "Thundery outbreaks possible" {
                self.weatherImage.image = UIImage(named: "ic_white_day_thunder")
            } else {
                self.weatherImage.image = UIImage()
            }
        } failure: { error in
            print(error)
        }
    }
    
    public func rebuildCurrentWeatherView(date: String,
                                          temperature: String,
                                          humidity: String,
                                          windSpeed: String,
                                          windDirection: String,
                                          icon: String) {
        self.currentDateLabel.text = date
        self.temperatureLabel.text = temperature
        self.humidityLabel.text = humidity
        self.windSpeedLabel.text = "\(windSpeed) km/h"
        
        if windDirection == "N" {
            self.windDirectionImage.image = UIImage(named: "icon_wind_n")
        } else if windDirection == "NW" || windDirection == "NNW" || windDirection == "WNW" {
            self.windDirectionImage.image = UIImage(named: "icon_wind_wn")
        } else if windDirection == "NE" || windDirection == "NNE" || windDirection == "ENE" {
            self.windDirectionImage.image = UIImage(named: "icon_wind_ne")
        } else if windDirection == "S"  {
            self.windDirectionImage.image = UIImage(named: "icon_wind_s")
        } else if windDirection == "SW" || windDirection == "SSW" || windDirection == "WSW" {
            self.windDirectionImage.image = UIImage(named: "icon_wind_ws")
        } else if windDirection == "SE" || windDirection == "SSE" || windDirection == "ESE" {
            self.windDirectionImage.image = UIImage(named: "icon_wind_se")
        } else if windDirection == "E" {
            self.windDirectionImage.image = UIImage(named: "icon_wind_e")
        } else if windDirection == "W" {
            self.windDirectionImage.image = UIImage(named: "icon_wind_w")
        } else {
            self.windDirectionImage.image = UIImage()
        }
        
        if icon == "Sunny" {
            self.weatherImage.image = UIImage(named: "ic_white_day_bright")
        } else if icon == "Cloudy" || icon ==  "Partly cloudy" {
            self.weatherImage.image = UIImage(named: "ic_white_day_cloudy")
        } else if icon == "Heavy rain" {
            self.weatherImage.image = UIImage(named: "ic_white_day_shower")
        } else if icon == "Light rain" {
            self.weatherImage.image = UIImage(named: "ic_white_day_rain")
        } else if icon == "Thundery outbreaks possible" {
            self.weatherImage.image = UIImage(named: "ic_white_day_thunder")
        } else {
            self.weatherImage.image = UIImage(named: "ic_white_day_bright")
        }
    }
    
    // MARK: - Private
    
    private func setLocationIcon() {
        self.addSubview(locationIconImage)
        locationIconImage.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.leading.equalTo(self).offset(20)
            make.height.equalTo(20)
            make.width.equalTo(15)
        }
    }
    
    private func setCityLabel() {
        self.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.locationIconImage.snp.trailing).offset(5)
            make.centerY.equalTo(self.locationIconImage)
        }
    }
    
    private func setCurrentDayLabel() {
        self.addSubview(currentDateLabel)
        currentDateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.locationIconImage.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(20)
        }
    }
    
    private func setWeatherImage() {
        self.addSubview(weatherImage)
        weatherImage.snp.makeConstraints { make in
            make.top.equalTo(currentDateLabel.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(35)
            make.height.equalTo(100)
            make.width.equalTo(175)
        }
    }
    
    private func setTemperatureImage() {
        self.addSubview(temperatureImage)
        temperatureImage.snp.makeConstraints { make in
            make.top.equalTo(currentDateLabel.snp.bottom).offset(5)
            make.leading.equalTo(weatherImage.snp.trailing).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(15)
        }
    }
 
    private func setHumidityImage() {
        self.addSubview(humidityImage)
        humidityImage.snp.makeConstraints { make in
            make.top.equalTo(temperatureImage.snp.bottom).offset(10)
            make.leading.equalTo(weatherImage.snp.trailing).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(15)
        }
    }
    
    private func setHumidityLabel() {
        self.addSubview(humidityLabel)
        humidityLabel.snp.makeConstraints { make in
            make.centerY.equalTo(humidityImage)
            make.leading.equalTo(humidityImage.snp.trailing).offset(3)
        }
    }
    
    private func setWindImage() {
        self.addSubview(windImage)
        windImage.snp.makeConstraints { make in
            make.top.equalTo(humidityImage.snp.bottom).offset(10)
            make.leading.equalTo(weatherImage.snp.trailing).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(15)
        }
    }
    
    private func setWindSpeedLabel() {
        self.addSubview(windSpeedLabel)
        windSpeedLabel.snp.makeConstraints { make in
            make.centerY.equalTo(windImage)
            make.leading.equalTo(windImage.snp.trailing).offset(3)
        }
    }
    
    private func setWindDirectionImage() {
        self.addSubview(windDirectionImage)
        windDirectionImage.snp.makeConstraints { make in
            make.centerY.equalTo(windSpeedLabel)
            make.leading.equalTo(windSpeedLabel.snp.trailing).offset(3)
            make.height.equalTo(20)
            make.width.equalTo(15)
        }
    }
}
