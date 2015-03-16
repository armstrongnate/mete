//
//  MeetingViewController.swift
//  Mete
//
//  Created by Nate Armstrong on 3/11/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class MeetingViewController: UIViewController {

  @IBOutlet weak var timerView: UIView!
  var btManager: BluetoothAttendeeManager!

  override func viewDidLoad() {
    super.viewDidLoad()
    timerView.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-bg")!)

    btManager = BluetoothAttendeeManager(displayName: "Staff Meeting")

    // TODO: only advertise if i am the host
    btManager.delegate = self
    btManager.start()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "presentSettings" {
      let settings = segue.destinationViewController.topViewController as EditMeetingViewController
      let btn = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "dismissSettings")
      settings.navigationItem.rightBarButtonItem = btn
      settings.navigationItem.leftBarButtonItem = nil
      settings.title = "Edit Meeting"
    }
  }

  func dismissSettings() {
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func exit() {
    btManager.stop()
    let window = UIApplication.sharedApplication().delegate!.window!!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let welcomeVC = storyboard.instantiateViewControllerWithIdentifier("welcomeVC") as ViewController
    let navController = UINavigationController(rootViewController: welcomeVC)
    UIView.transitionWithView(window, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
      window.rootViewController = navController
    }, completion: nil)
  }

}

extension MeetingViewController: BluetoothAttendeeManagerDelegate {

  func bluetoothConnected() {
    btManager.sendMeetingID(24)
  }

}
