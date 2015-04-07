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
  var attendee: Attendee!
  var attendeeStore = AttendeeStore()
  var attendees: [Attendee] = [] {
    didSet {
      totalWorth = attendees.reduce(0.0, { $0 + $1.worth })
      tableView.reloadData()
    }
  }
  var meeting: Meeting! {
    didSet {
      Mete.api.getAttendees(meeting, store: attendeeStore)
      if let startedAt = meeting.startedAt {
        if timer == nil {
          durationSeconds = abs(startedAt.timeIntervalSinceNow)
          startTimer()
        }
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

  override func viewDidLoad() {
    super.viewDidLoad()
    attendeeStore.add(attendee)

    // ui
    timerView.backgroundColor = UIColor.primaryColor()

    // bluetooth
    let displayName = UIDevice.currentDevice().name + "'s meeting."
    btManager = BluetoothAttendeeManager(displayName: displayName)
    btManager.delegate = self

    // only advertise if i am the host
    if attendee.host {
      btManager.start()
    } else {
      playButtonContainer.hidden = true
      btManager.stop()
    }

    // check server for updates
    refreshTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "refresh", userInfo: nil, repeats: true)

    // get attendee store changes
    attendeeStore.addChangeListener(self, selector: "onChange")
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    refresh()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "editProfile" {
      let profile = segue.destinationViewController.topViewController as ProfileViewController
      profile.attendee = attendee
      profile.meeting = meeting
    }
  }

  @IBAction func play() {
    UIView.animateWithDuration(0.5, animations: { () -> Void in
      self.playButtonContainer.alpha = 0.0
    }) { (completed) -> Void in
      self.playButtonContainer.hidden = true
      self.startTimer()
      self.meeting.startedAt = NSDate()
      Mete.api.saveMeeting(self.meeting)
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

    // delete attendee
    Mete.api.deleteAttendee(attendee)

    // delete meeting
    if attendee.host {
      Mete.api.deleteMeeting(meeting) {
        // noop
      }
    }

    // exit to welcome view controller
    let window = UIApplication.sharedApplication().delegate!.window!!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let editVC = storyboard.instantiateViewControllerWithIdentifier("editMeetingVC") as EditMeetingViewController
    let nav = UINavigationController(rootViewController: editVC)
    window.rootViewController = nav
  }

  @IBAction func unwindFromEditProfile(segue: UIStoryboardSegue) {
    dismissViewControllerAnimated(true, completion: nil)
    if let attendee = (segue.sourceViewController as ProfileViewController).attendee {
      attendeeStore.update(attendee)
    }
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
        } else {
          self.meeting = Meeting(record: record)
        }
      }
    }
  }

  func onChange() {
    self.attendees = attendeeStore.getAllAlpha()
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
