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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let progressBar = ABSteppedProgressBar()
    progressBar.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(progressBar)
    
    // iOS9+ auto layout code
    let horizontalConstraint = progressBar.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
    let verticalConstraint = progressBar.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor)
    let widthConstraint = progressBar.widthAnchor.constraintEqualToAnchor(nil, constant: 170)
    let heightConstraint = progressBar.heightAnchor.constraintEqualToAnchor(nil, constant: 40)
    NSLayoutConstraint.activateConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    
    
    // Customise the progress bar here
    progressBar.numberOfPoints = 4
    progressBar.lineHeight = 15
    progressBar.radius = 20
    progressBar.progressRadius = 15
    progressBar.progressLineHeight = 10
    
    progressBar.delegate = self
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
    return true
  }
  
  func progressBar(progressBar: ABSteppedProgressBar,
                   textAtIndex index: Int) -> String {
    print("progressBar:textAtIndex:\(index)")
    return "\(index)"
  }
  
}
