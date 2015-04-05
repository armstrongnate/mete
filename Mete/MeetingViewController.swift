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
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var costLabel: UILabel!
  var totalWorth: Double = 0
  var durationSeconds: Double = 0
  var btManager: BluetoothAttendeeManager!
  var attendees: [Attendee] = [] {
    didSet {
      totalWorth = attendees.reduce(0.0, { $0 + $1.worth })
    }
  }
  var meeting: Meeting? {
    didSet {
      if let meeting = self.meeting {
        Mete.api.getAttendees(meeting)
      }
    }
  }
  var timer: NSTimer?
  lazy var numberFormatter: NSNumberFormatter = {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    return formatter
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    timerView.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-bg")!)

    let displayName = UIDevice.currentDevice().name + "'s meeting."
    btManager = BluetoothAttendeeManager(displayName: displayName)
    btManager.delegate = self

    // only advertise if i am the host
    if let attendee = Mete.stores.currentAttendee.get() {
      if attendee.host {
        btManager.start()
      } else {
        playButtonContainer.hidden = true
        btManager.stop()
      }
    }

    getStateFromStores()
    Mete.stores.currentMeeting.addChangeListener(self, selector: "onChange")
    Mete.stores.attendee.addChangeListener(self, selector: "onChange")
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
      self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tick", userInfo: nil, repeats: true)
      self.timer!.fire()
    }
  }

  @IBAction func exit() {
    btManager.stop()
    timer?.invalidate()
    Mete.stores.currentMeeting.clear()
    Mete.stores.currentAttendee.clear()

    // TODO: remove attendee from store

    // TODO: delete meeting if host(?)

    // exit to welcome view controller
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

  func getStateFromStores() {
    meeting = Mete.stores.currentMeeting.get()
    attendees = Mete.stores.attendee.getAllAlpha()
    title = meeting?.name ?? "Meeting"
  }

  func onChange() {
    getStateFromStores()
    tableView.reloadData()
  }

  func tick() {
    durationSeconds += 1
    let hours = Int(floor(durationSeconds / 3600))
    let minutes = Int(floor(durationSeconds / 60) % 60)
    let seconds = Int(durationSeconds % 60)
    let pHours = String(format: "%02d", hours)
    let pMins = String(format: "%02d", minutes)
    let pSeconds = String(format: "%02d", seconds)
    let cost = (durationSeconds / 3600) * totalWorth
    dispatch_async(dispatch_get_main_queue()) {
      self.timeLabel.text = "\(pHours):\(pMins):\(pSeconds)"
      self.costLabel.text = self.numberFormatter.stringFromNumber(NSNumber(double: cost))
    }
  }

}

extension MeetingViewController: BluetoothAttendeeManagerDelegate {

  func bluetoothConnected() {
    if let email = meeting?.email {
      btManager.sendMeetingEmail(email)
    }
  }

}

extension MeetingViewController: UITableViewDataSource {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return attendees.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("attendeeCell", forIndexPath: indexPath) as UITableViewCell
    cell.textLabel!.text = attendees[indexPath.row].name
    return cell
  }

}
