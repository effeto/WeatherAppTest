//
//  SearchView.swift
//  WeatherAppTest
//
//  Created by Демьян on 25.12.2022.
//

import UIKit
import SnapKit

class SearchView: UIView {
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_back"), for: .normal)
        return button
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_search"), for: .normal)
        return button
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        return textField
    }()
    
    var backButtonAction: (() -> Void)?
    var searchButtonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = AppHelper.darkBlue
        setBackButton()
        setSearchButton()
        setSearchTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBackButton() {
        self.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTaped), for: .touchUpInside)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.leading.equalTo(self).offset(10)
            make.height.width.equalTo(50)
        }
    }
    
    private func setSearchButton() {
        self.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(searchButtonTaped), for: .touchUpInside)
        
        searchButton.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.trailing.equalTo(self).offset(-10)
            make.height.width.equalTo(50)
        }
        
    }
    
    
    func setSearchTextField() {
        self.addSubview(searchTextField)
        
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalTo(self.backButton)
            make.leading.equalTo(self.backButton.snp.trailing).offset(5)
            make.trailing.equalTo(self.searchButton.snp.leading).offset(-5)
            make.height.equalTo(25)
        }
    }
    
    @objc func backButtonTaped() {
        backButtonAction?()
    }
    
    @objc func searchButtonTaped() {
        searchButtonAction?()
    }
    
}
