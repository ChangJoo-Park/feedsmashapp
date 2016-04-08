//
//  FeedItemCell.swift
//  Feedsmash
//
//  Created by ChangJoo Park on 2016. 4. 7..
//  Copyright © 2016년 ChangJoo Park. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import YouTubePlayer

class FeedItemCell: UITableViewCell, YouTubePlayerDelegate {
  
  @IBOutlet weak var videoTitle: UILabel!
  @IBOutlet weak var youtubeView: YouTubePlayerView!
  @IBOutlet weak var desc: UILabel!
  @IBOutlet weak var dubSmashButton: UIButton!
  @IBOutlet weak var moreButton: UIButton!
  
  
  var parentViewController: ViewController?
  var delegate: FeedItemCellDelegate?
  
  var feedItem: FeedItem? {
    didSet {
      desc.text = feedItem?.snippet?.desc
      videoTitle.text = feedItem?.snippet?.title
      youtubeView.playerVars = [
        "playsinline": "1",
        "controls": "0",
        "showinfo": "0"
      ]
      youtubeView.loadVideoID((feedItem!.id?.videoId)!)
    }
  }
  
  override func awakeFromNib() {
    youtubeView.delegate = self
  }
  
  func playVideo() {
    if youtubeView.ready {
      if youtubeView.playerState != YouTubePlayerState.Playing {
        youtubeView.play()
      }
    }
  }
  
  func stopVideo() {
    if youtubeView.ready {
      youtubeView.stop()
      delegate?.playerDidStop()
    }
  }
  
  @IBAction func actionOpenSheets(sender: UIButton) {
    guard let unwrapedViewController = self.parentViewController else  {
      return
    }
    
    let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    
    let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
    }
    actionSheetController.addAction(cancelActionButton)
    
    let dubsmashActionButton: UIAlertAction = UIAlertAction(title: "Dubsmash on AppStore", style: .Default)
    { action -> Void in
      let url = NSURL(string: "https://itunes.apple.com/app/dubsmash/id918820076")
      if UIApplication.sharedApplication().canOpenURL(url!) {
        UIApplication.sharedApplication().openURL(url!)
      }
    }
    actionSheetController.addAction(dubsmashActionButton)
    
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
  
  override func removeFromSuperview() {
    log.info("CALLED")
    stopVideo()
    super.removeFromSuperview()
  }
  
  // these are not called:
  func playerStateChanged(videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
    switch playerState {
    case .Playing:
      delegate?.playerDidStart(self)
      break
    case .Ended:
      delegate?.playerDidStop()
      break
    default:
      break
    }
  }
  
  func playerReady(videoPlayer: YouTubePlayerView) {
  }
  
  func playerQualityChanged(videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
  }
}


protocol FeedItemCellDelegate {
  func playerDidStart(cell: FeedItemCell)
  func playerDidStop()
}
