//
//  LocalDataManager.swift
//  Exam
//
//  Created by Georgi Manev on 5.02.23.
//

import Foundation
import RealmSwift

class LocalDataManager {
    static var realm = try! Realm(configuration: realmConfig)
    
    static var realmConfig: Realm.Configuration {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        config.schemaVersion = 1
        return config
    }
    
    static func updateBlocksData() {
        
        var bestHeight: Int?
        var currentHash: String?

        RequestManager.fetchBlockBookData { error, result in
            guard error == nil else {
                print("Error in fetching data")
                return
            }

            guard let resultBlockBookData = result else {
                print("Can not parse data")
                return
            }

            bestHeight = resultBlockBookData.blockbook?.bestHeight ?? 0

            guard let blockHeight = bestHeight else {
                return
            }

            RequestManager.fetchBlockHash(blockHeight: blockHeight) { error, result in
                guard error == nil else {
                    print("Error in fetching data")
                    return
                }

                guard let resultBlockHash = result else {
                    print("Can not parse data")
                    return
                }

                currentHash = resultBlockHash.blockHash

                guard var previousHash = currentHash else {
                    return
                }
                
                for aBlock in 0..<20 {
                    RequestManager.fetchBlockData(blockHash: previousHash) { error, result in
                        guard error == nil else {
                            print("Error in fetching data")
                            return
                        }

                        guard let resultBlockData = result else {
                            print("Can not parse data")
                            return
                        }

                        let blockDataForLocalDatabase = BlockDataInLocalDatabase()
                        blockDataForLocalDatabase.id = aBlock
                        blockDataForLocalDatabase.blockData = resultBlockData
                        blockDataForLocalDatabase.blockHash = previousHash

                        previousHash = resultBlockData.previousBlockHash

                        DispatchQueue.main.async {
                            LocalDataManager.realm.beginWrite()
                            LocalDataManager.realm.add(blockDataForLocalDatabase, update: .all)
                            try? LocalDataManager.realm.commitWrite()
                            NotificationCenter.default.post(name: .dataUpdatedNotification, object: nil)
                        }
                    }
                }
                
            }
        }
    }

    static func getAllBlocksData() -> [BlockDataInLocalDatabase] {
        return Array(LocalDataManager.realm.objects(BlockDataInLocalDatabase.self).sorted(byKeyPath: "id", ascending: true))
    }
    
    
    static let userDefaults = UserDefaults.standard
    
    static var accounts: [String] {
        set {
            userDefaults.set(newValue, forKey: "Accounts")
            userDefaults.synchronize()
        }
        
        get {
            userDefaults.object(forKey: "Accounts") as? [String] ?? []
        }
    }
}
