//
//  MapView.swift
//  WeatherAppTest
//
//  Created by Демьян on 25.12.2022.
//

import UIKit
import SnapKit
import MapKit

class MapView: UIView {
    
    let searchBarView = SearchView()
    let mapView = MKMapView()
    weak var searchTableView: UITableView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setSearchBarView()
        setMapView()
        setSearchTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSearchBarView() {
        self.addSubview(searchBarView)
        
        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(125)
        }
    }
    
    func setMapView() {
        self.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self.searchBarView.snp.bottom)
            make.bottom.equalTo(self)
            make.width.equalTo(self)
        }
    }
    
    private func setSearchTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
        tableView.isHidden = true
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchBarView.snp.bottom)
            make.width.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        self.searchTableView = tableView
    }
}
