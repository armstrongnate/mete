//
//  ProfileNavigationController.swift
//  Mete
//
//  Created by Nate Armstrong on 3/31/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class ProfileNavigationController: UINavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
    let segue = WorthUnwindSegue(identifier: identifier, source: fromViewController, destination: toViewController)
    return segue
  }

}
