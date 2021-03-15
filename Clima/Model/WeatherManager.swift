//
//  WeatherManager.swift
//  Clima
//
//  Created by Huyen Le on 2021/03/11.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weather : WeatherModel)
    func didFailWithError(_ error : Error)
}

// Logic App
struct WeatherManager {
    var delegate : WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/find?appid=xxx&units=metric"
    
    // Get weather info by city name
    func fetchWeather(cityName : String) {
        let url = "\(weatherURL)&q=\(cityName)"
        perfomRequest(urlRequest: url)
    }
    
    // Get weather info by latitude and longtitude
    func fetWeather(lat : CLLocationDegrees, lon : CLLocationDegrees) {
        let url = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        perfomRequest(urlRequest: url)
    }
    
    // Send request and get response
    func perfomRequest(urlRequest : String) {
        // Create URL
        if let url = URL(string: urlRequest) {
            
            // Create URLSession
            let urlSession = URLSession(configuration: .default)
            
            // Create task
            let task = urlSession.dataTask(with: url){(data, urlResponse, error) in
                
                // Check Errors
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                // Get response
                if let safeData = data {
                    // Parse JSON data
                    if let weather = self.parseJSONData(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    // Parse JSON data method
    func parseJSONData(weatherData : Data) -> WeatherModel?{
        do {
            let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: weatherData)
            if decodedData.list.count > 0 {
                let weatherData = decodedData.list[0]
                let id = weatherData.weather[0].id
                let name = weatherData.name
                let temperature = weatherData.main.temp
                let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temperature)
                return weatherModel
            }
            
        } catch {
            self.delegate?.didFailWithError(error)
        }
        return nil
    }
}
