//
//  FromWelcomeSegue.swift
//  Mete
//
//  Created by Nate Armstrong on 3/11/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class WorthSegue: UIStoryboardSegue {

  override func perform() {
    var profile = sourceViewController as ProfileViewController
    var worth = destinationViewController as WorthViewController

    UIView.animateWithDuration(1.0) {
      println("seriously?")
      profile.navigationController?.navigationBarHidden = true
    }

    profile.view.addSubview(worth.view)

    var worthAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
    worthAnim.springSpeed = 5.0
    worthAnim.springBounciness = 10.0
    worthAnim.toValue = 40 - (profile.navigationController?.navigationBar.frame.size.height ?? 0)
    worthAnim.completionBlock = { (animation, completed) in
      worth.view.removeFromSuperview()
      profile.presentViewController(worth, animated: false) {
        worth.topLayoutConstraint.constant = 40
      }
    }

    worth.topLayoutConstraint.pop_addAnimation(worthAnim, forKey: "worthAnim")
  }
   
}

class WorthUnwindSegue: UIStoryboardSegue {

  override func perform() {
    var worth = sourceViewController as WorthViewController
    var profile = destinationViewController as ProfileViewController

    profile.navigationController?.navigationBarHidden = false

    var worthAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
    worthAnim.springSpeed = 5.0
    worthAnim.springBounciness = 10.0
    worthAnim.toValue = 186
    worthAnim.completionBlock = { (animation, completed) in
      worth.dismissViewControllerAnimated(false, completion: nil)
    }

    worth.topLayoutConstraint.pop_addAnimation(worthAnim, forKey: "worthAnim")
  }

}
