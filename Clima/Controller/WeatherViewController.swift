//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, WeatherManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextView: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Deo dc roi")
        
        weatherManager.delegate = self
        searchTextView.delegate = self
    }
    
    func didUpdateWeather(_ weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = weather.temperatureString
        }
        
    }
    
    func didFailWithError(_ error : Error) {
        print(error)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextView.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextView.endEditing(true)
        return true
    }
    
    internal func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextView.text != "" {
            return true
        } else {
            searchTextView.placeholder = "Write something "
            return false
        }
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = searchTextView.text {
            print(cityName)
            weatherManager.fetchWeather(cityName: cityName)
        }
        searchTextView.text = ""
    }
}

