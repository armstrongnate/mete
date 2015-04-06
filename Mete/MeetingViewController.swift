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
        if let startedAt = meeting.startedAt {
          if timer == nil {
            durationSeconds = abs(startedAt.timeIntervalSinceNow)
            startTimer()
          }
        }
      } else {
        exit()
      }
    }
  }
  var timer: NSTimer?
  var refreshTimer: NSTimer!
  lazy var numberFormatter: NSNumberFormatter = {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    return formatter
  }()
  var host: Bool {
    if let attendee = Mete.stores.currentAttendee.get() {
      return attendee.host
    }
    return false
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    timerView.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-bg")!)

    let displayName = UIDevice.currentDevice().name + "'s meeting."
    btManager = BluetoothAttendeeManager(displayName: displayName)
    btManager.delegate = self

    // only advertise if i am the host
    if host {
      btManager.start()
    } else {
      playButtonContainer.hidden = true
      btManager.stop()
    }

    getStateFromStores()
    Mete.stores.currentMeeting.addChangeListener(self, selector: "onChange")
    Mete.stores.attendee.addChangeListener(self, selector: "onChange")

    refreshTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "refresh", userInfo: nil, repeats: true)
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    refresh()
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
      self.startTimer()
      if let meeting = self.meeting {
        meeting.startedAt = NSDate()
        Mete.api.saveMeeting(meeting)
      }
    }
  }

  func startTimer() {
    timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tick", userInfo: nil, repeats: true)
  }

  @IBAction func exit() {
    btManager.stop()
    timer?.invalidate()
    refreshTimer.invalidate()
    NSNotificationCenter.defaultCenter().removeObserver(self)

    // delete attendee (clears currentAttendee on success)
    if let attendee = Mete.stores.currentAttendee.get() {
      Mete.api.deleteAttendee(attendee)
    }

    // delete meeting (clears currentMeeting on success)
    if let meeting = Mete.stores.currentMeeting.get() {
      if host {
        Mete.api.deleteMeeting(meeting)
      }
    }

    // exit to welcome view controller
    let window = UIApplication.sharedApplication().delegate!.window!!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let welcomeVC = storyboard.instantiateViewControllerWithIdentifier("welcomeVC") as ViewController
    window.rootViewController = welcomeVC
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

  func refresh() {
    if let email = meeting?.email {
      Mete.api.getMeeting(email) { (record, error) in
        if error != nil {
          self.exit()
        }
      }
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
