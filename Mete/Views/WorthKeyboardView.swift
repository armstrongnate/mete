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
      button.backgroundColor = UIColor(red: 227/255.0, green: 152/255.0, blue: 123/255.0, alpha: 0.42)
      button.clipsToBounds = true
      button.layer.cornerRadius = 5.0
      button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
      button.titleLabel!.font = UIFont.systemFontOfSize(20)
    }

    deleteButton.backgroundColor = UIColor(red: 227/255.0, green: 152/255.0, blue: 123/255.0, alpha: 0.42)
    deleteButton.clipsToBounds = true
    deleteButton.layer.cornerRadius = 5.0
    deleteButton.imageView?.contentMode = .ScaleAspectFit

    doneButton.backgroundColor = UIColor(red: 227/255.0, green: 152/255.0, blue: 123/255.0, alpha: 0.2)
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
  }

  @IBAction func buttonPressed(sender: UIButton) {
    delegate?.worthKeyboardButtonPressed(sender)
  }

}
