//
//  ProfileViewController.swift
//  Mete
//
//  Created by Nate Armstrong on 3/11/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

  var meeting: Meeting!
  @IBOutlet weak var nameTextField: UITextField!
  lazy var loaderView: LoaderView = {
    let window = UIApplication.sharedApplication().keyWindow!
    let view = LoaderView(frame: window.frame)
    window.addSubview(view)
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-bg")!)
    nameTextField.tintColor = UIColor.whiteColor()
  }

  @IBAction func save() {
    self.showLoader(true)
    let name = nameTextField.text
    let worth = 22 // TODO: get real worth
    if let attendee = Mete.stores.currentAttendee.get() {
      attendee.name = name
      attendee.worth = worth
      self.updateAttendee(attendee)
    } else {
      let attendee = Attendee(name: name, worth: worth)
      self.createAttendee(attendee)
    }
  }

  private func createAttendee(attendee: Attendee) {
    Mete.api.createAttendee(attendee, forMeeting: Mete.stores.currentMeeting.get()!) { (record, error) in
      self.showLoader(false)
      if error == nil {
        self.nameTextField.resignFirstResponder()
        self.goToMeeting()
      } else {
        self.handleError(error)
      }
    }
  }

  private func updateAttendee(attendee: Attendee) {
    Mete.api.saveAttendee(attendee) { (record, error) in
      self.showLoader(false)
      if error == nil {
        self.performSegueWithIdentifier("unwindFromEditProfile", sender: self)
      } else {
        self.handleError(error)
      }
    }
  }

  func handleError(error: NSError) {
    println("Error! \(error)") // TODO: handle error
  }

  func showLoader(show: Bool) {
    loaderView.hidden = !show
    navigationController?.navigationBarHidden = show
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let window = UIApplication.sharedApplication().keyWindow!
    loaderView.frame = window.frame
  }

}

extension ProfileViewController: UITextFieldDelegate {

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

}
