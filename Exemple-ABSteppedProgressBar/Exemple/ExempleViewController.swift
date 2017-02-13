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
		
		self._configureProgressBar()
		
//		DispatchQueue.main.async { // Dispatch in order to render the subtitle in the next runloop
//			self._addSubtitles()
//		}
		
	}
	
	private func _configureProgressBar() {
		self.progressBar.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(self.progressBar)
  
		// iOS9+ auto layout code
		let horizontalConstraint = self.progressBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
		let verticalConstraint = self.progressBar.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
		let widthConstraint = self.progressBar.widthAnchor.constraint(equalToConstant: 170)
		let heightConstraint = self.progressBar.heightAnchor.constraint(equalToConstant: 40)
		NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
  
		// Customise the progress bar here
		self.progressBar.numberOfPoints = 3
		self.progressBar.lineHeight = 10
		self.progressBar.progressLineHeight = 10
		self.progressBar.radius = 15
		self.progressBar.progressRadius = 15
  
		self.progressBar.currentIndex = 1
		self.progressBar.delegate = self
  
		self.progressBar.stepTextColor = UIColor.blue
		self.progressBar.stepActiveTextColor = UIColor.gray
		self.progressBar.stepTextFont = UIFont.systemFont(ofSize: 20)
  
		self.progressBar.backgroundShapeColor = UIColor.gray
		self.progressBar.selectedBackgoundColor = UIColor.blue
	}
	
//	private func _addSubtitles() {
//		let subtitleVerticalPosition: CGFloat = self.progressBar.frame.origin.y + self.progressBar.bounds.height + 5
//		for (idx, point) in self.progressBar.centerPoints.enumerated() {
//			let realPoint = self.progressBar.convert(point, to: self.view)
//			let subtitle = UILabel(frame: CGRect(x: 0, y: subtitleVerticalPosition, width: 40, height: 20))
//			subtitle.textAlignment = .center
//			subtitle.center.x = realPoint.x
//			subtitle.text = self.progressBar(self.progressBar, textAtIndex: idx)
//			self.view.addSubview(subtitle)
//		}
//	}
	
}


extension ExempleViewController: ABSteppedProgressBarDelegate {
	
	func progressBar(_ progressBar: ABSteppedProgressBar,
	                 willSelectItemAtIndex index: Int) {
		print("progressBar:willSelectItemAtIndex:\(index)")
	}
	
	func progressBar(_ progressBar: ABSteppedProgressBar,
	                 didSelectItemAtIndex index: Int) {
		print("progressBar:didSelectItemAtIndex:\(index)")
	}
	
	func progressBar(_ progressBar: ABSteppedProgressBar,
	                 canSelectItemAtIndex index: Int) -> Bool {
		print("progressBar:canSelectItemAtIndex:\(index)")
		//Only next (or previous) step can be selected
		let offset = abs(progressBar.currentIndex - index)
		return (offset <= 1)
	}
	
	func progressBar(_ progressBar: ABSteppedProgressBar,
	                 imageAtIndex index: Int) -> UIImage {
		switch index {
		case 0:
			return #imageLiteral(resourceName: "register")
		case 1:
			return #imageLiteral(resourceName: "additional")
		case 2:
			return #imageLiteral(resourceName: "truck")
		default:
			return UIImage()
		}
	}
	
	func progressBar(_ progressBar: ABSteppedProgressBar,
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
