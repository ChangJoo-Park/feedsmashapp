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
  @IBOutlet weak var desc: UILabel!
  @IBOutlet weak var moreButton: UIButton!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var mediaView: YouTubePlayerView!

  var tapThumbnailGesture: UITapGestureRecognizer?
  var delegate: FeedItemCellDelegate?

  var isPlayState: Bool = false {
    didSet {
      UIView.animateWithDuration(0.3) {
        self.thumbnailImageView.layer.opacity = self.isPlayState ? 0.0 : 1.0
        self.mediaView.layer.opacity = self.isPlayState ? 1.0 : 0.0
      }
    }
  }
  var feedItem: FeedItem? {
    didSet {
      desc.text = feedItem?.snippet?.desc
      videoTitle.text = feedItem?.snippet?.title
      Alamofire.request(Method.GET, (feedItem?.snippet?.thumbnails?.last?.url)!)
        .responseImage { (response) in
          if let image = response.result.value {
            self.thumbnailImageView.image = image
            self.thumbnailImageView.userInteractionEnabled = true
            self.tapThumbnailGesture = UITapGestureRecognizer(target: self, action: #selector(FeedItemCell.loadVideo))
            self.thumbnailImageView.addGestureRecognizer(self.tapThumbnailGesture!)
          }
      }
    }
  }

  override func awakeFromNib() {
    mediaView.delegate = self
    mediaView.layer.opacity = 0.0
    mediaView.playerVars = [
      "playsinline": "1",
      "controls": "0",
      "showinfo": "0",
      "rel": "0"
    ]
  }

  func loadVideo() {
    guard let videoId = feedItem?.id?.videoId else {
      return
    }

    mediaView.loadVideoID(videoId)
  }

  func playVideo() {
    if mediaView.ready {
      if mediaView.playerState != YouTubePlayerState.Playing {
        isPlayState = true
        mediaView.play()
      }
    }
  }

  func stopVideo() {
    if mediaView.ready {
      isPlayState = false
      mediaView.stop()
      delegate?.playerDidStop()
    }
  }

  @IBAction func actionOpenSheets(sender: UIButton) {
    let actionSheetController =
      UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)

    let cancelActionButton =
      UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
    }
    actionSheetController.addAction(cancelActionButton)

    let dubsmashActionButton =
      UIAlertAction(title: "Dubsmash on AppStore", style: .Default) { action -> Void in
        let url = NSURL(string: "https://itunes.apple.com/app/dubsmash/id918820076")
        if UIApplication.sharedApplication().canOpenURL(url!) {
          UIApplication.sharedApplication().openURL(url!)
        }
    }
    actionSheetController.addAction(dubsmashActionButton)

    let youtubeActionButton =
      UIAlertAction(title: "Open in Youtube", style: .Default) { action -> Void in
        guard let id = self.feedItem!.id?.videoId else {
          return
        }
        let url: NSURL = NSURL(string: "https://www.youtube.com/watch?v=\(id)")!
        if UIApplication.sharedApplication().canOpenURL(url) {
          UIApplication.sharedApplication().openURL(url)
        }
    }
    actionSheetController.addAction(youtubeActionButton)
    delegate?.openActionSheet(actionSheetController)
  }

  override func removeFromSuperview() {
    stopVideo()
    super.removeFromSuperview()
  }


  func playerStateChanged(videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
    switch playerState {
    case .Playing:
      delegate?.playerDidStart(self)
      break
    case .Ended:
      stopVideo()
      break
    case .Buffering:
      break
    default:
      break
    }
  }

  func playerReady(videoPlayer: YouTubePlayerView) {
    playVideo()
  }

  func playerQualityChanged(videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
  }
}


protocol FeedItemCellDelegate {
  func playerDidStart(cell: FeedItemCell)
  func playerDidStop()
  func openActionSheet(actionSheet: UIAlertController)
}
