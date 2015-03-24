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

  func receivedMeetingEmail(email: String) {
    if presentedViewController == btManager.browser {
      Mete.api.getMeeting(email) { (record, error) in
        if error == nil {

          // disconnect from bluetooth session to free up # of peers
          // and because we no longer need to communicate with the host
          self.btManager.disconnect()

          // create profile
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let profile = storyboard.instantiateViewControllerWithIdentifier("profileVC") as ProfileViewController
          let navController = UINavigationController(rootViewController: profile)
          self.btManager.browser.presentViewController(navController, animated: true, completion: nil)
        }
        else {
          println("error: \(error)")
        }
      }
    }
  }

}
