//
//  ViewController.swift
//  weatherapp
//
//  Created by Student on 09.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var minTempLabel: UILabel!
    
    @IBOutlet weak var maxTempLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var windDirLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var airPreassureLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var weather: Weather!
    
    var currentWeatherId:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeather()
    }
    
    func loadWeather(){
        let locationId = "523920";
        let weatherUrl = "https://www.metaweather.com/api/location/" + locationId;
        
        let url = URL(string: weatherUrl);
        let request: URLRequest = URLRequest(url: url!);
        URLSession.shared.dataTask(with: request) {(d, resp, err) in
            
            if let err = err {
                print("Unexpected \(err)");
                return;
            }
            
            let decoder = JSONDecoder();
            
            self.weather = try? decoder.decode(Weather.self, from: d!);
            
            self.loadIcon()
            
            DispatchQueue.main.async {
                self.updateView()
            }
        }.resume();
    }
    
    func loadIcon(){
        let abbr = self.weather.weatherElements![self.currentWeatherId].weatherStateAbbr!;
        let iconUrl = "https://www.metaweather.com/static/img/weather/png/64/" + abbr + ".png"
        
        let url = URL(string: iconUrl);
        let request: URLRequest = URLRequest(url: url!);
        URLSession.shared.dataTask(with: request) {(d, resp, err) in
            
            if let err = err {
                print("Unexpected \(err)");
                return;
            }
            
            DispatchQueue.main.async {
                self.weatherIcon.image = UIImage(data: d!)
            }
        }.resume();
    }
    
    func updateView(){
        self.cityName.text = self.weather.title;
        
        self.dateLabel.text = self.weather.weatherElements![self.currentWeatherId].applicableDate;
        
        self.minTempLabel.text = String(format:"%.1f ºC", self.weather.weatherElements![self.currentWeatherId].minTemp!)
        self.maxTempLabel.text = String(format:"%.1f ºC", self.weather.weatherElements![self.currentWeatherId].maxTemp!)
        self.windSpeedLabel.text = String(format:"%.0f km/h", self.weather.weatherElements![self.currentWeatherId].windSpeed!)
        self.windDirLabel.text = self.weather.weatherElements![self.currentWeatherId].windDirectionCompass!
        self.humidityLabel.text = "\(self.weather.weatherElements![self.currentWeatherId].humidity!)"
        self.airPreassureLabel.text = String(format:"%.1f", self.weather.weatherElements![self.currentWeatherId].airPressure!)
        
    }
}
