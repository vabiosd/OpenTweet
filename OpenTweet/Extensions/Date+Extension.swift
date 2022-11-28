//
//  Date+Extension.swift
//  OpenTweet
//
//  Created by vaibhav singh on 28/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

/// A simple extension on Date to get time elapsed since the tweet was created
extension Date {
    /// Returns the number of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the number of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the number of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the number of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    /// Returns the a custom time interval description from another date or formats the date if its more than a week old
    func offset(from date: Date = Date(), dateFormatter: DateFormatter) -> String {
        if abs(days(from: date)) > 6 {
            return dateFormatter.string(from: date)
        } else if abs(days(from: date)) > 0 {
            return "\(abs(days(from: date)))d"
        } else if abs(hours(from: date)) > 0 {
            return "\(abs(hours(from: date)))h"
        } else if abs(minutes(from: date)) > 0 {
            return "\(abs(minutes(from: date)))m"
        } else if abs(seconds(from: date)) > 0 {
            return "\(abs(seconds(from: date)))s"
        }
        return ""
    }
}
