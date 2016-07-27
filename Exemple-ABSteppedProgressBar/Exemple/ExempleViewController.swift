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
    
  }
}
