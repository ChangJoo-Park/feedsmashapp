//
//  ViewController.swift
//  DubsFeed
//
//  Created by ChangJoo Park on 2016. 4. 7..
//  Copyright © 2016년 ChangJoo Park. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var feedController: FeedController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    feedController = FeedController()
    guard let feedCtrl = feedController else {
      return
    }
    
    feedCtrl.requestDubsmashes { (error) in
      if error != nil  {
        return
      }
      // Load Data
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

