//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    //MARK: Properties
    
    private let timeLineViewModel: TimeLineViewModel
    private let cellId = "tweetCell"
    
    /// Keeping reference to tableView's horizontal constraints to update the layout for wider devices
    private var tableViewLeadingAnchor: NSLayoutConstraint?
    private var tableViewTrailingAnchor: NSLayoutConstraint?
    
    private var errorView: UILabel = {
        let errorView = UILabel()
        errorView.numberOfLines = 0
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.textAlignment = .center
        errorView.isHidden = true
        return errorView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: Init
    
    init(timeLineViewModel: TimeLineViewModel) {
        self.timeLineViewModel = timeLineViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(" No storyboard found!")
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindState()
        setupComponents()
        setupConstraints()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        /// Update constraints based on the horizontalSizeClass trait
        self.setupTableViewHorizontalConstraints()
    }
    
    //MARK: Setting up views
    
    private func setupComponents() {
        /// Assigning an image as navigation title
        let titleImageView = UIImageView(image: UIImage(named: "opentweet"))
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView

        /// Setting up tableview
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.separatorColor = .gray
    
        /// Adding subviews
        [tableView, errorView].forEach{
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        
        setupTableViewHorizontalConstraints()
        
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            errorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            errorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupTableViewHorizontalConstraints() {
        /// Leveraging size class to adjust tableview's horizontal constraints
        switch traitCollection.horizontalSizeClass {
        case .compact:
            tableViewLeadingAnchor?.isActive = false
            tableViewLeadingAnchor = tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            tableViewLeadingAnchor?.isActive = true
            
            tableViewTrailingAnchor?.isActive = false
            tableViewTrailingAnchor = tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            tableViewTrailingAnchor?.isActive = true
        case .regular:
            let horizontalInsets = view.frame.width / 6.0
            tableViewLeadingAnchor?.isActive = false
            tableViewLeadingAnchor = tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalInsets)
            tableViewLeadingAnchor?.isActive = true
            
            tableViewTrailingAnchor?.isActive = false
            tableViewTrailingAnchor = tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalInsets)
            tableViewTrailingAnchor?.isActive = true
        default:
            break
        }
    }
    
   //MARK: Setting up viewModel bindings
    
    private func bindState() {
        timeLineViewModel.updateTimelineState = {[weak self] state in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async {
                /// Updating the UI based on the state
                switch state {
//                case .loading:
                    /// In case of a real app fetching data over network, we can add a loading UI here
                case .errorLoadingTweets(let errorString):
                    /// Hiding tableView and showing errorView, in case of an error fetching tweets
                    self.tableView.isHidden = true
                    self.errorView.isHidden = false
                    self.errorView.text = errorString
                case .loadedTweets(let tweets):
                    /// In case there are no tweets available to show
                    if tweets.count == 0 {
                        self.tableView.isHidden = true
                        self.errorView.isHidden = false
                        self.errorView.text = "Nothing to show here, follow some folks to see their posts!"
                    } else {
                        /// reload the tableView to display all available tweets~!
                        self.errorView.isHidden = true
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        timeLineViewModel.fetchTweets()
    }

}

//MARK: TableViewDataSource

extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeLineViewModel.tweetCellViewDataCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        cell.updateTweetCell(tweetCellViewData: timeLineViewModel.tweetCellViewDataCollection[indexPath.row])
        
        return cell
    }
}
