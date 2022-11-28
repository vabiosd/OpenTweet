//
//  AppCoordinator.swift
//  OpenTweet
//
//  Created by vaibhav singh on 27/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

/// A protocol describing the signature of a coordinator used to extract navigation code out of viewControllers thus making viewControllers independent of each other
protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}


/// AppCoordinator responsible for starting the flow of the app by initialising and presenting the initial TimelineViewController
class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// Function used to initialise a viewController with all its dependencies and push it on the navigationController
    func start() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        let timeLineViewModel = TimeLineViewModel(localAPIManager: LocalNetworkManager(jsonDecoder: jsonDecoder),
                                                  localEndpoint: LocalEndPoint())
        navigationController.pushViewController(TimelineViewController(timeLineViewModel: timeLineViewModel), animated: true)
    }
    
    
}
