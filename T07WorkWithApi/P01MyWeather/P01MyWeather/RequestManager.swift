//
//  RequestManager.swift
//  P01MyWeather
//
//  Created by Georgi Manev on 19.01.23.
//

import Foundation

enum LoadingState {
    case loading
    case loaded
}

class RequestManager {
    static var loadingState: LoadingState = .loading
    
    static var temperature: Double = 0.0
    static var winddirection: Double = 0.0
    static var windspeed: Double = 0.0
    static var time: String = ""
    static var weathercode: Int = 0
    static var visibility: Double = 0.0
    static var surfacePressure: Double = 0.0
    static var relativehumidity2m: Double = 0.0
    static var visibilityUnit: String = ""
    static var surfacePressureUnit: String = ""
    static var relativehumidity2mUnit: String = ""
    
    class func fetchData( latitude: String, longitude: String ) {
        loadingState = .loading
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true&hourly=visibility,surface_pressure,relativehumidity_2m")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in guard let data = data, let weather = try? JSONDecoder().decode(WeatherForecast.self, from: data) else {
                return
                }
            print(weather)
            
            RequestManager.temperature = weather.current_weather.temperature
            RequestManager.winddirection = weather.current_weather.winddirection
            RequestManager.windspeed = weather.current_weather.windspeed
            RequestManager.time = weather.current_weather.time
            RequestManager.weathercode = weather.current_weather.weathercode
            
            RequestManager.visibilityUnit = weather.hourly_units.visibility
            RequestManager.surfacePressureUnit = weather.hourly_units.surface_pressure
            RequestManager.relativehumidity2mUnit = weather.hourly_units.relativehumidity_2m
        
            let date = Date()
            let calendar = Calendar.current
            let currentHour = calendar.component(.hour, from: date)
        
            guard currentHour < weather.hourly.visibility.count,
                  currentHour < weather.hourly.surface_pressure.count,
                  currentHour < weather.hourly.relativehumidity_2m.count else {
                RequestManager.visibility = 0.0
                RequestManager.surfacePressure = 0.0
                RequestManager.relativehumidity2m = 0.0
                return
            }
        
            RequestManager.visibility = weather.hourly.visibility[currentHour]
            RequestManager.surfacePressure = weather.hourly.surface_pressure[currentHour]
            RequestManager.relativehumidity2m = weather.hourly.relativehumidity_2m[currentHour]

        
            NotificationCenter.default.post(name: NSNotification.Name("dataUpdated"), object: nil)
        })
        loadingState = .loaded
        task.resume()
    }
}
