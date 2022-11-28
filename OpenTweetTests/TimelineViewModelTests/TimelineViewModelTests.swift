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
    // MARK: Properties
    
    var timelineViewModel: TimeLineViewModel!
    let bundle = Bundle(for: TimelineViewModelTests.self)
    var localNetworkManager: LocalNetworkManager!

    // MARK: Lifecycle
    override func setUpWithError() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        localNetworkManager = LocalNetworkManager(jsonDecoder: decoder)
    }

    override func tearDownWithError() throws {
        timelineViewModel = nil
        localNetworkManager = nil
    }
    
    // MARK: Tests
    
    /// Checking conversion of a tweet to viewData works as expected
    func testConvertTweetsIntoCellViewData() {
        initViewModelWithValidJSON()
        
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
    
    /// Testing successful fetch of tweets by the viewModel
    func testSuccesfulTweetsFetch() {
        initViewModelWithValidJSON()
        timelineViewModel.updateTimelineState = { state in
            switch state {
            case .loadedTweets(let tweetCellDataModels):
                XCTAssertEqual(tweetCellDataModels.count, 7)
            case .errorLoadingTweets(_):
                XCTFail("Expected tweet fetching to succeed")
            }
        }
        timelineViewModel.fetchTweets()
    }
    
    /// Testing unsuccessful fetch of tweets by the viewModel
    func testUnsuccessfulTweetFetch() {
        initViewModelWithBrokenJSON()
        timelineViewModel.updateTimelineState = { state in
            switch state {
            case .loadedTweets(_):
                XCTFail("Expected tweet fetching to fail")
            case .errorLoadingTweets(let error):
                XCTAssertEqual(error, NetworkError.invalidResponse.rawValue)
            }
        }
        timelineViewModel.fetchTweets()
    }
    
    //MARK: Helper functions
    
    private func initViewModelWithValidJSON() {
        let localTestEndpoint = LocalTestEndPoint(path: bundle.path(forResource: "ValidTestTimeline",
                                                                    ofType: "json") ?? "")
        timelineViewModel = TimeLineViewModel(localAPIManager: localNetworkManager,
                                              localEndpoint: localTestEndpoint)
    }
    
    private func initViewModelWithBrokenJSON() {
        let localBrokenJSONTestEndpoint = LocalTestEndPoint(path: bundle.path(forResource: "BrokenTestTimeline",
                                                                        ofType: "json") ?? "")
        timelineViewModel = TimeLineViewModel(localAPIManager: localNetworkManager,
                                              localEndpoint: localBrokenJSONTestEndpoint)
    }

}
