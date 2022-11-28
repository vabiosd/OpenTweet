//
//  DateExtensionTests.swift
//  OpenTweetTests
//
//  Created by vaibhav singh on 28/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import XCTest
import Foundation
@testable import OpenTweet

class DateExtensionTests: XCTestCase {
    
    var calendar: Calendar!
    var dateFormatter: DateFormatter!
    
    override func setUpWithError() throws {
        calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        self.dateFormatter = dateFormatter
    }
    
    override func tearDownWithError() throws {
        dateFormatter = nil
        calendar = nil
    }

    func testGetFormattedDateString() {
        /// Test date a few minutes ago
        let dateFiveMintuesAgo = calendar.date(byAdding: .minute, value: -5, to: Date()) ?? Date()
        XCTAssertEqual(dateFiveMintuesAgo.getFormattedDateString(dateFormatter: dateFormatter), "5m")
        
        /// Test date a few hours ago
        let dateFourHoursAgo = calendar.date(byAdding: .hour, value: -4, to: Date()) ?? Date()
        XCTAssertEqual(dateFourHoursAgo.getFormattedDateString(dateFormatter: dateFormatter), "4h")
        
        /// Test date a few days ago
        let dateTwoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        XCTAssertEqual(dateTwoDaysAgo.getFormattedDateString(dateFormatter: dateFormatter), "2d")
        
        /// Test date 2 weeks ago
        let dateTwoWeeksAgo = calendar.date(byAdding: .day, value: -14, to: Date()) ?? Date()
        XCTAssertEqual(dateTwoWeeksAgo.getFormattedDateString(dateFormatter: dateFormatter), dateFormatter.string(from: dateTwoWeeksAgo))
    }
    

}
