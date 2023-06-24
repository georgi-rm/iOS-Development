//
//  BlockBook.swift
//  Exam
//
//  Created by Georgi Manev on 5.02.23.
//

import Foundation

class BlockBookData: Codable {
    var bestHeight: Int
}

class ApiData: Codable {
    var blockbook: BlockBookData?
}
