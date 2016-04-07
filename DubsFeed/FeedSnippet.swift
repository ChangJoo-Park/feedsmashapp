//
//  FeedSnippet.swift
//  DubsFeed
//
//  Created by ChangJoo Park on 2016. 4. 7..
//  Copyright © 2016년 ChangJoo Park. All rights reserved.
//

import Foundation
import SwiftyJSON

class FeedSnippet: NSObject {
  var publishedAt: String?
  var title: String?
  var desc: String? // json: "description"
  var thumbnails: [FeedThumbnail]?
  var channelTitle: String?
  var channelId: String?
  var liveBroadcastContent: String?
  
  
  required init(data: JSON) {
    super.init()
    self.publishedAt = data["publishedAt"].rawString()
    self.channelId = data["channelId"].rawString()
    self.title = data["title"].rawString()
    self.desc = data["description"].rawString()
    self.channelTitle = data["channelTitle"].rawString()
    self.liveBroadcastContent = data["liveBroadcastContent"].rawString()
    
    
    self.thumbnails = []
    
    guard let unwrappedThumbnails: JSON = data["thumbnails"] else {
      log.info("Thumbnails is nil")
      return
    }
    
    for (type, detail):(String, JSON) in unwrappedThumbnails {
      let thumbnail = FeedThumbnail(type: type, data: detail)
      self.thumbnails?.append(thumbnail)
      log.info(thumbnail.toString())
    }
  }
  
  
  func toString() -> String {
    
    return "publishedAt: [\(publishedAt)], title: [\(title)], description: [\(desc)], thumbnails: [\(thumbnails?.count)], channelId: [\(channelId)], channelTitle: [\(channelTitle)], liveBroadcastContent: [\(liveBroadcastContent)]"
  }
}
