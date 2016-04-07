//
//  FeedControllerTests.swift
//  DubsFeed
//
//  Created by ChangJoo Park on 2016. 4. 7..
//  Copyright © 2016년 ChangJoo Park. All rights reserved.
//

import XCTest
@testable import DubsFeed

class FeedControllerTests: XCTestCase {
  let feedController = FeedController()

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testShouldFeedControllerExists() {
    XCTAssertNotNil(feedController)
  }
}
