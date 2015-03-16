//
//  FancyTextFieldContainerView.swift
//  Mete
//
//  Created by Nate Armstrong on 3/10/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class FancyTextFieldContainerView: UIView {

  var innerShadowView: YIInnerShadowView = {
    let view = YIInnerShadowView(frame: CGRectZero)
    view.shadowRadius = 2.0
    view.shadowColor = UIColor(white: 4/255.0, alpha: 1.0)
    view.shadowOffset = CGSizeMake(0.0, 1.0)
    view.shadowOpacity = 0.5
    return view
  }()

  var innerView: UIView!

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  func setup() {
    backgroundColor = UIColor(red: 132/255.0, green: 43/255.0, blue: 10/255.0, alpha: 1.0)
    layer.cornerRadius = 5.0
    clipsToBounds = true
    layer.masksToBounds = false

    // inner shadow
    innerView = UIView()
    innerView.layer.masksToBounds = true
    innerView.layer.cornerRadius = 5.0
    innerView.addSubview(innerShadowView)
    insertSubview(innerView, atIndex: 0)

    // outer shadow
    layer.shadowRadius = 5.0
    layer.shadowColor = UIColor(white: 1.0, alpha: 1.0).CGColor
    layer.shadowOpacity = 0.1
    layer.shadowOffset = CGSizeMake(0.0, 0.0)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    innerView.frame = bounds
    innerShadowView.frame = CGRectInset(bounds, -1.0, -1.0)
  }

}
