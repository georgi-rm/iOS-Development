//
//  LocalDataManager.swift
//  P01MyWeatherCharts
//
//  Created by Georgi Manev on 25.01.23.
//

import Foundation
import Realm
import RealmSwift

class LocalDataManager {
    static let userDefaults = UserDefaults.standard
    
    static var locationName: String? {
        set {
            userDefaults.set(newValue, forKey: "LocationName")
            userDefaults.synchronize()
        }
        
        get {
            userDefaults.object(forKey: "LocationName") as? String
        }
    }
    
    static var locationsLatitude: String? {
        set {
            userDefaults.set(newValue, forKey: "LocationsLatitude")
            userDefaults.synchronize()
        }
        
        get {
            userDefaults.object(forKey: "LocationsLatitude") as? String
        }
    }
    
    static var locationLongitude: String? {
        set {
            userDefaults.set(newValue, forKey: "LocationLongitude")
            userDefaults.synchronize()
        }
        
        get {
            userDefaults.object(forKey: "LocationLongitude") as? String
        }
    }
    
    static var temperatureUnits: String? {
        set {
            userDefaults.set(newValue, forKey: "TemperatureUnits")
            userDefaults.synchronize()
        }
        
        get {
            userDefaults.object(forKey: "TemperatureUnits") as? String
        }
    }
    
    static var realm = try! Realm(configuration: realmConfig)
    
    static var realmConfig: Realm.Configuration {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = false
        config.schemaVersion = 1
        return config
    }
    
    class func getWeatherData(locationName: String) -> Location? {
        return LocalDataManager.realm.object(ofType: Location.self, forPrimaryKey: locationName)
    }
}
