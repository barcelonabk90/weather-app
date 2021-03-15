//
//  WeatherData.swift
//  Clima
//
//  Created by Huyen Le on 2021/03/14.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherResponse : Decodable {
    let list : [WeatherData]
}

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
