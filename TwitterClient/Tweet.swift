//
//  Tweet.swift
//  TwitterClient
//
//  Created by Hoang Trung Hieu on 3/25/16.
//  Copyright © 2016 Hoang Trung Hieu. All rights reserved.
//

import UIKit
import SwiftyJSON

class Tweet: NSObject {
    var id: String?
    var text: String?
    var timestamp: NSDate?
    var retweetsCount: Int = 0
    var retweetedScreenName: String?
    
    var isRetweeted = false
    var isFavorited = false
    var favoritesCount: Int = 0
    var profileImageURL: NSURL?
    var contentImageURL: NSURL?
    var user: User?
    
    
    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as? String
        text = dictionary["text"] as? String
        retweetsCount = dictionary["retweet_count"] as? Int ?? 0
        favoritesCount = dictionary["favorite_count"] as? Int ?? 0
        user = User.init(dictionary: dictionary["user"] as! NSDictionary)
        
        isRetweeted = (dictionary["retweeted"] as? Bool!)!
        isFavorited = (dictionary["favorited"] as? Bool!)!
        
        retweetedScreenName = dictionary["in_reply_to_screen_name"] as? String
        
        let timestampString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if let timestampString = timestampString {
                timestamp = formatter.dateFromString(timestampString)
        }
        
        let imageURLString = dictionary["user"]!["profile_image_url_https"] as? String
        if let imageURLString = imageURLString {
            profileImageURL = NSURL(string: imageURLString)
        }
        
        let entitiesURLs = dictionary["entities"]!["media"] as? [NSDictionary]
        if let entitiesURLs = entitiesURLs {
            if entitiesURLs.count > 0 {
                let contentImageURLString = entitiesURLs[0]["media_url_https"] as? String
                if let contentImageURLString = contentImageURLString {
                    contentImageURL = NSURL(string: contentImageURLString)
                }
            }
        }
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet =  Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
