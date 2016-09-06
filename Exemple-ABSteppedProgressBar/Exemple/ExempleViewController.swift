//
//  ExempleViewController.swift
//  Exemple
//
//  Created by Antonin Biret on 27/07/16.
//  Copyright © 2016 antoninbiret. All rights reserved.
//

import UIKit
import ABSteppedProgressBar

class ExempleViewController: UIViewController {
  
  let progressBar = ABSteppedProgressBar()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.progressBar.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.progressBar)
    
    // iOS9+ auto layout code
    let horizontalConstraint = self.progressBar.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
    let verticalConstraint = self.progressBar.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor)
    let widthConstraint = self.progressBar.widthAnchor.constraintEqualToAnchor(nil, constant: 170)
    let heightConstraint = self.progressBar.heightAnchor.constraintEqualToAnchor(nil, constant: 40)
    NSLayoutConstraint.activateConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    
    
    // Customise the progress bar here
    self.progressBar.numberOfPoints = 4
    self.progressBar.lineHeight = 15
    self.progressBar.radius = 20
    self.progressBar.progressRadius = 15
    self.progressBar.progressLineHeight = 10
    
    self.progressBar.currentIndex = 1
    self.progressBar.delegate = self
    
    self.progressBar.stepTextColor = UIColor.whiteColor()
    self.progressBar.stepTextFont = UIFont.systemFontOfSize(20)
    
    self.progressBar.backgroundShapeColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1)
    self.progressBar.selectedBackgoundColor = UIColor(red: 64/255, green: 173/255, blue: 21/255, alpha: 1)
    
    
  }
  
  private func _addSubtitles() {
    let subtitleVerticalPosition: CGFloat = self.progressBar.frame.origin.y + self.progressBar.bounds.height + 5
    for (idx, point) in self.progressBar.centerPoints.enumerate() {
      let realPoint = self.progressBar.convertPoint(point, toView: self.view)
      let subtitle = UILabel(frame: CGRectMake(0, subtitleVerticalPosition, 40, 20))
      subtitle.textAlignment = .Center
      subtitle.center.x = realPoint.x
      subtitle.text = self.progressBar(self.progressBar, textAtIndex: idx)
      self.view.addSubview(subtitle)
    }
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self._addSubtitles()
  }
}


extension ExempleViewController: ABSteppedProgressBarDelegate {
  
  func progressBar(progressBar: ABSteppedProgressBar,
                   willSelectItemAtIndex index: Int) {
    print("progressBar:willSelectItemAtIndex:\(index)")
  }
  
  func progressBar(progressBar: ABSteppedProgressBar,
                   didSelectItemAtIndex index: Int) {
    print("progressBar:didSelectItemAtIndex:\(index)")
  }
  
  func progressBar(progressBar: ABSteppedProgressBar,
                   canSelectItemAtIndex index: Int) -> Bool {
    print("progressBar:canSelectItemAtIndex:\(index)")
    //Only next (or previous) step can be selected
    let offset = abs(progressBar.currentIndex - index)
    return (offset <= 1)
  }
  
  func progressBar(progressBar: ABSteppedProgressBar,
                   textAtIndex index: Int) -> String {
    let text: String
    switch index {
    case 0:
      text = "A"
    case 1:
      text = "B"
    case 2:
      text = "C"
    case 3:
      text = "D"
    default:
      text = ""
    }
    print("progressBar:textAtIndex:\(index)")
    return text
  }
  
}
