//
//  WeatherForecast.swift
//  P01MyWeather
//
//  Created by Georgi Manev on 19.01.23.
//

import Foundation

struct CurrentWeather: Codable  {
    var temperature: Double
    var time: String
    var weathercode: Int
    var winddirection: Double
    var windspeed:Double
}

struct HourlyUnits: Codable {
    var visibility: String
    var surface_pressure: String
    var relativehumidity_2m: String
}

struct Hourly: Codable {
    var visibility: [Double]
    var surface_pressure: [Double]
    var relativehumidity_2m: [Double]
}

struct WeatherForecast: Codable {
    var current_weather: CurrentWeather
    var hourly_units: HourlyUnits
    var hourly: Hourly
}
