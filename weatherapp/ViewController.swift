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
    
    var weather: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            //print(self.weather);
            
            DispatchQueue.main.async {
                self.updateView()
            }
        }.resume();
    }
    
    func updateView(){
        self.cityName.text = self.weather.title;
        
        self.minTempLabel.text = String(format:"%.1f", self.weather.weatherElements![0].minTemp!)
        self.maxTempLabel.text = String(format:"%.1f", self.weather.weatherElements![0].maxTemp!)
    }


}
