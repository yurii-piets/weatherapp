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
    
    @IBOutlet weak var prevBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var weather: Weather!
    
    var currentWeatherId:Int = 0
    
    let weatherUrl = "https://www.metaweather.com/api/location/" + "523920";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prevBtn.isEnabled = false
        self.loadWeather()
        self.initTargets()
    }
    
    func initTargets(){
        self.prevBtn.addTarget(self, action: #selector(prevBtnClicked), for: UIControl.Event.touchUpInside)
        self.nextBtn.addTarget(self, action: #selector(nextBtnClicked), for: UIControl.Event.touchUpInside)
    }
    
    func loadWeather(){
        let url = URL(string: self.weatherUrl);
        let request: URLRequest = URLRequest(url: url!);
        URLSession.shared.dataTask(with: request) {(d, resp, err) in
            
            if let err = err {
                print("Unexpected \(err)");
                return;
            }
            
            self.weather = try? JSONDecoder().decode(Weather.self, from: d!);
            
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
        self.humidityLabel.text = "\(self.weather.weatherElements![self.currentWeatherId].humidity!)" + "%"
        self.airPreassureLabel.text = String(format:"%.0f", self.weather.weatherElements![self.currentWeatherId].airPressure!) + "mbar"
        
    }
    
    @objc func prevBtnClicked(sender: UIButton!){
        self.currentWeatherId -= 1
        self.updateView()
        self.loadIcon()
        if(self.currentWeatherId <= 0) {
            self.prevBtn.isEnabled = false
        }
        self.nextBtn.isEnabled = true
    }
    
    @objc func nextBtnClicked(sender: UIButton!){
        self.currentWeatherId += 1
        self.updateView()
        self.loadIcon()
        if(self.currentWeatherId >= self.weather.weatherElements!.count - 1) {
            self.nextBtn.isEnabled = false
        }
        self.prevBtn.isEnabled = true
    }
}
