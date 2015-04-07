//
//  WorthKeyboardView.swift
//  Mete
//
//  Created by Nate Armstrong on 3/31/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit

protocol WorthKeyboardViewDelegate: class {
  func worthKeyboardDone()
  func worthKeyboardButtonPressed(button: UIButton)
}

class WorthKeyboardView: UIView {

  @IBOutlet weak var view: UIView!
  @IBOutlet var buttons: [UIButton]!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  var bottomBorders: [CALayer] = []
  var delegate: WorthKeyboardViewDelegate?

  required init(coder aCoder: NSCoder) {
    super.init(coder: aCoder)
    setup()
  }

  override init(frame aRect: CGRect) {
    super.init(frame: aRect)
    setup()
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    for button in buttons {
      button.backgroundColor = UIColor.whiteColor()
      button.clipsToBounds = true
      button.layer.cornerRadius = 5.0
      button.layer.borderColor = UIColor.primaryColor().CGColor
      button.layer.borderWidth = 1.0
      button.setTitleColor(UIColor.primaryColor(), forState: .Normal)
      button.titleLabel!.font = UIFont.systemFontOfSize(20)
    }

    deleteButton.backgroundColor = UIColor.whiteColor()
    deleteButton.clipsToBounds = true
    deleteButton.layer.cornerRadius = 5.0
    deleteButton.layer.borderColor = UIColor.primaryColor().CGColor
    deleteButton.layer.borderWidth = 1.0
    deleteButton.imageView?.contentMode = .ScaleAspectFit

    doneButton.backgroundColor = UIColor.secondaryColor()
    doneButton.clipsToBounds = true
    doneButton.layer.cornerRadius = 5.0
    doneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    doneButton.titleLabel!.font = UIFont.boldSystemFontOfSize(20)
    doneButton.addTarget(delegate, action: "worthKeyboardDone", forControlEvents: .TouchUpInside)
  }

  private func setup() {
    NSBundle.mainBundle().loadNibNamed("WorthKeyboardView", owner: self, options: nil)
    addSubview(self.view)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    view.frame = bounds
    let ratio = doneButton.frame.size.height * 0.3
    deleteButton.imageEdgeInsets = UIEdgeInsetsMake(ratio, ratio, ratio, ratio)
  }

  @IBAction func buttonPressed(sender: UIButton) {
    delegate?.worthKeyboardButtonPressed(sender)
  }

}
