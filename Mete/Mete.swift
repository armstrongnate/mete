//
//  Mete.swift
//  Mete
//
//  Created by Nate Armstrong on 3/16/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit
import CloudKit

class StoreManager: NSObject {

  struct Static {
    static var defaultStoreManager = StoreManager()
  }

  class var defaultStoreManager: StoreManager {
    get { return Static.defaultStoreManager }
    set { Static.defaultStoreManager = newValue }
  }

  lazy var currentMeeting: CurrentMeetingStore = {
    return CurrentMeetingStore()
  }()

  lazy var currentAttendee: CurrentAttendeeStore = {
    return CurrentAttendeeStore()
  }()

  lazy var attendee: AttendeeStore = {
    return AttendeeStore()
  }()

}

class Mete: NSObject {

  class var stores: StoreManager { return StoreManager.defaultStoreManager }
  class var api: Api { return Api() }
   
}
