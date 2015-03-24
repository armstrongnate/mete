//
//  ViewController.swift
//  Mete
//
//  Created by Nate Armstrong on 3/10/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var hostButton: UIButton!
  @IBOutlet weak var joinButton: UIButton!
  @IBOutlet weak var welcomeImageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
    let btnColor = UIColor(red: 182/255.0, green: 73/255.0, blue: 38/255.0, alpha: 1.0)
    hostButton.clipsToBounds = true
    hostButton.layer.cornerRadius = 5.0
    hostButton.backgroundColor = btnColor

    joinButton.clipsToBounds = true
    joinButton.layer.borderWidth = 3.0
    joinButton.layer.cornerRadius = 5.0
    joinButton.backgroundColor = UIColor.clearColor()
    joinButton.layer.borderColor = btnColor.CGColor
    joinButton.setTitleColor(btnColor, forState: .Normal)

    navigationController?.navigationBarHidden = true
  }

  @IBAction func unwindFromLeaveWelcome(segue: UIStoryboardSegue) {
    // noop
  }

  @IBAction func unwindFromEditMeeting(segue: UIStoryboardSegue) {
    // noop
  }

}

