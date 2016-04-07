//
//  FeedThumbnail.swift
//  Feedsmash
//
//  Created by ChangJoo Park on 2016. 4. 7..
//  Copyright © 2016년 ChangJoo Park. All rights reserved.
//

import Foundation
import SwiftyJSON

enum THUMBNAIL_TYPE {
  case Default
  case Medium
  case High
}




class FeedThumbnail: NSObject {
  var type: THUMBNAIL_TYPE?
  var url: NSURL?
  var width: Int?
  var height: Int?
  
  required init(type: String, data: JSON) {
    super.init()
    switch type {
    case "default":
      self.type = THUMBNAIL_TYPE.Default
    case "medium":
      self.type = THUMBNAIL_TYPE.Medium
    case "high":
      self.type = THUMBNAIL_TYPE.High
    default:
      self.type = THUMBNAIL_TYPE.Default
    }
    let urlString = data["url"].rawString()
    self.url = NSURL(string: urlString!)
    self.width = data["width"].int
    self.height = data["height"].int
  }
  
  func toString() -> String{
    return "\(self.type), width=[\(width)], height=[\(height)]"
  }
}
