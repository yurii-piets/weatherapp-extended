//
//  CityWeatherItem.swift
//  weatherapp-extended
//
//  Created by plague on 11/1/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation

class CityWeatherItem {
    
    let weatherUrl = "https://www.metaweather.com/api/location/";
    
    var id: Int
    
    var group: DispatchGroup
    
    var image: Data?
    
    var weather: Weather?
    
    init(id: Int, group: DispatchGroup) {
        self.id = id
        self.group = group
        self.loadData();
    }
    
    func loadData(){
        let url = URL(string: self.weatherUrl + "\(self.id)");
        let request: URLRequest = URLRequest(url: url!);
        URLSession.shared.dataTask(with: request) {(d, resp, err) in
            
            if let err = err {
                print("Unexpected \(err)");
                return;
            }
            
            self.weather = try? JSONDecoder().decode(Weather.self, from: d!);
            
            self.loadIcon()
            
        }.resume();
    }
    
    func loadIcon(){
        let abbr = self.weather!.weatherElements![0].weatherStateAbbr!;
        let iconUrl = "https://www.metaweather.com/static/img/weather/png/" + abbr + ".png"
        
        let url = URL(string: iconUrl);
        let request: URLRequest = URLRequest(url: url!);
        URLSession.shared.dataTask(with: request) {(d, resp, err) in
            
            if let err = err {
                print("Unexpected \(err)");
                return;
            }
            
            self.image = d!;
            self.group.leave();
        }.resume();
    }
    
}
