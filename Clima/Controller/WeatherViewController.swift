//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

//MARK:- WeatherViewController : UIViewController
class WeatherViewController: UIViewController {
    
    @IBOutlet weak var searchTextView: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextView.delegate = self
    }
    
}

//MARK:- WeatherViewController : WeatherManagerDelegate
extension WeatherViewController : WeatherManagerDelegate {
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
}

//MARK:- WeatherViewController : UITextFieldDelegate
extension WeatherViewController : UITextFieldDelegate {
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

//MARK:- WeatherViewController : CLLocationManagerDelegate
extension WeatherViewController : CLLocationManagerDelegate {
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetWeather(lat: lat, lon: lon)
        }
    }
}
