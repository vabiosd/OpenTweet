//
//  TimeLine.swift
//  OpenTweet
//
//  Created by vaibhav singh on 25/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

/// A struct encapsulating a Twitter Timeline!
struct TimeLine: Decodable {
    let timeline: [Tweet]
}
