//
//  Worth.swift
//  Mete
//
//  Created by Nate Armstrong on 3/31/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class Worth: Printable {

  enum State {
    case Dollar, Decimal, Tenth, Hundredth
  }

  var value: Double
  var state: State = .Dollar
  var maximum: Double = 9_999
  var formatter: NSNumberFormatter {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    formatter.currencySymbol = ""
    if state == .Dollar {
      formatter.maximumFractionDigits = 0
    } else {
      formatter.minimumFractionDigits = 2
    }
    return formatter
  }

  var description: String {
    return formatter.stringFromNumber(NSNumber(double: value))!
  }

  init(value: Double) {
    self.value = value
  }

  func append(string: String) -> Bool {
    var newValue = value
    var newState = state
    let n = NSString(string: string).doubleValue
    switch state {
    case .Dollar:
      if string == "." {
        state = .Decimal
        return true
      }
      newValue = (newValue * 10) + n
    case .Decimal:
      newValue += n * 0.1
      newState = .Tenth
    case .Tenth:
      newValue += n * 0.01
      newState = .Hundredth
    case .Hundredth:
      return false
    }
    if newValue <= maximum {
      value = newValue
      state = newState
      return true
    }
    return false
  }

  func backspace() {
    switch state {
    case .Decimal:
      state = .Dollar
    case .Tenth:
      state = .Decimal
      value = floor(value)
    case .Dollar:
      let s = formatter.numberFromString(description)!.description
      value = NSString(string: s.substringToIndex(advance(s.endIndex, -1))).doubleValue
    case .Hundredth:
      let s = formatter.numberFromString(description)!.description
      value = NSString(string: s.substringToIndex(advance(s.endIndex, -1))).doubleValue
      state = .Tenth
    }
  }

}
