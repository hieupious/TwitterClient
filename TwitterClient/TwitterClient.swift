//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Hoang Trung Hieu on 3/25/16.
//  Copyright © 2016 Hoang Trung Hieu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


let twitterbaseURL = "https://api.twitter.com"
let consumerKey = "wjW3frCKVffPbumWysZrp4SJi"
let consumerSecret = "ALhlwClcOctWAbZEiGArzXQscKyDNars0zfhfoYnh83MjGM9X0"

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: twitterbaseURL), consumerKey: consumerKey, consumerSecret: consumerSecret)
    
    func homeTimeline(success: ([Tweet] -> ()), failure: (NSError) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response:AnyObject?) in
            print("Timeline: \(response)")
            let tweetDics = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(tweetDics)
            success(tweets)
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) in
                failure(error)
        })

    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("/1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response:AnyObject?) in
            print("Account: \(response)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) in
                failure(error)
        })
    }
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ())  {
        loginSuccess = success
        loginFailure = failure
        deauthorize()
        fetchRequestTokenWithPath("/oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterclient://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) in
            print("Token: \(requestToken.token)" )
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(url!)
        }) { (error:NSError!) in
            print("Error: \(error.localizedDescription)")
        }

    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            self.currentAccount({ (user: User) in
                    User.currentUser = user
                    self.loginSuccess?()
                }, failure: { (error: NSError) in
                    self.loginFailure?(error)
            })
        }) { (error: NSError!) in
            self.loginFailure?(error)
        }

    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogout, object: nil)
        
    }
    
    func postTweet(text: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        var params = [String : AnyObject]()
        params["status"] = text
        
        POST("1.1/statuses/update.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let newTweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: newTweet, error: nil)
        }) { (task:NSURLSessionDataTask?, error:NSError) in
            print("error updating new tweet")
            completion(tweet: nil, error: error)
        }
        
    }
}
