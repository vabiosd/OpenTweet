//
//  LocalSuccesTestEndPoint.swift
//  OpenTweetTests
//
//  Created by vaibhav singh on 26/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation
@testable import OpenTweet

/// Endpoint pointing to a test JSON file
struct LocalTestEndPoint: NetworkEndpointProtocol {
    var path: String
}
