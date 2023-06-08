//
//  RequestManager.swift
//  P01MyWeather
//
//  Created by Georgi Manev on 19.01.23.
//

import Foundation
import Alamofire
import Realm
import RealmSwift

enum LoadingState {
    case loading
    case loaded
}

class RequestManager {
    static var loadingState: LoadingState = .loading
    static var weatherData: WeatherForecast?
    
    class func getDataFromLocalDataBase() {
        guard let locationName = LocalDataManager.locationName,
              let locationData = LocalDataManager.getWeatherData(locationName: locationName) else {
                return
            }
            
        weatherData = locationData.weatherForecast
        
        if weatherData == nil {
            loadingState = .loading
            return
        }
        loadingState = .loaded
        
        return
    }
    
    class func fetchData() {
        loadingState = .loading
        
        guard let locationName = LocalDataManager.locationName,
              let latitude = LocalDataManager.locationsLatitude,
              let longitude = LocalDataManager.locationLongitude else {
                return
            }
        
        let url = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true&hourly=visibility,surface_pressure,relativehumidity_2m"
        
        AF.request(url).responseDecodable(of:WeatherForecast.self) { response in
            guard let weather = response.value else {
                return
            }
            
            weatherData = weather
            
            let location = Location()
            location.name = locationName
            location.weatherForecast = weather
            
            DispatchQueue.main.async {
                try? LocalDataManager.realm.write{
                    LocalDataManager.realm.add(location, update: .all)
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name("dataUpdated"), object: nil)
        }
           
        loadingState = .loaded
    }
}
