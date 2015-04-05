//
//  Api.swift
//  Mete
//
//  Created by Nate Armstrong on 3/17/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit
import CloudKit

class Api: NSObject {

  typealias CKRecordResponse = (record: CKRecord!, error: NSError!) -> Void

  lazy var database: CKDatabase = {
    let container = CKContainer.defaultContainer()
    return container.publicCloudDatabase
  }()


  func saveMeeting(meeting: Meeting, completion: CKRecordResponse? = nil) {
    let recordID = CKRecordID(recordName: meeting.email)
    database.fetchRecordWithID(recordID) { (record, error) in
      var newRecord = meeting.toCKRecord(record ?? CKRecord(recordType: "Meeting", recordID: recordID))
      self.database.saveRecord(newRecord) { (record, error) in
        if error == nil {
          Mete.stores.currentMeeting.set(meeting)
        }
        self.performCompletion(completion, record, error)
      }
    }
  }

  func getMeeting(email: String, completion: CKRecordResponse? = nil) {
    let meetingRecordID = CKRecordID(recordName: email)
    database.fetchRecordWithID(meetingRecordID) { (record, error) in
      if error == nil {
        let meeting = Meeting(record: record)
        Mete.stores.currentMeeting.set(meeting)
      }
      self.performCompletion(completion, record, error)
    }
  }

  func saveAttendee(attendee: Attendee, completion: CKRecordResponse? = nil) {
    let recordID = CKRecordID(recordName: attendee.recordName!)
    database.fetchRecordWithID(recordID) { (record, error) in
      var newRecord = attendee.toCKRecord(record)
      self.database.saveRecord(record) { (record, error) in
        if error == nil {
          Mete.stores.attendee.update(attendee)
        }
        self.performCompletion(completion, record, error)
      }
    }
  }

  func getAttendees(meeting: Meeting) {
    let meetingRecordID = CKRecordID(recordName: meeting.email)
    let meetingPredicate = NSPredicate(format: "meeting = %@", meetingRecordID)
    let query = CKQuery(recordType: "Attendee", predicate: meetingPredicate)
    self.database.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
      if error == nil {
        let records = results as [CKRecord]
        let attendees = records.map { Attendee(record: $0) }
        Mete.stores.attendee.create(attendees)
      }
    }
  }

  func createAttendee(attendee: Attendee, forMeeting meeting: Meeting, completion: CKRecordResponse? = nil) {
    let record = attendee.toCKRecord(CKRecord(recordType: "Attendee"))
    let meetingRecordID = CKRecordID(recordName: meeting.email)
    let meetingRecord = CKRecord(recordType: "Meeting", recordID: meetingRecordID)
    let meetingReference = CKReference(record: meetingRecord, action: .None)
    record.setObject(meetingReference, forKey: "meeting")
    database.saveRecord(record) { (record, error) in
      func success() {
        attendee.recordName = record.recordID.recordName
        Mete.stores.currentAttendee.set(attendee)
        Mete.stores.attendee.add(attendee)
      }
      if error == nil {
        success()
      }
      self.performCompletion(completion, record, error)
    }
  }

  private func performCompletion(completion: CKRecordResponse?, _ record: CKRecord?, _ error: NSError?) {
    dispatch_async(dispatch_get_main_queue()) {
      println("darn swift bug")
      completion?(record: record, error: error)
    }
  }

}
