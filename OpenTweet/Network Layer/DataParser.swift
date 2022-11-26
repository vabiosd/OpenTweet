//
//  DataParser.swift
//  OpenTweet
//
//  Created by vaibhav singh on 25/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

/// A generic data parser protocol
protocol DataParserProtocol {
    associatedtype Model
    
    func parseData(data: Data) -> Model?
}

/// Concrete DataParser class handling JSON decoding of the tweets
final class DataParser<T: Decodable>: DataParserProtocol {
    
    func parseData(data: Data) -> T? {
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
