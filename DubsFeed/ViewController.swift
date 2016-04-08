//
//  ViewController.swift
//  Feedsmash
//
//  Created by ChangJoo Park on 2016. 4. 7..
//  Copyright © 2016년 ChangJoo Park. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var feedController: FeedController?
  var feedItems: [FeedItem]?
  var playStateCell: FeedItemCell?
  
  var refreshControl: UIRefreshControl!
  var customView: UIView!
  var labelsArray: Array<UILabel> = []
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Initialize refresh control
    refreshControl = UIRefreshControl()
    refreshControl.backgroundColor = UIColor.clearColor()
    refreshControl.tintColor = UIColor.clearColor()
    tableView.addSubview(refreshControl)
    loadCustomRefreshContents()
    
    feedController = FeedController()
    updateFeedItems()
  }
  
  func loadCustomRefreshContents() {
    let refreshContents = NSBundle.mainBundle().loadNibNamed("RefreshControl", owner: self, options: nil)
    customView = refreshContents[0] as! UIView
    customView.frame = refreshControl.bounds
    customView.subviews[0].layer.opacity = 0.0
    refreshControl.addSubview(customView)
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    if customView.frame.height < 30 {
      customView.subviews[0].layer.opacity = 0.0
    } else {
      customView.subviews[0].layer.opacity = 1.0
    }
    
    guard let unwrappedCell = playStateCell else {
      return
    }

    let isScrollAway = checkCellIsScrollAway(unwrappedCell)
    
    if isScrollAway {
      unwrappedCell.stopVideo()
    }
  }
  
  private func checkCellIsScrollAway(cell: FeedItemCell) -> Bool {
    let indexPath = tableView.indexPathForCell(cell)
    let cellRectInTable = tableView.rectForRowAtIndexPath(indexPath!)
    let cellInSuperview = tableView.convertRect(cellRectInTable, toView: tableView.superview)
    let cellPositionY = cellInSuperview.origin.y

    // swipe up (View will down, y less than 0)
    if cellPositionY < -100 {
      return true
    // swipe down (View will up, y less than 0)
    } else if cellPositionY - cellInSuperview.height > 100 {
      return true
    }
    return false
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    if refreshControl.refreshing {
      updateFeedItems()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func updateFeedItems() {
    guard let feedCtrl = feedController else {
      return
    }
    
    feedCtrl.requestDubsmashes { (error) in
      if error != nil  {
        return
      }
      // Load Data
      guard let items = feedCtrl.feedItems else {
        log.error("item is nil")
        return
      }
      self.feedItems = items
      self.tableView.reloadData()
      self.refreshControl.endRefreshing()
    }
  }
}

extension ViewController: UITableViewDelegate {
  
}

extension ViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 400
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let unwrappedFeedItems = feedItems else {
      return 0
    }
    
    return unwrappedFeedItems.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: FeedItemCell = tableView.dequeueReusableCellWithIdentifier("FeedItemCell", forIndexPath: indexPath) as! FeedItemCell
    
    guard let unwrappedfeedItems = feedItems else {
      return cell
    }
    cell.delegate = self
    cell.feedItem = unwrappedfeedItems[indexPath.row] as FeedItem
    cell.parentViewController = self
    return cell
  }
}

extension ViewController: FeedItemCellDelegate {
  func playerDidStart(cell: FeedItemCell) {
    print("playerDidStart")
    playStateCell?.stopVideo()
    playStateCell = cell
  }
  
  func playerDidStop() {
    print("playerDidStop")
    playStateCell = nil
  }
}