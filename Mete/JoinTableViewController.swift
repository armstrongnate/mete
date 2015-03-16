//
//  JoinTableViewController.swift
//  Mete
//
//  Created by Nate Armstrong on 3/15/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class JoinTableViewController: UITableViewController {

  var btManager: BluetoothAttendeeManager!

  override func viewDidLoad() {
    super.viewDidLoad()
    btManager = BluetoothAttendeeManager(displayName: UIDevice.currentDevice().name)
    btManager.delegate = self
  }

  func showBrowser() {
    presentViewController(btManager.browser, animated: true, completion: nil)
  }

}

extension JoinTableViewController: UITableViewDelegate {

  override func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      if indexPath.section == 0 && indexPath.row == 0 {
        showBrowser()
      }
  }
}

extension JoinTableViewController: BluetoothAttendeeManagerDelegate {

  func browserViewControllerWasCancelled() {
    dismissViewControllerAnimated(true, completion: nil)
  }

  func receivedMeetingID(meetingID: NSNumber) {
    dismissViewControllerAnimated(false) {
      let window = UIApplication.sharedApplication().delegate!.window!!
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let meetingVC = storyboard.instantiateViewControllerWithIdentifier("meetingVC") as MeetingViewController
      let navController = UINavigationController(rootViewController: meetingVC)
      UIView.transitionWithView(window, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
        window.rootViewController = navController
      }, completion: nil)
    }
  }

}
