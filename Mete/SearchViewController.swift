//
//  SearchViewController.swift
//  Mete
//
//  Created by Nate Armstrong on 3/13/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

  @IBOutlet weak var searchTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-bg")!)
    searchTextField.tintColor = UIColor.whiteColor()
  }

}
