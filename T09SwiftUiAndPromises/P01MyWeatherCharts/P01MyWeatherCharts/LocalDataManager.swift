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
    
    static var temperatureUnits: TemperatureUnits? {
        set {
            userDefaults.set(newValue?.rawValue, forKey: "TemperatureUnits")
            userDefaults.synchronize()
        }
        
        get {
            if let temperatureUnitsAsString = userDefaults.object(forKey: "TemperatureUnits") as? String {
                return TemperatureUnits(rawValue: temperatureUnitsAsString )
            }
            
            return TemperatureUnits.celsius
        }
    }
    
    static var appearanceMode: AppearanceMode? {
        set {
            userDefaults.set(newValue?.rawValue, forKey: "AppearanceMode")
            userDefaults.synchronize()
        }
        
        get {
            if let appearanceModeAsString = userDefaults.object(forKey: "AppearanceMode") as? String {
                return AppearanceMode(rawValue: appearanceModeAsString )
            }
            
            return AppearanceMode.system
        }
    }
    
    
    static var realm = try! Realm(configuration: realmConfig)
    
    static var realmConfig: Realm.Configuration {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        config.schemaVersion = 1
        return config
    }
    
    static var dataForLocation: Location?
    
    class func getWeatherData(locationName: String) -> Location? {
        self.dataForLocation = LocalDataManager.realm.object(ofType: Location.self, forPrimaryKey: locationName)
        return self.dataForLocation
    }
}
