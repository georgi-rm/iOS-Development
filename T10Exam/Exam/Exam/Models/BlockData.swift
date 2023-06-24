//
//  BlockData.swift
//  Exam
//
//  Created by Georgi Manev on 5.02.23.
//

import Foundation
import RealmSwift

class BlockTransaction: Object, Codable {
    @Persisted var txid: String
}

class BlockHash: Codable {
    var blockHash: String
}

class BlockData: Object, Codable {
    @Persisted var height: Int
    @Persisted var previousBlockHash: String
    @Persisted var time: Int
    @Persisted var merkleRoot: String
    @Persisted var txs: List<BlockTransaction>
    @Persisted var nonce: String
}

class BlockDataInLocalDatabase: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var blockHash: String = ""
    @Persisted var blockData: BlockData? = nil
}

extension BlockData {
    var eTime: Date {
        return Date(timeIntervalSince1970: TimeInterval(self.time))
    }
}
