//
//  WeatherForecast.swift
//  P01MyWeather
//
//  Created by Georgi Manev on 19.01.23.
//

import Foundation
import Realm
import RealmSwift

class CurrentWeather: Object,ObjectKeyIdentifiable, Codable  {
    @Persisted var temperature: Double
    @Persisted var time: String
    @Persisted var weathercode: Int
    @Persisted var winddirection: Double
    @Persisted var windspeed:Double
}

class HourlyUnits: Object,ObjectKeyIdentifiable, Codable {
    @Persisted var visibility: String
    @Persisted var surface_pressure: String
    @Persisted var relativehumidity_2m: String
    @Persisted var temperature_2m: String
}

class Hourly: Object,ObjectKeyIdentifiable, Codable {
    @Persisted var time: List<String>
    @Persisted var visibility: List<Double>
    @Persisted var surface_pressure: List<Double>
    @Persisted var relativehumidity_2m: List<Double>
    @Persisted var temperature_2m: List<Double>
    @Persisted var precipitation: List<Double>
}

class WeatherForecast: Object,ObjectKeyIdentifiable, Codable {
    @Persisted var current_weather: CurrentWeather?
    @Persisted var hourly_units: HourlyUnits?
    @Persisted var hourly: Hourly?
}

class Location: Object,ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var name: String = ""
    @Persisted var weatherForecast: WeatherForecast? = nil
    @Persisted var temperatureUnits: String = ""
}
