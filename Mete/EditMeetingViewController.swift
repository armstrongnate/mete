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
  @IBOutlet weak var centerConstraint: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-bg")!)
    codeTextField.tintColor = UIColor.whiteColor()
    nameTextField.tintColor = UIColor.whiteColor()
    navigationController?.navigationBarHidden
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }

  override func viewDidAppear(animated: Bool) {
    nameTextField.becomeFirstResponder()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toProfile" {
      let profile = segue.destinationViewController.topViewController as ProfileViewController
      profile.delegate = self
    }
  }

  @IBAction func save(sender: UIBarButtonItem) {
    let alphaAnimation = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
    alphaAnimation.springSpeed = 5.0
    alphaAnimation.springBounciness = 5.0
    alphaAnimation.toValue = 0.30
    alphaAnimation.completionBlock = { (animation, complete) -> Void in
      let lightAlpha = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
      lightAlpha.springSpeed = 5.0
      lightAlpha.springBounciness = 5.0
      lightAlpha.toValue = 1.0
      self.navigationController?.navigationBar.pop_addAnimation(lightAlpha, forKey: "navigationBarAnimateAlphaLight")
      self.view.pop_addAnimation(lightAlpha, forKey: "animateAlphaLight")
      // TODO: segue to main meeting vc
    }
    navigationController?.navigationBar.pop_addAnimation(alphaAnimation, forKey: "navigationBarAnimateAlpha")
    view.pop_addAnimation(alphaAnimation, forKey: "animateAlpha")
  }

}

extension EditMeetingViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  func keyboardWillShow(notification: NSNotification) {
    let keyboardRect = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue()
    animateForKeyboardRect(keyboardRect)
  }

  func keyboardWillHide(notification: NSNotification) {
    animateForKeyboardRect(nil)
  }

  func animateForKeyboardRect(rect: CGRect?) {
    let padding: CGFloat = 25.0
    let layoutAnimation = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
    layoutAnimation.springSpeed = 20.0
    layoutAnimation.springBounciness = 5.0
    layoutAnimation.toValue = rect == nil ? 0 : (CGRectGetMaxY(containerView.frame) - (CGRectGetHeight(view.frame) - rect!.height) + padding)
    centerConstraint.pop_addAnimation(layoutAnimation, forKey: "animateForKeyboard")
  }

}

extension EditMeetingViewController: ProfileViewControllerDelegate {

  func profileDidSave() {
    let window = UIApplication.sharedApplication().delegate!.window!!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let meetingVC = storyboard.instantiateViewControllerWithIdentifier("meetingVC") as MeetingViewController
    let navController = UINavigationController(rootViewController: meetingVC)
    UIView.transitionWithView(window, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
      window.rootViewController = navController
    }, completion: nil)
  }

}
