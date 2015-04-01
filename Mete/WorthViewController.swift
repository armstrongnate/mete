//
//  WorthViewController.swift
//  Mete
//
//  Created by Nate Armstrong on 3/30/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class WorthViewController: UIViewController {

  @IBOutlet weak var worthLabel: UILabel!
  @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-bg")!)
  }

}
