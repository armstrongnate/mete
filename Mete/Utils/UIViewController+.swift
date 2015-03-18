//
//  UIViewController+.swift
//  Mete
//
//  Created by Nate Armstrong on 3/17/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import Foundation

extension UIViewController {

  func animateAlphaToValue(val: Double) {
    let alphaAnimation = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
    alphaAnimation.springSpeed = 5.0
    alphaAnimation.springBounciness = 5.0
    alphaAnimation.toValue = val
    navigationController?.navigationBar.pop_addAnimation(alphaAnimation, forKey: "navigationBarAnimateAlpha")
    view.pop_addAnimation(alphaAnimation, forKey: "animateAlpha")
  }

  func goToMeeting() {
    let window = UIApplication.sharedApplication().delegate!.window!!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let meetingVC = storyboard.instantiateViewControllerWithIdentifier("meetingVC") as MeetingViewController
    let navController = UINavigationController(rootViewController: meetingVC)
    UIView.transitionWithView(window, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
      window.rootViewController = navController
    }, completion: nil)
  }

}