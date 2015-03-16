//
//  ProfileViewController.swift
//  Mete
//
//  Created by Nate Armstrong on 3/11/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate {
  func profileDidSave()
}

class ProfileViewController: UIViewController {

  var delegate: ProfileViewControllerDelegate?
  @IBOutlet weak var nameTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-bg")!)
    nameTextField.tintColor = UIColor.whiteColor()
  }

  @IBAction func save() {
    delegate?.profileDidSave()
  }

}

extension ProfileViewController: UITextFieldDelegate {

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

}
