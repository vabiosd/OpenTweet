//
//  LocalNetworkManagerTests.swift
//  OpenTweetTests
//
//  Created by vaibhav singh on 26/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

class LocalNetworkManagerTests: XCTestCase {
    
    var localNetworkManager: NetworkManagerProtocol!
    let bundle = Bundle(for: LocalNetworkManagerTests.self)

    override func setUpWithError() throws {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        localNetworkManager = LocalNetworkManager(jsonDecoder: jsonDecoder)
    }

    override func tearDownWithError() throws {
        localNetworkManager = nil
    }

    /// Testing successful fetching of tweets
    /// If given more time I would break this test down to multiple tests to check different parameters of a tweet
    func testValidTimelineFetch() {
        let localTestEndpoint = LocalTestEndPoint(path: bundle.path(forResource: "ValidTestTimeline",
                                                                    ofType: "json") ?? "")
        localNetworkManager.getData(networkEndpoint: localTestEndpoint) { (result: Result<TimeLine, NetworkError>) in
            switch result {
            case .success(let timeline):
                let tweets = timeline.timeline
                /// testing tweet count
                XCTAssertEqual(tweets.count, 7)
                
                guard let originalTweet = tweets.filter({ $0.id == "00042" }).first  else {
                    XCTFail("Expected a tweet with id 00042, but found none!")
                    return
                }
                
                /// testing an original tweet from the timeline
                XCTAssertEqual(originalTweet.author, "@olarivain")
                XCTAssertNil(originalTweet.inReplyTo)
                
                let tweetReplies = tweets.filter{ $0.inReplyTo == originalTweet.id}
                
                /// testing tweet replies
                XCTAssertEqual(tweetReplies.count, 3)
                guard let tweetReply = tweetReplies.filter( { $0.id == "00003" } ).first else {
                    XCTFail("Expected a tweet reply with id 00003")
                    return
                }
                
                XCTAssertEqual(tweetReply.author, "@randomInternetStranger")
            case .failure( _):
                XCTFail("Expected fetching local data to succeed")
            }
        }
    }
    
    /// Testing invalid response should fail the decoding
    ///  The content key is changed to content_text to simulate broken JSON structure
    func testBrokenTimelineFetch() {
        let localTestEndpoint = LocalTestEndPoint(path: bundle.path(forResource: "BrokenTestTimeline",
                                                                    ofType: "json") ?? "")
        localNetworkManager.getData(networkEndpoint: localTestEndpoint) { (result: Result<TimeLine, NetworkError>) in
            switch result {
            case .success(_):
                XCTFail("Excepted JSON decoding to fail")
            case .failure(let error):
                XCTAssertEqual(error, .invalidResponse)
            }
        }
    }

}
