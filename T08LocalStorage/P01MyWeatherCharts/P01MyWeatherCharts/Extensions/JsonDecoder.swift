//
//  JsonDecoder.swift
//  P01MyWeather
//
//  Created by Georgi Manev on 19.01.23.
//

import Foundation

extension JSONDecoder {
    class var snakeCaseDecoder: JSONDecoder {
        let snakeCaseDecoder = JSONDecoder()
        snakeCaseDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return snakeCaseDecoder
    }
}
