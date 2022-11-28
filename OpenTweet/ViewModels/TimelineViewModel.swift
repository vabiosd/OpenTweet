//
//  TimelineViewModel.swift
//  OpenTweet
//
//  Created by vaibhav singh on 26/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

/// An enum depicting various states of the timeline
enum TimeLineState {
    /// In case of a real app with networking there would be a loading state
    case loading
    case loadedTweets([TweetCellViewData])
    case errorLoadingTweets(String)
}

/// Timeline viewModel responsible for fetching tweets and converting them into TweetCellViewData
final class TimeLineViewModel {
    private let localAPIManager: NetworkManagerProtocol
    
    /// Local viewModel timelineState which updates the TimelineViewController using the updateTimelineState closure
    private var timelineState: TimeLineState = .loading {
        didSet {
            updateTimelineState?(timelineState)
        }
    }
    
    /// DateFormatter used to format dates, its declared as a property here to avoid initialising it multiple times for each date
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    /// A local collection holding all the tweets
    var tweetCellViewDataCollection: [TweetCellViewData] = []
    
    ///  Closure used to update TimelineViewController when TimeLineState changes
    var updateTimelineState: ((TimeLineState) -> ())?
    
    init(localAPIManager: NetworkManagerProtocol) {
        self.localAPIManager = localAPIManager
    }
    
    /// Fetching tweets using the localAPIManager
    func fetchTweets() {
        /// empty the local collection when a new fetch starts
        tweetCellViewDataCollection = []
        timelineState = .loading
        localAPIManager.getData(networkEndpoint: LocalEndPoint()) { [weak self] (result: Result<TimeLine, NetworkError>) in
            guard let self = self else {
                return
            }
            switch result {
                /// updating the viewModel's timelineState based of the data fetching result
            case .success(let timeLine):
                let tweetCellViewDataCollection = self.convertTweetsIntoCellViewData(tweets: timeLine.timeline)
                self.timelineState = .loadedTweets(tweetCellViewDataCollection)
                self.tweetCellViewDataCollection = tweetCellViewDataCollection
            case .failure(let error):
                self.timelineState = .errorLoadingTweets(error.rawValue)
            }
        }
    }
    
    /// Helper function to transform a tweet to displayable TweetCellViewData
    func convertTweetsIntoCellViewData(tweets: [Tweet]) -> [TweetCellViewData] {
        var tweetCellViewData: [TweetCellViewData] = []
        /// A map of TweetID to userName to build up replyingTo string for tweets which are replies with other tweets
        let tweetIDMap = makeTweetIDMap(tweets: tweets)
        /// A set of tweets containing replies
        let tweetsWithReplies = Set(tweets.compactMap{ $0.inReplyTo })
        for tweet in tweets {
            tweetCellViewData.append(TweetCellViewData(author: tweet.author,
                                                       /// Figure out if the current tweet is a reply to another tweet
                                                       replyingTo: getReplyingToString(forTweet: tweet, tweetIDMap: tweetIDMap),
                                                       avatar: tweet.avatar,
                                                       /// Show threads for only tweets with replies
                                                       showThread: tweetsWithReplies.contains(tweet.id),
                                                       date: tweet.date.offset(dateFormatter: dateFormatter),
                                                       content: tweet.content))
        }
        return tweetCellViewData
    }
    
    /// Helper function used to provide replyingToLabel value
    private func getReplyingToString(forTweet tweet: Tweet, tweetIDMap: [TweetID: String]) -> NSAttributedString? {
        if let inReplyToID = tweet.inReplyTo, let inReplyToUsername = tweetIDMap[inReplyToID]  {
            let attributedString = NSMutableAttributedString(string: "Replying to", attributes: [.foregroundColor: UIColor.gray.cgColor])
            attributedString.append(NSAttributedString(string: " \(inReplyToUsername)", attributes: [.foregroundColor: UIColor.systemBlue.cgColor]))
            return attributedString
        } else {
            return nil
        }
    }
    
    /// Helper function to make a map of TweetID to userName
    private func makeTweetIDMap(tweets: [Tweet]) -> [TweetID: String] {
        var dict: [TweetID: String] = [:]
        for tweet in tweets {
            dict[tweet.id] = tweet.author
        }
        return dict
    }
    
    
}

