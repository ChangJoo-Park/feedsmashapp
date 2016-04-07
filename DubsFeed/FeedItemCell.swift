//
//  FeedItemCell.swift
//  DubsFeed
//
//  Created by ChangJoo Park on 2016. 4. 7..
//  Copyright © 2016년 ChangJoo Park. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import YouTubePlayer

class FeedItemCell: UITableViewCell {

  @IBOutlet weak var videoTitle: UILabel!
  @IBOutlet weak var youtubeView: YouTubePlayerView!
  @IBOutlet weak var desc: UILabel!
  @IBOutlet weak var dubSmashButton: UIButton!
  @IBOutlet weak var moreButton: UIButton!
  
  var parentViewController: ViewController?
  
  var feedItem: FeedItem? {
    didSet {
      desc.text = feedItem?.snippet?.desc
      videoTitle.text = feedItem?.snippet?.title
      youtubeView.loadVideoID((feedItem!.id?.videoId)!)
    }
    
    willSet {
      log.info("Will Set")
    }
  }
  
  @IBAction func actionDubSmash(sender: UIButton) {
    let url = NSURL(string: "dubsmash://")
//    let url = NSURL(string: "https://itunes.apple.com/app/dubsmash/id918820076")
    if UIApplication.sharedApplication().canOpenURL(url!) {
      UIApplication.sharedApplication().openURL(url!)
    }
  }
  
  @IBAction func actionOpenSheets(sender: UIButton) {
    guard let unwrapedViewController = self.parentViewController else  {
      return
    }

    let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    
    let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
      print("Cancel")
    }
    actionSheetController.addAction(cancelActionButton)
    
//    let saveActionButton: UIAlertAction = UIAlertAction(title: "Save to Camera Roll", style: .Default)
//    { action -> Void in
//      print("Save to Camera Roll")
//    }
//    actionSheetController.addAction(saveActionButton)
    
    let youtubeActionButton: UIAlertAction = UIAlertAction(title: "Open in Youtube", style: .Default)
    { action -> Void in
      guard let id = self.feedItem!.id?.videoId else {
          return
      }
      let url: NSURL = NSURL(string: "https://www.youtube.com/watch?v=\(id)")!
      if UIApplication.sharedApplication().canOpenURL(url) {
      UIApplication.sharedApplication().openURL(url)
      }
 

    }
    actionSheetController.addAction(youtubeActionButton)

    unwrapedViewController.presentViewController(actionSheetController, animated: true, completion: nil)
  }
  
}
