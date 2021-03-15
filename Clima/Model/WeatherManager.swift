//
//  WeatherManager.swift
//  Clima
//
//  Created by Huyen Le on 2021/03/11.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weather : WeatherModel)
    func didFailWithError(_ error : Error)
}

struct WeatherManager {
    var delegate : WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/find?appid=xxxxxxxxxxxxxxxxxxxxxxxxxxxx&units=metric"
    
    func fetchWeather(cityName : String) {
        let url = "\(weatherURL)&q=\(cityName)"
        print(url)
        perfomRequest(urlRequest: url)
    }
    
    func perfomRequest(urlRequest : String) {
        if let url = URL(string: urlRequest) {
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url){(data, urlResponse, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSONData(weatherData: safeData) {
                        print(weather)
                        self.delegate?.didUpdateWeather(weather)
                    }
                }
            }
            task.resume()
        }
        
    }
    
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
