//
//  ViewModel.swift
//  SwiftUIDemo
//
//  Created by Georgi Manev on 30.01.23.
//

import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject {
    static let instance = WeatherViewModel()
    @Published var locationText: String = "Loading ..."
    @Published var weatherConditionText: String = "Loading ..."
    @Published var weatherConditionIconName: String = "clear"
    
    @Published var temperatureDetail: String = "Loading ..."
    @Published var humidityDetail: String = "Loading ..."
    @Published var surfacePressureDetail: String = "Loading ..."
    @Published var winddirectionDetail: String = "Loading ..."
    @Published var windspeedDetail: String = "Loading ..."
    @Published var visibilityDetail: String = "Loading ..."
    @Published var lastUpdatedDetail: String = "Loading ..."
    
    init() {
        NotificationCenter.default.addObserver(forName: .dataUpdated,
                                               object: nil,
                                               queue: OperationQueue.main ) {
            [weak self] _ in
            
            if let locationName = LocalDataManager.locationName,
                  let latitude = LocalDataManager.locationsLatitude,
                  let longitude = LocalDataManager.locationLongitude,
                  locationName.count > 0,
                  latitude.count > 0,
                  longitude.count > 0 {
                self?.locationText = "\(locationName) ( \(latitude), \(longitude) )"
                
            } else {
                self?.locationText = "Invalid location"
            }
            
            guard let weatherForecast = LocalDataManager.dataForLocation?.weatherForecast else {
                return
            }
            
            switch weatherForecast.current_weather?.weathercode {
            case 0:
                self?.weatherConditionText = "Clear sky"
                self?.weatherConditionIconName = "sun.max"
            case 1, 2, 3:
                self?.weatherConditionText = "Cloudy"
                self?.weatherConditionIconName = "cloud"
            case 45, 48:
                self?.weatherConditionText = "Fog"
                self?.weatherConditionIconName = "cloud.fog"
            case 51, 53, 55, 56, 57:
                self?.weatherConditionText = "Drizzle"
                self?.weatherConditionIconName = "cloud.drizzle"
            case 61, 63, 65, 66, 67:
                self?.weatherConditionText = "Rain"
                self?.weatherConditionIconName = "cloud.rain"
            case 71, 73, 75, 77:
                self?.weatherConditionText = "Snow fall"
                self?.weatherConditionIconName = "cloud.snow"
            case 80, 81, 82:
                self?.weatherConditionText = "Rain showers"
                self?.weatherConditionIconName = "cloud.heavyrain"
            case 85, 86:
                self?.weatherConditionText = "Snow showers"
                self?.weatherConditionIconName = "cloud.hail"
            case 95, 96, 99:
                self?.weatherConditionText = "Thunderstorm"
                self?.weatherConditionIconName = "cloud.bolt.rain"
            default:
                self?.weatherConditionText = "Loading ..."
                self?.weatherConditionIconName = "clear"
            }
            
            self?.temperatureDetail = "\(weatherForecast.current_weather?.temperature.description ?? "") \(LocalDataManager.temperatureUnits?.rawValue ?? TemperatureUnits.celsius.rawValue)"
            
            self?.humidityDetail = "\(weatherForecast.hourly?.relativehumidity_2m [0].description ?? "") \(weatherForecast.hourly_units?.relativehumidity_2m ?? "")"
            
            self?.surfacePressureDetail = "\(weatherForecast.hourly?.surface_pressure[0].description ?? "") \(weatherForecast.hourly_units?.surface_pressure ?? "")"
            
            self?.winddirectionDetail = "\(weatherForecast.current_weather?.winddirection.description ?? "")"
            
            self?.windspeedDetail = "\(weatherForecast.current_weather?.windspeed.description ?? "" )"
            
            self?.visibilityDetail = "\(weatherForecast.hourly?.visibility[0].description ?? "") \(weatherForecast.hourly_units?.visibility ?? "")"
            
            self?.lastUpdatedDetail = "\(weatherForecast.current_weather?.time ?? "")"
        }
    }
}
