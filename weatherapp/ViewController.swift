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
    
    var cityNameString: String?;
    var minTemp: String?;
    var maxTemp: String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationId = "523920";
        let weatherUrl = "https://www.metaweather.com/api/location/" + locationId;
        
        let url = URL(string: weatherUrl);
        let request: URLRequest = URLRequest(url: url!);
        let dataTask = URLSession.shared.dataTask(with: request) {(d, resp, err) in
            
            if let err = err {
                print("Unexpected \(err)");
                return;
            }
            //let json = String(data: d!, encoding: String.Encoding.utf8);
            
            do {
                guard let json =
                    try
                        JSONSerialization.jsonObject(with: d!, options: []) as? [String: Any]
                    else {
                        print("Error");
                        return
                };
                
                self.cityNameString = json["title"] as? String;
//                self.minTemp = json["min_temp"] as? String;
//                self.maxTemp = json["max_temp"] as? String;
                
                print(json["consolidated_weather"]);
                print(json);
                DispatchQueue.main.async {
                    self.updateView()
                }
            }
            catch {
                print("Error");
                return
            }
        };
        
        
        dataTask.resume();
    }
    
    func updateView(){
        self.cityName.text = self.cityNameString;
        self.minTempLabel.text = self.minTemp;
       self.maxTempLabel.text = self.maxTemp;
    }


}
