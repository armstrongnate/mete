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
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var spinner: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()
    searchTextField.tintColor = UIColor.primaryColor()
    searchButton.layer.cornerRadius = 5.0
    searchButton.clipsToBounds = true
  }

  @IBAction func search(sender: UIButton) {
    if !searchTextField.text.isEmpty {
      searchButton.hidden = true
      spinner.hidden = false
      Mete.api.getMeeting(searchTextField.text) { (record, error) in
        if error == nil {
          let meeting = Meeting(record: record)
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let profile = storyboard.instantiateViewControllerWithIdentifier("profileVC") as ProfileViewController
          profile.meeting = meeting
          let navController = UINavigationController(rootViewController: profile)
          self.presentViewController(navController, animated: true, completion: nil)
        } else {
          self.spinner.hidden = true
          self.searchButton.hidden = false
          let alert = UIAlertController(title: "No meeting found.", message: "A meeting with that email was not found.", preferredStyle: .Alert)
          let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
          alert.addAction(alertAction)
          self.presentViewController(alert, animated: true, completion: nil)
        }
      }
    }
  }

}

extension SearchViewController: UITextFieldDelegate {

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    search(searchButton)
    return true
  }
}
