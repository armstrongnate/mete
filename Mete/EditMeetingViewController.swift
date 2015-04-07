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
  @IBOutlet weak var submitButton: UIButton!

  var formData: Meeting {
    let name = nameTextField.text
    let email = codeTextField.text
    return Meeting(name: name, email: email)
  }

  var meeting: Meeting?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.whiteColor()
    codeTextField.tintColor = UIColor.primaryColor()
    nameTextField.tintColor = UIColor.primaryColor()
    navigationController?.navigationBarHidden
    submitButton.setBackgroundImage(UIImage.imageWithColor(UIColor.secondaryColor()), forState: .Normal)
    submitButton.setBackgroundImage(UIImage.imageWithColor(UIColor.lightGrayColor()), forState: .Disabled)
    if let meeting = meeting {
      nameTextField.text = meeting.name
      codeTextField.text = meeting.email
    }
    updateSubmitButton()
    nameTextField.addTarget(self, action: "updateSubmitButton", forControlEvents: .EditingChanged)
    codeTextField.addTarget(self, action: "updateSubmitButton", forControlEvents: .EditingChanged)
  }

  override func viewDidAppear(animated: Bool) {
    nameTextField.becomeFirstResponder()
  }

  @IBAction func save(sender: AnyObject) {
    let meeting = formData
    Mete.stores.currentMeeting.set(meeting)
    if Mete.stores.currentAttendee.get() == nil {
      self.performSegueWithIdentifier("editProfile", sender: self)
    } else {
      self.performSegueWithIdentifier("unwindFromEditMeeting", sender: self)
    }
    Mete.api.saveMeeting(meeting)
  }

  @IBAction func unwindFromLeaveWelcome(segue: UIStoryboardSegue) {
    dismissViewControllerAnimated(false, completion: nil)
  }


  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "editProfile" {
      let profile = segue.destinationViewController.topViewController as ProfileViewController
      profile.host = true
      profile.meeting = formData
    }
  }

  func updateSubmitButton() {
    submitButton.enabled = !nameTextField.text.isEmpty && !codeTextField.text.isEmpty
  }

}

extension EditMeetingViewController: UITextFieldDelegate {

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == nameTextField {
      codeTextField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    return true
  }

}
