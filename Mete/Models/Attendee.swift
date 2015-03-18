//
//  Attendee.swift
//  Mete
//
//  Created by Nate Armstrong on 3/17/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit
import CloudKit

let kCurrentAttendeeRecordNameKey = "CurrentAttendeeRecordNameKey"

class Attendee: NSObject {

  var name: String
  var worth: Int
  var recordName: String?


  init(name: String, worth: Int) {
    self.name = name
    self.worth = worth
    super.init()
  }

  init(record: CKRecord) {
    self.name = record.objectForKey("name") as String
    self.worth = record.objectForKey("worth") as Int
    self.recordName = record.recordID.recordName
    super.init()
  }

  class func currentRecordName() -> String? {
    return NSUserDefaults.standardUserDefaults().stringForKey(kCurrentAttendeeRecordNameKey)
  }

  class func setCurrentRecordName(recordName: String) {
    NSUserDefaults.standardUserDefaults().setObject(recordName, forKey: kCurrentAttendeeRecordNameKey)
  }

  class func generateRecordName() {
    setCurrentRecordName(CKRecordID(recordName: "Attendee").recordName)
  }

  func toCKRecord(record: CKRecord) -> CKRecord {
    record.setObject(name, forKey: "name")
    record.setObject(worth, forKey: "worth")
    return record
  }
   
}
