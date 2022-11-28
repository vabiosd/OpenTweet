//
//  Tweet.swift
//  OpenTweet
//
//  Created by vaibhav singh on 25/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

typealias TweetID = String

/// Individual Tweet object of the Timeline
struct Tweet: Identifiable, Decodable {
    
    /// Tweet Identifier
    let id: TweetID
    
    let author: String
    
    let content: String
    
    let avatar: URL?
    
    let date: Date
    
    /// Optional Tweet Identifier in case the tweet is a reply to another tweet
    let inReplyTo: TweetID?
}

