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

    class func fetchData() {
        
        guard let locationName = LocalDataManager.locationName,
              let latitude = LocalDataManager.locationsLatitude,
              let longitude = LocalDataManager.locationLongitude else {
                return
            }
        
        
        var url = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true&hourly=visibility,surface_pressure,relativehumidity_2m,temperature_2m,precipitation"
        
        
        if let temperatureUnits = LocalDataManager.temperatureUnits {
            if( temperatureUnits == .fahrenheit ) {
                url += "&temperature_unit=fahrenheit"
            }
        }
        
        AF.request(url).responseDecodable(of:WeatherForecast.self) { response in
            guard let weather = response.value else {
                return
            }
            
            let location = Location()
            location.name = locationName
            location.weatherForecast = weather
            location.temperatureUnits = LocalDataManager.temperatureUnits?.rawValue ?? TemperatureUnits.celsius.rawValue
            
            DispatchQueue.main.async {
                try? LocalDataManager.realm.write{
                    LocalDataManager.realm.add(location, update: .all)
                }
                NotificationCenter.default.post(name: .dataUpdated, object: nil)
            }
        }
    }
}
