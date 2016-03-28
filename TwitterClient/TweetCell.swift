//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Hoang Trung Hieu on 3/27/16.
//  Copyright © 2016 Hoang Trung Hieu. All rights reserved.
//

import UIKit
import AFNetworking
import NSDateMinimalTimeAgo

class TweetCell: UITableViewCell {

    @IBOutlet weak var retweetView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var retweetsCount: UILabel!
    @IBOutlet weak var favoritesCount: UILabel!
    @IBOutlet weak var favoriteImageView: NSLayoutConstraint!
    
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var pictureContentImageView: UIImageView!
    
    
    // Contraint outlet
    
    @IBOutlet weak var textBottomContraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 4
        pictureContentImageView.layer.cornerRadius = 4
        retweetView.hidden = true
        // Initialization code
    }
    
    func setTweetContent(tweet: Tweet) {
        contentLabel.text = tweet.text
        if tweet.retweetsCount > 0 {
            retweetsCount.text = "\(tweet.retweetsCount)"
            retweetsCount.hidden = false
        } else {
            retweetsCount.hidden = true
        }
        
        if tweet.retweetedScreenName != nil {
            retweetView.hidden = false
            retweetLabel.text = tweet.retweetedScreenName
        }
        
        if tweet.favoritesCount > 0 {
            favoritesCount.hidden = false
            favoritesCount.text = "\(tweet.favoritesCount)"
        } else {
            favoritesCount.hidden = true
        }
        createdAtLabel.text = tweet.timestamp!.timeAgo()
        nameLabel.text = tweet.user?.name
        screenNameLabel.text = tweet.user?.screenName
        profileImageView.setImageWithURL(tweet.profileImageURL!)
        if tweet.contentImageURL != nil {
            pictureContentImageView.hidden = false
            pictureContentImageView.setImageWithURL(tweet.contentImageURL!)
        } else {
            pictureContentImageView.hidden = true
            textBottomContraint.constant = 8
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
