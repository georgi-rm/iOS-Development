//
//  RequestManager.swift
//  Exam
//
//  Created by Georgi Manev on 5.02.23.
//

import Foundation
import Alamofire

let baseApiUrl = "https://btc.explorer.changex.io/"

class RequestManager {
    
    static func fetchBlockBookData(completion: @escaping((_ error: String?, _ result: ApiData?) -> Void)) {
        
        let url = "\(baseApiUrl)api/"
        
        AF.request(url, method: .get).responseDecodable(of: ApiData.self) { (blockBookDataResponse) in
            
            guard blockBookDataResponse.error == nil else {
                completion(blockBookDataResponse.error?.localizedDescription, nil)
                return
            }
            
            guard let responseValue = blockBookDataResponse.value else {
                completion("No valid response", nil)
                return
            }
            
            completion(nil, responseValue)
        }
    }
    
    static func fetchBlockHash(blockHeight: Int, completion: @escaping((_ error: String?, _ result: BlockHash?) -> Void)) {
        
        let url = "\(baseApiUrl)api/v2/block-index/\(blockHeight)/"
        
        AF.request(url, method: .get).responseDecodable(of: BlockHash.self) { (blockHashResponse) in
            
            guard blockHashResponse.error == nil else {
                completion(blockHashResponse.error?.localizedDescription, nil)
                return
            }
            
            guard let responseValue = blockHashResponse.value else {
                completion("No valid response", nil)
                return
            }
            
            completion(nil, responseValue)
        }
    }
    
    static func fetchBlockData(blockHash: String, completion: @escaping((_ error: String?, _ result: BlockData?) -> Void)) {
        
        let url = "\(baseApiUrl)api/v2/block/\(blockHash)"
        
        AF.request(url, method: .get).responseDecodable(of: BlockData.self) { (blockDataResponse) in
            
            guard blockDataResponse.error == nil else {
                completion(blockDataResponse.error?.localizedDescription, nil)
                return
            }
            
            guard let responseValue = blockDataResponse.value else {
                completion("No valid response", nil)
                return
            }
            
            completion(nil, responseValue)
        }
    }
    
    
    static func fetchCheckAccount(accountAddress: String, completion: @escaping((_ error: String?, _ result: AccountData?) -> Void)) {

        let url = "\(baseApiUrl)api/v2/address/\(accountAddress)"
        
        AF.request(url, method: .get).responseDecodable(of: AccountData.self) { (accountDataResponse) in
            
            guard accountDataResponse.error == nil else {
                completion(accountDataResponse.error?.localizedDescription, nil)
                return
            }
            
            guard let responseValue = accountDataResponse.value else {
                completion("No valid response", nil)
                return
            }
            
            completion(nil, responseValue)
        }
    }
}
