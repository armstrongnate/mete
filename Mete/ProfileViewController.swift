//
//  ProfileViewController.swift
//  Mete
//
//  Created by Nate Armstrong on 3/11/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

  @IBOutlet weak var nameTextFieldContainer: UIView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var nameHintLabel: UILabel!
  @IBOutlet weak var worthLabel: UILabel!
  @IBOutlet weak var constraintToAnimate: NSLayoutConstraint!
  @IBOutlet weak var worthKeyboardView: WorthKeyboardView!
  lazy var loaderView: LoaderView = {
    let window = UIApplication.sharedApplication().keyWindow!
    let view = LoaderView(frame: window.frame)
    window.addSubview(view)
    return view
  }()

  var worth: Worth!
  var host = false

  override func viewDidLoad() {
    super.viewDidLoad()
    worth = Worth(value: 0.0)
    view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-bg")!)
    worthKeyboardView.delegate = self
    nameTextField.tintColor = UIColor.whiteColor()
    if let attendee = Mete.stores.currentAttendee.get() {
      nameTextField.text = attendee.name
      worth.value = attendee.worth
      worthLabel.text = "$\(worth)"
    }
  }
  @IBAction func editWorth(sender: UITapGestureRecognizer) {
    navigationController?.navigationBarHidden = true
    nameTextFieldContainer.hidden = true
    nameHintLabel.hidden = true
    worthKeyboardView.hidden = false
    var worthAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
    worthAnim.springSpeed = 5.0
    worthAnim.springBounciness = 10.0
    worthAnim.toValue = -75
    constraintToAnimate.pop_addAnimation(worthAnim, forKey: "worthAnim")
  }

  @IBAction func save() {
    self.showLoader(true)
    let name = nameTextField.text
    let worthValue = worth.value
    if let attendee = Mete.stores.currentAttendee.get() {
      attendee.name = name
      attendee.worth = worthValue
      self.updateAttendee(attendee)
    } else {
      let attendee = Attendee(name: name, worth: worthValue)
      self.createAttendee(attendee)
    }
  }

  private func createAttendee(attendee: Attendee) {
    let meeting = Mete.stores.currentMeeting.get()!
    attendee.host = host
    Mete.api.createAttendee(attendee, forMeeting: meeting) { (record, error) in
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

extension ProfileViewController: WorthKeyboardViewDelegate {

  func worthKeyboardDone() {
    navigationController?.navigationBarHidden = false
    worthKeyboardView.hidden = true
    nameTextFieldContainer.hidden = false
    nameHintLabel.hidden = false
    var worthAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
    worthAnim.springSpeed = 10.0
    worthAnim.springBounciness = 5.0
    worthAnim.toValue = 50
    constraintToAnimate.pop_addAnimation(worthAnim, forKey: "worthAnim")
  }

  func worthKeyboardButtonPressed(button: UIButton) {
    if let char = button.titleLabel?.text {
      if !worth.append(char) {
        // shake
        let anim = CAKeyframeAnimation(keyPath: "transform")
        anim.values = [
          NSValue(CATransform3D: CATransform3DMakeTranslation(-5.0, 0.0, 0.0)),
          NSValue(CATransform3D: CATransform3DMakeTranslation(5.0, 0.0, 0.0))
        ]
        anim.autoreverses = true
        anim.repeatCount = 2
        anim.duration = 0.07
        worthLabel.layer.addAnimation(anim, forKey: nil)
      }
    } else {
      worth.backspace()
    }
    worthLabel.text = "$\(worth)"
  }
}
