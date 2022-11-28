//
//  TweetCellData.swift
//  OpenTweet
//
//  Created by vaibhav singh on 26/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation
 
/// ViewData corresponding to various UI elements of the cell
struct TweetCellViewData {
    let author: String
    let replyingTo: NSAttributedString?
    let avatar: URL?
    let showThread: Bool
    let date: String
    let content: String
}
