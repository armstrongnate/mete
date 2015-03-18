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
  @IBOutlet weak var playButtonContainer: UIView!
  var btManager: BluetoothAttendeeManager!

  override func viewDidLoad() {
    super.viewDidLoad()
    timerView.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-bg")!)

    btManager = BluetoothAttendeeManager(displayName: "Staff Meeting")

    // TODO: only advertise if i am the host
    btManager.delegate = self
    btManager.start()

    Mete.stores.currentMeeting.addChangeListener(self, selector: "onChange")
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "editMeeting" {
      let settings = segue.destinationViewController.topViewController as EditMeetingViewController
      settings.title = "Edit Meeting"
    }
  }

  @IBAction func play() {
    UIView.animateWithDuration(0.5, animations: { () -> Void in
      self.playButtonContainer.alpha = 0.0
    }) { (completed) -> Void in
      self.playButtonContainer.hidden = true
    }
  }

  @IBAction func exit() {
    btManager.stop()
    Mete.stores.currentMeeting.clear()
    let window = UIApplication.sharedApplication().delegate!.window!!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let welcomeVC = storyboard.instantiateViewControllerWithIdentifier("welcomeVC") as ViewController
    let navController = UINavigationController(rootViewController: welcomeVC)
    UIView.transitionWithView(window, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
      window.rootViewController = navController
    }, completion: nil)
  }

  @IBAction func unwindFromEditMeeting(segue: UIStoryboardSegue) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func unwindFromEditProfile(segue: UIStoryboardSegue) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  func onChange() {
    // TODO: update timer and stuff
  }

}

extension MeetingViewController: BluetoothAttendeeManagerDelegate {

  func bluetoothConnected() {
    btManager.sendMeetingID(24)
  }

}
