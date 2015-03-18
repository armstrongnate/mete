//
//  EventEmitter.swift
//  Mete
//
//  Created by Nate Armstrong on 3/16/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class EventEmitter: NSObject {

  enum EmissionType {
    case Change
  }

  private class func classString() -> String {
    return NSStringFromClass(self)
  }

  private func notificationNameForType(emissionType: EmissionType) -> String {
    let base = self.dynamicType.classString()
    switch emissionType {
    case .Change:
      return "\(base)_Changed"
    }
  }

  internal func on(emissionType: EmissionType, send selector: Selector, to object: AnyObject) {
    NSNotificationCenter.defaultCenter().addObserver(object,
      selector: selector,
      name: notificationNameForType(emissionType),
      object: nil
    )
  }

  internal func emit(emissionType: EmissionType) {
    postNotification(notificationNameForType(emissionType))
  }

  private func postNotification(name: String) {
    NSNotificationCenter.defaultCenter().postNotificationName(name, object: self)
  }

}
