//
//  BluetoothAttendeeManager.swift
//  Mete
//
//  Created by Nate Armstrong on 3/15/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit
import MultipeerConnectivity

@objc protocol BluetoothAttendeeManagerDelegate {
  optional func browserViewControllerWasCancelled()
  optional func bluetoothConnected()
  optional func receivedMeetingEmail(email: String)
}

class BluetoothAttendeeManager: NSObject {

  // public
  var delegate: BluetoothAttendeeManagerDelegate?
  var displayName: String
  lazy var browser: MCBrowserViewController = {
    let browser = MCBrowserViewController(serviceType: self.serviceType,
      session: self.session)
    browser.delegate = self
    browser.navigationItem.rightBarButtonItem = nil
    browser.title = "Nearby Meetings"
    return browser
  }()

  // private
  private var serviceType = "METE-MEETING"
  lazy private var peerID: MCPeerID = {
    return MCPeerID(displayName: self.displayName)
  }()
  lazy private var session: MCSession = {
    let session = MCSession(peer: self.peerID)
    session.delegate = self
    return session
  }()
  lazy private var assistant: MCAdvertiserAssistant = {
    return MCAdvertiserAssistant(serviceType: self.serviceType,
      discoveryInfo: nil, session: self.session)
  }()

  init(displayName: String) {
    self.displayName = displayName
    super.init()
  }

  func start() {
    assistant.start()
  }

  func stop() {
    assistant.stop()
  }

  func disconnect() {
    session.disconnect()
  }

  func sendMeetingEmail(email: String) -> NSError? {
    var error: NSError?
    let data = email.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    session.sendData(data, toPeers: session.connectedPeers, withMode: .Unreliable, error: &error)
    return error
  }

}

extension BluetoothAttendeeManager: MCSessionDelegate {
  func session(session: MCSession!, didReceiveData data: NSData!,
    fromPeer peerID: MCPeerID!)  {
      dispatch_async(dispatch_get_main_queue()) {
        let email = NSString(data: data, encoding: NSUTF8StringEncoding)
        self.delegate?.receivedMeetingEmail?(email!)
      }
  }

  // The following methods do nothing, but the MCSessionDelegate protocol
  // requires that we implement them.
  func session(session: MCSession!,
    didStartReceivingResourceWithName resourceName: String!,
    fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!)  {

      // Called when a peer starts sending a file to us
  }

  func session(session: MCSession!,
    didFinishReceivingResourceWithName resourceName: String!,
    fromPeer peerID: MCPeerID!,
    atURL localURL: NSURL!, withError error: NSError!)  {
      // Called when a file has finished transferring from another peer
  }

  func session(session: MCSession!, didReceiveStream stream: NSInputStream!,
    withName streamName: String!, fromPeer peerID: MCPeerID!)  {
      // Called when a peer establishes a stream with us
  }

  func session(session: MCSession!, peer peerID: MCPeerID!,
    didChangeState state: MCSessionState)  {
      if state == .Connected {
        delegate?.bluetoothConnected?()
      }

  }

}

extension BluetoothAttendeeManager: MCBrowserViewControllerDelegate {

  func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
    // skip because we hide the Done button
  }

  func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
    delegate?.browserViewControllerWasCancelled?()
  }

}
