//
//  FromWelcomeSegue.swift
//  Mete
//
//  Created by Nate Armstrong on 3/11/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class FromWelcomeSegue: UIStoryboardSegue {

  override func perform() {
    var firstVCView = sourceViewController.view as UIView!
    var secondVCView = destinationViewController.view as UIView!
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height

    secondVCView.frame = CGRectMake(0.0, screenHeight, screenWidth, screenHeight)

    // insert into key window
    let window = UIApplication.sharedApplication().keyWindow
    window?.backgroundColor = secondVCView.backgroundColor
    window?.insertSubview(secondVCView, aboveSubview: firstVCView)

    // Animate
//    var frameAnim = POPSpringAnimation(propertyNamed: kPOPViewFrame)
//    frameAnim.springSpeed = 5.0
//    frameAnim.springBounciness = 5.0
//    frameAnim.toValue = NSValue(CGRect: CGRectOffset(firstVCView.frame, 0.0, screenHeight))
//    firstVCView.pop_addAnimation(frameAnim, forKey: "firstVCAnim")
//
    var frameAnim2 = POPSpringAnimation(propertyNamed: kPOPViewFrame)
    frameAnim2.springSpeed = 5.0
    frameAnim2.springBounciness = 0.0
    frameAnim2.toValue = NSValue(CGRect: CGRectOffset(secondVCView.frame, 0.0, -screenHeight))
    frameAnim2.completionBlock = { (animation, completed) in
      self.sourceViewController.presentViewController(self.destinationViewController as UIViewController, animated: false, completion: nil)
    }
    secondVCView.pop_addAnimation(frameAnim2, forKey: "secondVCAnim")
  }
   
}

class ToWelcomeSegue: UIStoryboardSegue {

  override func perform() {
    var firstVCView = sourceViewController.view as UIView!
    var secondVCView = destinationViewController.view as UIView!
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height

    secondVCView.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight)

    // insert into key window
    let window = UIApplication.sharedApplication().keyWindow
    window?.insertSubview(secondVCView, belowSubview: firstVCView)

    // Animate
    var frameAnim = POPSpringAnimation(propertyNamed: kPOPViewFrame)
    frameAnim.springSpeed = 5.0
    frameAnim.springBounciness = 5.0
    frameAnim.toValue = NSValue(CGRect: CGRectOffset(firstVCView.frame, 0.0, screenHeight))
    frameAnim.completionBlock = { (animation, completed) in
      self.sourceViewController.presentViewController(self.destinationViewController as UIViewController, animated: false, completion: nil)
    }
    firstVCView.pop_addAnimation(frameAnim, forKey: "firstVCAnim")

//    var frameAnim2 = POPSpringAnimation(propertyNamed: kPOPViewFrame)
//    frameAnim2.springSpeed = 5.0
//    frameAnim2.springBounciness = 0.0
//    frameAnim2.toValue = NSValue(CGRect: CGRectOffset(secondVCView.frame, 0.0, screenHeight))
//    secondVCView.pop_addAnimation(frameAnim2, forKey: "secondVCAnim")
  }

}
