//
//  APIManagerProtocol.swift
//  OpenTweet
//
//  Created by vaibhav singh on 23/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

/// Protocol used to fetch data using a generic endpoint returning a generic data model
/// In case of a real app with networking we can declare a MockAPIManager to mock fetching data and write unit tests for networking 
protocol NetworkManagerProtocol {
    func getData<T: Decodable>(networkEndpoint: NetworkEndpointProtocol, completion: @escaping (Result<T, NetworkError>) -> ())
}

/// Local data manager conforming to the above protocol and fetching data from a local file
final class LocalNetworkManager: NetworkManagerProtocol {
    private let jsonDecoder: JSONDecoder
    
    /// Injected JSONDecoder to support decoding varied responses
    init(jsonDecoder: JSONDecoder) {
        self.jsonDecoder = jsonDecoder
    }
    
    func getData<T: Decodable>(networkEndpoint: NetworkEndpointProtocol, completion: @escaping (Result<T, NetworkError>) -> ()) {
        /// Reading the contents of the local JSON file and decoding it into the the TimeLine struct
        if let data = try? Data(contentsOf: URL(fileURLWithPath: networkEndpoint.path)),
           let model = try? jsonDecoder.decode(T.self, from: data) {
            completion(.success(model))
            
        } else {
            completion(.failure(.invalidResponse))
        }
    }
    
    
}
