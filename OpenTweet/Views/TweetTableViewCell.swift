//
//  TweetTableViewCell.swift
//  OpenTweet
//
//  Created by vaibhav singh on 26/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import UIKit

final class TweetTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var replyingLabelHeightConstraint: NSLayoutConstraint?
    var showThreadButtonHeightConstraint: NSLayoutConstraint?
    
    private var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var replyingToLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var showThreadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()

    
        //MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setting up views
    
    private func setupComponents() {
        /// adding corners to the avatar image to make it look like a circle!
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        
        /// Setting content hugging priority to make sure date doesn't truncate in case of long author handles
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        [avatarImageView, authorLabel, replyingToLabel, contentLabel, dateLabel, showThreadButton].forEach {
            contentView.addSubview($0)
        }
        
    }
    
    private func setupConstraints() {
        /// constraining avatarImageView to top left corner with a fix width and height
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        ])
        
        /// Constraining the authorLabel at the top, to the right of the avatarImageView
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            authorLabel.heightAnchor.constraint(equalToConstant: 20),
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        ])
        
        
        /// Constraining the dateLabel at the top, to the right of the authorLabel
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 4),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        ])
        
        /// Constraining the replyingToLabel right below the authorLabel
        /// Since all tweets are not replies to other tweets, we keep a reference to its height constraint to be able to hide this label if needed
        replyingLabelHeightConstraint = replyingToLabel.heightAnchor.constraint(equalToConstant: 20)
        NSLayoutConstraint.activate([
            replyingToLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            replyingToLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor),
            replyingToLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            replyingLabelHeightConstraint!
        ])
        
        
        /// Constraining the contentLabel right below replyingToLabel
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            contentLabel.topAnchor.constraint(equalTo: replyingToLabel.bottomAnchor, constant: 8)
        ])
        
        /// Constraining showThreadLabel at the bottom below contentLabel
        /// We keep a reference to its height constraint to be able to hide it for tweets without any replies
        showThreadButtonHeightConstraint = showThreadButton.heightAnchor.constraint(equalToConstant: 20)
        NSLayoutConstraint.activate([
            showThreadButton.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            showThreadButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            showThreadButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            showThreadButtonHeightConstraint!
        ])
    }
    
    /// Updating cell with its viewData
    func updateTweetCell(tweetCellViewData: TweetCellViewData) {
        authorLabel.text = tweetCellViewData.author
        dateLabel.text = tweetCellViewData.date
        contentLabel.text = tweetCellViewData.content
        
        /// Changing the replyingToLabel's height in case  current tweet is not replying to any tweet
        if let replyingToString = tweetCellViewData.replyingTo {
            replyingLabelHeightConstraint?.constant = 20
            replyingToLabel.attributedText = replyingToString
        } else {
            replyingLabelHeightConstraint?.constant = 0
        }
        
        /// Changing the showThreadButton's height in case current tweet doesn't have any replies
        if tweetCellViewData.showThread {
            showThreadButton.setTitle("Show Thread", for: .normal)
            showThreadButtonHeightConstraint?.constant = 20
        } else {
            showThreadButtonHeightConstraint?.constant = 0
        }
        
        avatarImageView.image = UIImage(named: "allthethings")
    }
    
    /// Cleanup cell to prepare it for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        authorLabel.text = ""
        contentLabel.text = ""
        dateLabel.text = ""
        avatarImageView.image = nil
        showThreadButton.setTitle("", for: .normal)
        showThreadButtonHeightConstraint?.constant = 0
        replyingLabelHeightConstraint?.constant = 0
    }

}
