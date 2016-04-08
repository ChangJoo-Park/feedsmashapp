//
//  FeedItem.swift
//  Feedsmash
//
//  Created by ChangJoo Park on 2016. 4. 7..
//  Copyright © 2016년 ChangJoo Park. All rights reserved.
//

import Foundation
import SwiftyJSON

class FeedItem: NSObject {
  var kind: String?
  var etag: String?
  var id: FeedId?
  var snippet: FeedSnippet?


  required init(data: JSON) {
    super.init()
    self.id = FeedId(data: data["id"])
    self.snippet = FeedSnippet(data: data["snippet"])
    self.kind = data["kind"].rawString()
    self.etag = data["etag"].rawString()
  }

  func toString() -> String {
    return "\n [ \n kind: [\(kind)],\n etag: [\(etag)],\n id: [\(id?.toString())] \n snippet: [\(snippet?.toString())]"
  }
}
