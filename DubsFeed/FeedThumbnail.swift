//
//  FeedThumbnail.swift
//  Feedsmash
//
//  Created by ChangJoo Park on 2016. 4. 7..
//  Copyright © 2016년 ChangJoo Park. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ThumbnailType {
  case Default
  case Medium
  case High
}

class FeedThumbnail: NSObject {
  var type: ThumbnailType?
  var url: NSURL?
  var width: Int?
  var height: Int?

  required init(type: String, data: JSON) {
    super.init()
    switch type {
    case "default":
      self.type = ThumbnailType.Default
    case "medium":
      self.type = ThumbnailType.Medium
    case "high":
      self.type = ThumbnailType.High
    default:
      self.type = ThumbnailType.Default
    }
    let urlString = data["url"].rawString()
    self.url = NSURL(string: urlString!)
    self.width = data["width"].int
    self.height = data["height"].int
  }

  func toString() -> String {
    return "\(self.type), width=[\(width)], height=[\(height)]"
  }
}
