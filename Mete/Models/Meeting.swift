//
//  Meeting.swift
//  Mete
//
//  Created by Nate Armstrong on 3/16/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit
import CloudKit

class Meeting: NSObject {

  var name: String
  var email: String
  var startedAt: NSDate?
  var attendees: [Attendee] = []


  init(name: String, email: String) {
    self.name = name
    self.email = email
    super.init()
  }

  init(record: CKRecord) {
    self.name = record.objectForKey("name") as String
    self.email = record.objectForKey("email") as String
    super.init()
  }

  func toCKRecord(record: CKRecord) -> CKRecord {
    record.setObject(name, forKey: "name")
    record.setObject(email, forKey: "email")
    record.setObject(startedAt, forKey: "startedAt")
    return record
  }

}
