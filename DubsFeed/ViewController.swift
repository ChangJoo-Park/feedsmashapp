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

  var isLoadingState: Bool = false
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
    updateFeedItems(FeedUpdateType.INITIALIZE)
  }

  func loadCustomRefreshContents() {
    let refreshContents =
      NSBundle.mainBundle().loadNibNamed("RefreshControl", owner: self, options: nil)

    customView = refreshContents.first as! UIView
    customView.frame = refreshControl.bounds
    customView.subviews.first!.layer.opacity = 0.0
    refreshControl.addSubview(customView)
  }

  func scrollViewDidScroll(scrollView: UIScrollView) {
    // Check Refresh View
    if customView.frame.height < 30 {
      customView.subviews[0].layer.opacity = 0.0
    } else {
      customView.subviews[0].layer.opacity = 1.0
    }

    // Video scroll way from view
    guard let unwrappedCell = playStateCell else {
      return
    }

    let isScrollAwayFromView = checkCellIsScrollAwayFromView(unwrappedCell)

    if isScrollAwayFromView {
      unwrappedCell.stopVideo()
    }

  }

  private func checkCellIsScrollAwayFromView(cell: FeedItemCell) -> Bool {
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
      updateFeedItems(FeedUpdateType.INITIALIZE)
    }

    // Load More
    let offSetY = scrollView.contentOffset.y
    let triggerY = scrollView.contentSize.height - tableView.frame.size.height
    if (offSetY >= triggerY) {
      if !isLoadingState {
        updateFeedItems(FeedUpdateType.LOADMORE)
      }
    }

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func updateFeedItems(feedUpdateType: FeedUpdateType) {
    guard let feedCtrl = feedController else {
      return
    }

    isLoadingState = true
    log.debug("Before request dubsmash")
    feedCtrl.requestDubsmashes { (error) in
      if error != nil {
        let alertMessage = UIAlertController(
          title: "Check Connection", message: "Sorry, Please check Wifi or Cellular.",
          preferredStyle: .Alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertMessage, animated: true, completion: nil)
        self.isLoadingState = false
        return
      }
      // Load Data
      guard let items = feedCtrl.feedItems else {
        log.error("item is nil")
        self.isLoadingState = false
        return
      }

      switch feedUpdateType {
      case .INITIALIZE:
        self.feedItems = items
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        break
      case .LOADMORE:
        var indexPaths: [NSIndexPath] = []
        for item in items {
          self.feedItems?.append(item)
          let count: Int = (self.feedItems?.count)!
          indexPaths.append(NSIndexPath(forItem: count - 1, inSection: 0))
        }
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        self.tableView.endUpdates()
        break
      }
      self.isLoadingState = false
    }
  }
}

extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath)
    -> CGFloat {
      return 400
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let unwrappedFeedItems = feedItems else {
      return 0
    }

    return unwrappedFeedItems.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
    -> UITableViewCell {
      let cell =
        tableView.dequeueReusableCellWithIdentifier("FeedItemCell", forIndexPath: indexPath)

      guard let feedItemCell = cell as? FeedItemCell else {
        return cell
      }

      guard let unwrappedfeedItems = feedItems else {
        return cell
      }

      feedItemCell.delegate = self
      feedItemCell.feedItem = unwrappedfeedItems[indexPath.row] as FeedItem
      return cell
  }
}

extension ViewController: FeedItemCellDelegate {
  func playerDidStart(cell: FeedItemCell) {
    playStateCell?.stopVideo()
    playStateCell = cell
  }

  func playerDidStop() {
    playStateCell = nil
  }

  func openActionSheet(actionSheet: UIAlertController) {
    self.presentViewController(actionSheet, animated: true, completion: nil)
  }
}
