//
//  ForecastTableViewCell.swift
//  WeatherAppTest
//
//  Created by Демьян on 25.12.2022.
//

import UIKit
import SnapKit

class ForecastTableViewCell: UITableViewCell {
    
    static let id = "ForecastTableViewCell"
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setDateLabel()
        setTemperatureLabel()
        setIconImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setDateLabel() {
        self.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(20)
            make.centerY.equalTo(self)
        }
    }
    
    private func setTemperatureLabel() {
        self.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(self)
        }
    }
    
    private func setIconImageView() {
        self.addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { make in
            make.trailing.equalTo(self).offset(-20)
            make.centerY.equalTo(self)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
    }
    
    public func configureCell(date: String, temperature: String, icon: String) {
        self.temperatureLabel.text = temperature
        self.dateLabel.text = date
        if icon == "Sunny" {
            self.iconImageView.image = UIImage(named: "ic_white_day_bright")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        } else if icon == "Cloudy" || icon ==  "Partly cloudy" {
            self.iconImageView.image = UIImage(named: "ic_white_day_cloudy")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        } else if icon == "Heavy rain" {
            self.iconImageView.image = UIImage(named: "ic_white_day_shower")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        } else if icon == "Light rain" {
            self.iconImageView.image = UIImage(named: "ic_white_day_rain")
        } else if icon == "Thundery outbreaks possible" {
            self.iconImageView.image = UIImage(named: "ic_white_day_thunder")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        } else {
            self.iconImageView.image = UIImage(named: "ic_white_day_bright")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        }
    }
    
}
