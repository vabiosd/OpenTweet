//
//  LocalEndPoint.swift
//  OpenTweet
//
//  Created by vaibhav singh on 23/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

/// Endpoint referencing to tweets stored on a local file conforming to NetworkEndpointProtocol
/// We just need to define a path here since we are fetching from a local file
struct LocalEndPoint: NetworkEndpointProtocol {
    let path: String = Bundle.main.path(forResource: "timeline", ofType: "json") ?? ""
}
