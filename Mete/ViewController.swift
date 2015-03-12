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
    hostButton.clipsToBounds = true
    hostButton.layer.cornerRadius = 5.0
    joinButton.layer.borderWidth = 1.0
    joinButton.layer.borderColor = UIColor(red: 72/255.0, green: 22/255.0, blue: 2/255.0, alpha: 1.0).CGColor

    joinButton.clipsToBounds = true
    joinButton.layer.cornerRadius = 5.0
    joinButton.layer.borderWidth = 1.0
    joinButton.layer.borderColor = UIColor(red: 151/255.0, green: 57/255.0, blue: 27/255.0, alpha: 1.0).CGColor

    let image = UIImage(named: "hmuqlDBf")
    welcomeImageView.contentMode = .ScaleAspectFill
    welcomeImageView.clipsToBounds = true
    welcomeImageView.image = image

    navigationController?.navigationBarHidden = true
  }

  @IBAction func unwindFromLeaveWelcome(segue: UIStoryboardSegue) {
    // noop
  }

}

