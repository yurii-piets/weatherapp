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
    
    var weather: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeather()
//        loadIcon()
        
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
            
            self.loadIcon(abbr: self.weather.weatherElements![0].weatherStateAbbr!)
            
            DispatchQueue.main.async {
                self.updateView()
            }
        }.resume();
    }
    
    func loadIcon(abbr: String){
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
        
        self.minTempLabel.text = String(format:"%.1f ºC", self.weather.weatherElements![0].minTemp!)
        self.maxTempLabel.text = String(format:"%.1f ºC", self.weather.weatherElements![0].maxTemp!)
        self.windSpeedLabel.text = String(format:"%.0f km/h", self.weather.weatherElements![0].windSpeed!)
        self.windDirLabel.text = self.weather.weatherElements![0].windDirectionCompass!
        self.humidityLabel.text = "\(self.weather.weatherElements![0].humidity!)"
        self.airPreassureLabel.text = String(format:"%.1f", self.weather.weatherElements![0].airPressure!)
        
    }
    
    func updateIcon(){
        
    }


}
