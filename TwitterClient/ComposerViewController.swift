//
//  ComposerViewController.swift
//  TwitterClient
//
//  Created by Hoang Trung Hieu on 3/28/16.
//  Copyright © 2016 Hoang Trung Hieu. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol ComposerViewControllerDelegate {
    optional func updateViewController(updateViewController: ComposerViewController, didUpdateTweet newTweet: Tweet)
}

class ComposerViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var limitationLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    var limit = 140
    weak var delegate: ComposerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up tweet text view
        tweetText.delegate = self
        tweetText.textColor = UIColor.grayColor()
        tweetText.becomeFirstResponder()
        
        // set up profile image view
        profileImageView.layer.cornerRadius = 4
        profileImageView.setImageWithURL((User.currentUser?.profileURL)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func handleCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func handleTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.postTweet(tweetText.text, completion: { (tweet, error) -> () in
            let newTweet = tweet
            
            if let newTweet = newTweet {
                self.delegate?.updateViewController?(self, didUpdateTweet: newTweet)
//                self.delegate?.updateViewController?(self, didUpdateTweet: newTweet)
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    
 
    // MARK: Text view
    
    func textViewDidBeginEditing(textView: UITextView) {
            if tweetText.text == "What's happening?" {
                moveCursorToStart(tweetText)
                limit = 140
            }
    }
    
    func textViewDidChange(textView: UITextView) {
        
        if tweetText.text.isEmpty {
            tweetText.text = "What's happening?"
            tweetText.textColor = UIColor.grayColor()
            tweetButton.alpha = 0.7
            tweetButton.enabled = false
            moveCursorToStart(tweetText)
            limit = 140
            limitationLabel.text = "\(limit)"
            
        } else {
            let firstCharacter = Array(tweetText.text.characters)[0]
            if tweetText.text == "\(firstCharacter)What's happening?" {
                tweetText.text = "\(firstCharacter)"
            }
            
            if tweetText.text.utf8.count > 140 {
                tweetText.text = tweetText.text[0..<140]
            }
            
            
            tweetText.textColor = UIColor.blackColor()
            tweetButton.alpha = 1
            tweetButton.enabled = true
            limit = 140 - tweetText.text.utf8.count
            limitationLabel.text = "\(limit)"
        }
    }
    
    func moveCursorToStart(aTextView: UITextView) {
        
        dispatch_async(dispatch_get_main_queue(), {
            aTextView.selectedRange = NSMakeRange(0, 0);
        })
    }

}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}
