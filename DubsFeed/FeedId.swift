//
//  FeedId.swift
//  Feedsmash
//
//  Created by ChangJoo Park on 2016. 4. 7..
//  Copyright © 2016년 ChangJoo Park. All rights reserved.
//

import Foundation
import SwiftyJSON

class FeedId: NSObject {
  var kind: String?
  var videoId: String?
  
  required init(data: JSON) {
    super.init()
    self.kind = data["kind"].rawString()
    self.videoId = data["videoId"].rawString()
  }
  
  func toString() -> String {
    return "[kind=[\(kind)],\n videoId=[\(videoId)] ]"
  }
}
