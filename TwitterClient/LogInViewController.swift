//
//  SignInViewController.swift
//  TwitterClient
//
//  Created by Hoang Trung Hieu on 3/24/16.
//  Copyright © 2016 Hoang Trung Hieu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onLogin(sender: UIButton) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "wjW3frCKVffPbumWysZrp4SJi", consumerSecret: "ALhlwClcOctWAbZEiGArzXQscKyDNars0zfhfoYnh83MjGM9X0")
        twitterClient.deauthorize()
        twitterClient.fetchRequestTokenWithPath("/oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterclient://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) in
            print("Token: \(requestToken.token)" )
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(url!)
        }) { (error:NSError!) in
                print("Error: \(error.localizedDescription)")
        }
    }
}
