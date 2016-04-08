//
//  FeedController.swift
//  Feedsmash
//
//  Created by ChangJoo Park on 2016. 4. 7..
//  Copyright © 2016년 ChangJoo Park. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class FeedController: NSObject {
  private let apiKey = ""
  let query: String = "dubsmash"
  let maxResults: Int = 5
  var feedItems: [FeedItem]?
  var nextToken: String?

  func parseRowToItem(item: JSON) -> FeedItem {
    return FeedItem(data: item)
  }

  func requestDubsmashes(completionHandler: (NSError?) -> Void) {
    let baseUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&"
    let searchOption = "order=date&"
    let queryString = "q=\(query)&type=video&maxResults=\(maxResults)&key=\(apiKey)"
    log.debug("Check before nextToken")
    let nextTokenString =  nextToken == nil ? "" : "&pageToken=\(nextToken as String!)"
    log.debug(nextTokenString)
    let urlString = "\(baseUrl)\(searchOption)\(queryString)\(nextTokenString)"
    log.info(urlString)
    let url = NSURL(string: urlString)

    Alamofire.request(.GET, url!).validate().responseJSON { response in
      switch response.result {
      case .Success:
        if let value = response.result.value {
          self.feedItems = []
          let items = JSON(value)["items"]
          if let token: String = JSON(value)["nextPageToken"].rawString()! as String {
            self.nextToken = token
          } else {
            self.nextToken = ""
          }
          log.debug(self.nextToken)
          for item in items.arrayValue {
            let newItem = self.parseRowToItem(item)
            self.feedItems?.append(newItem)
          }
          completionHandler(nil)
        }
        break
      case .Failure(let error):
        log.error("Not connected")
        completionHandler(error)
        break
      }
    }
  }

}
