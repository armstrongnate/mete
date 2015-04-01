//
//  WorthTests.swift
//  Mete
//
//  Created by Nate Armstrong on 3/31/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit
import XCTest

class WorthTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testExample() {
    // This is an example of a functional test case.
    XCTAssert(true, "Pass")
  }

  func testWorth() {
    let worth = Worth(value: 0.0)
    XCTAssertEqual(worth.description, "0", "description matches")

    worth.append("1")
    XCTAssertEqual(worth.description, "1", "description matches")

    // backspace on dollars
    worth.backspace()
    XCTAssertEqual(worth.description, "0", "description matches")

    worth.append("1")
    worth.append(".")
    XCTAssertEqual(worth.description, "1.00", "description matches")

    worth.append("9")
    XCTAssertEqual(worth.description, "1.90", "description matches")

    // backspace on Tenths
    worth.backspace()
    XCTAssertEqual(worth.description, "1", "description matches")

    worth.append("2")
    XCTAssertEqual(worth.description, "12", "description matches")
    worth.append(".")
    worth.append("9")
    XCTAssertEqual(worth.description, "12.90", "description matches")
    worth.append("9")
    XCTAssertEqual(worth.description, "12.99", "description matches")

    // backspace on Hundredths
    worth.backspace()
    XCTAssertEqual(worth.description, "12.90", "description matches")
    worth.append("8")
    XCTAssertEqual(worth.description, "12.98", "description matches")
    worth.backspace()
    worth.backspace()
    XCTAssertEqual(worth.description, "12", "description matches")

    worth.append("3")
    XCTAssertEqual(worth.description, "123", "description matches")

    worth.append("4")
    XCTAssertEqual(worth.description, "1,234", "description matches")

    XCTAssert(!worth.append("5"), "maximum")

    worth.append(".")
    worth.append("9")
    worth.append("7")
    XCTAssertEqual(worth.description, "1,234.97", "description matches")

    XCTAssert(!worth.append("5"), "maximum")

    worth.backspace()
    XCTAssertEqual(worth.description, "1,234.90", "description matches")
    worth.backspace()
    XCTAssertEqual(worth.description, "1,234", "description matches")
    worth.backspace()
    XCTAssertEqual(worth.description, "123", "description matches")
    worth.backspace()
    XCTAssertEqual(worth.description, "12", "description matches")
    worth.backspace()
    XCTAssertEqual(worth.description, "1", "description matches")
    worth.backspace()
    XCTAssertEqual(worth.description, "0", "description matches")
  }

}
