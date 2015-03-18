//
//  LoaderView.swift
//  Mete
//
//  Created by Nate Armstrong on 3/17/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class LoaderView: UIView {

  var loader: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  func setup() {
    backgroundColor = UIColor.blackColor()
    alpha = 0.75
    hidden = true
    loader.startAnimating()
    addSubview(loader)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    loader.center = center
  }

}
