//
//  APIError.swift
//  OpenTweet
//
//  Created by vaibhav singh on 23/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

/// An enum depicting various error cases
/// In a real application that fetches data from the network, these might include network error, server error etc
enum NetworkError: String, Error {
    case invalidResponse = "Unable to load data!"
}
