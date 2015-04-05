//
//  EditMeetingViewController.swift
//  Mete
//
//  Created by Nate Armstrong on 3/10/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class EditMeetingViewController: UIViewController {

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var codeTextField: UITextField!
  @IBOutlet weak var nameTextField: UITextField!

  var formData: Meeting {
    let name = nameTextField.text
    let email = codeTextField.text
    return Meeting(name: name, email: email)
  }

  var meeting: Meeting?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-bg")!)
    codeTextField.tintColor = UIColor.whiteColor()
    nameTextField.tintColor = UIColor.whiteColor()
    navigationController?.navigationBarHidden
    if let meeting = meeting {
      nameTextField.text = meeting.name
      codeTextField.text = meeting.email
    }
  }

  override func viewDidAppear(animated: Bool) {
    nameTextField.becomeFirstResponder()
  }

  @IBAction func save(sender: UIBarButtonItem) {
    let meeting = formData
    Mete.stores.currentMeeting.set(meeting)
    if Mete.stores.currentAttendee.get() == nil {
      self.performSegueWithIdentifier("editProfile", sender: self)
    } else {
      self.performSegueWithIdentifier("unwindFromEditMeeting", sender: self)
    }
    Mete.api.saveMeeting(meeting)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "editProfile" {
      let profile = segue.destinationViewController.topViewController as ProfileViewController
      profile.host = true
    }
  }

}

extension EditMeetingViewController: UITextFieldDelegate {

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

}
