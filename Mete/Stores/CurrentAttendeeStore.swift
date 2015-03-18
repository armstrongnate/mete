//
//  CurrentAttendeeStore.swift
//  Mete
//
//  Created by Nate Armstrong on 3/17/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class CurrentAttendeeStore: EventEmitter {

  var attendee: Attendee?

  func emitChange() {
    emit(.Change)
  }

  func addChangeListener(listener: AnyObject, selector: Selector) {
    on(.Change, send: selector, to: listener)
  }

  func get() -> Attendee? {
    return attendee
  }

  func set(attendee: Attendee?) {
    self.attendee = attendee
    NSUserDefaults.standardUserDefaults().setObject(attendee?.recordName,
      forKey: "CurrentAttendeeRecordName")
    emitChange()
  }

  func clear() {
    self.set(nil)
  }
   
}
