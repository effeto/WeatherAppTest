//
//  SearchTableViewCell.swift
//  WeatherAppTest
//
//  Created by Демьян on 25.12.2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    static let id = "SearchTableViewCell"
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setTextLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTextLabel() {
        self.addSubview(resultLabel)
        
        resultLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalTo(self)
        }
    }
    
    public func configureCell(city: String, country: String) {
        self.resultLabel.text = "\(city), \(country)"
    }
}
