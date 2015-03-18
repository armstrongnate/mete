//
//  AttendeeStore.swift
//  Mete
//
//  Created by Nate Armstrong on 3/17/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class AttendeeStore: EventEmitter {

  var attendees: [String: Attendee] = [:]

  func emitChange() {
    emit(.Change)
  }

  func addChangeListener(listener: AnyObject, selector: Selector) {
    on(.Change, send: selector, to: listener)
  }

  func create(attendees: [Attendee]) {
    for attendee in attendees {
      self.attendees[attendee.recordName!] = attendee
    }
    emitChange()
  }

  func getAllAlpha() -> [Attendee] {
    return sorted(attendees.values) { $0.name < $1.name }
  }

  func update(attendee: Attendee) {
    if attendees[attendee.recordName!] != nil {
      attendees[attendee.recordName!] = attendee
    }
    emitChange()
  }

  func add(attendee: Attendee) {
    attendees[attendee.recordName!] = attendee
    emitChange()
  }
   
}
