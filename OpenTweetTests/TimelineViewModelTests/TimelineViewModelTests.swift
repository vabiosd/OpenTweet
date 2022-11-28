//
//  TimelineViewModelTests.swift
//  OpenTweetTests
//
//  Created by vaibhav singh on 27/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

class TimelineViewModelTests: XCTestCase {
    
    var timelineViewModel: TimeLineViewModel!

    override func setUpWithError() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        timelineViewModel = TimeLineViewModel(localAPIManager: LocalNetworkManager(jsonDecoder: decoder))
    }

    override func tearDownWithError() throws {
        timelineViewModel = nil
    }
    
    /// Checking conversion of a tweet to viewData works as expected
    func testConvertTweetsIntoCellViewData() {
        let tweet1 = Tweet(id: "123", author: "@vaibhav", content: "@Does it work?", avatar: nil, date: Date(), inReplyTo: nil)
        let tweet2 = Tweet(id: "456", author: "@openTweet", content: "@Ah maybe?", avatar: nil, date: Date(), inReplyTo: "123")
        
        let cellViewData = timelineViewModel.convertTweetsIntoCellViewData(tweets: [tweet1, tweet2])
        
        /// Checking count of cellViewData models expected
        XCTAssertEqual(cellViewData.count, 2)
        
        /// Checking some properties of the  cellViewData models
        XCTAssertEqual(cellViewData[0].showThread, true)
        XCTAssertNil(cellViewData[0].replyingTo)
        XCTAssertNotNil(cellViewData[1].replyingTo)
        
    }

}
