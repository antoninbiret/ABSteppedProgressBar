//
//  ABSteppedProgressBar.swift
//  ABSteppedProgressBar
//
//  Created by Antonin Biret on 17/02/15.
//  Copyright (c) 2015 Antonin Biret. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics

@objc public protocol ABSteppedProgressBarDelegate {
  
  optional func progressBar(progressBar: ABSteppedProgressBar,
                            willSelectItemAtIndex index: Int)
  
  optional func progressBar(progressBar: ABSteppedProgressBar,
                            didSelectItemAtIndex index: Int)
  
  optional func progressBar(progressBar: ABSteppedProgressBar,
                            canSelectItemAtIndex index: Int) -> Bool
  
  optional func progressBar(progressBar: ABSteppedProgressBar,
                            textAtIndex index: Int) -> String
  
}

@IBDesignable public class ABSteppedProgressBar: UIView {
  
  @IBInspectable public var numberOfPoints: Int = 3 {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  public var currentIndex: Int = 0 {
    willSet(newValue){
      if let delegate = self.delegate {
        delegate.progressBar?(self, willSelectItemAtIndex: newValue)
      }
    }
    didSet {
      animationRendering = true
      self.setNeedsDisplay()
    }
  }
  
  private var previousIndex: Int = 0
  
  @IBInspectable public var lineHeight: CGFloat = 0.0 {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  private var _lineHeight: CGFloat {
    get {
      if(lineHeight == 0.0 || lineHeight > self.bounds.height) {
        return self.bounds.height * 0.4
      }
      return lineHeight
    }
  }
  
  @IBInspectable public var radius: CGFloat = 0.0 {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  private var _radius: CGFloat {
    get{
      if(radius == 0.0 || radius > self.bounds.height / 2.0) {
        return self.bounds.height / 2.0
      }
      return radius
    }
  }
  
  @IBInspectable public var progressRadius: CGFloat = 0.0 {
    didSet {
      maskLayer.cornerRadius = progressRadius
      self.setNeedsDisplay()
    }
  }
  
  private var _progressRadius: CGFloat {
    get {
      if(progressRadius == 0.0 || progressRadius > self.bounds.height / 2.0) {
        return self.bounds.height / 2.0
      }
      return progressRadius
    }
  }
  
  @IBInspectable public var progressLineHeight: CGFloat = 0.0 {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  private var _progressLineHeight: CGFloat {
    get {
      if(progressLineHeight == 0.0 || progressLineHeight > _lineHeight) {
        return _lineHeight
      }
      return progressLineHeight
    }
  }
  
  @IBInspectable public var stepAnimationDuration: CFTimeInterval = 0.4
  
  @IBInspectable public var displayNumbers: Bool = true {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  public var numbersFont: UIFont? {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  public var numbersColor: UIColor? {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  @IBInspectable public var backgroundShapeColor: UIColor = UIColor(red: 166.0/255.0, green: 160.0/255.0, blue: 151.0/255.0, alpha: 0.8) {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  @IBInspectable public var selectedBackgoundColor: UIColor = UIColor(red: 150.0/255.0, green: 24.0/255.0, blue: 33.0/255.0, alpha: 1.0) {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  public weak var delegate: ABSteppedProgressBarDelegate?
  
  private var backgroundLayer: CAShapeLayer = CAShapeLayer()
  private var progressLayer: CAShapeLayer = CAShapeLayer()
  private var maskLayer: CAShapeLayer = CAShapeLayer()
  private var centerPoints = Array<CGPoint>()
  
  private var animationRendering = false
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  convenience init() {
    self.init(frame:CGRectZero)
  }
  
  func commonInit() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "gestureAction:")
    let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: "gestureAction:")
    self.addGestureRecognizer(tapGestureRecognizer)
    self.addGestureRecognizer(swipeGestureRecognizer)
    
    
    self.backgroundColor = UIColor.clearColor()
    
    self.layer.addSublayer(backgroundLayer)
    self.layer.addSublayer(progressLayer)
    progressLayer.mask = maskLayer
    
    self.contentMode = UIViewContentMode.Redraw
  }
  
  
  override public func drawRect(rect: CGRect) {        
    super.drawRect(rect)
    
    let largerRadius = fmax(_radius, _progressRadius)
    
    let distanceBetweenCircles = (self.bounds.width - (CGFloat(numberOfPoints) * 2 * largerRadius)) / CGFloat(numberOfPoints - 1)
    
    var xCursor: CGFloat = largerRadius
    
    for _ in 0...(numberOfPoints - 1) {
      centerPoints.append(CGPointMake(xCursor, bounds.height / 2))
      xCursor += 2 * largerRadius + distanceBetweenCircles
    }
    
    let progressCenterPoints = Array<CGPoint>(centerPoints[0..<(currentIndex+1)])
    
    if(!animationRendering) {
      
      if let bgPath = shapePath(centerPoints, aRadius: _radius, aLineHeight: _lineHeight) {
        backgroundLayer.path = bgPath.CGPath
        backgroundLayer.fillColor = backgroundShapeColor.CGColor
      }
      
      if let progressPath = shapePath(centerPoints, aRadius: _progressRadius, aLineHeight: _progressLineHeight) {
        progressLayer.path = progressPath.CGPath
        progressLayer.fillColor = selectedBackgoundColor.CGColor
      }
      
      if(displayNumbers) {
        for i in 0...(numberOfPoints - 1) {
          let centerPoint = centerPoints[i]
          let textLayer = CATextLayer()
          
          var textLayerFont = UIFont.boldSystemFontOfSize(_progressRadius)
          textLayer.contentsScale = UIScreen.mainScreen().scale
          
          if let nFont = self.numbersFont {
            textLayerFont = nFont
          }
          textLayer.font = CTFontCreateWithName(textLayerFont.fontName as CFStringRef, textLayerFont.pointSize, nil)
          textLayer.fontSize = textLayerFont.pointSize
          
          if let nColor = self.numbersColor {
            textLayer.foregroundColor = nColor.CGColor
          }
          
          if let text = self.delegate?.progressBar?(self, textAtIndex: i) {
            textLayer.string = text
          } else {
            textLayer.string = "\(i)"
          }
          
          textLayer.sizeWidthToFit()
          
          textLayer.frame = CGRectMake(centerPoint.x - textLayer.bounds.width/2, centerPoint.y - textLayer.bounds.height/2, textLayer.bounds.width, textLayer.bounds.height)
          
          self.layer.addSublayer(textLayer)
        }
      }
    }
    
    if let currentProgressCenterPoint = progressCenterPoints.last {
      
      let maskPath = self.maskPath(currentProgressCenterPoint)
      maskLayer.path = maskPath.CGPath
      
      CATransaction.begin()
      let progressAnimation = CABasicAnimation(keyPath: "path")
      progressAnimation.duration = stepAnimationDuration * CFTimeInterval(abs(currentIndex - previousIndex))
      progressAnimation.toValue = maskPath
      progressAnimation.removedOnCompletion = false
      progressAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      
      
      CATransaction.setCompletionBlock { () -> Void in
        if(self.animationRendering) {
          if let delegate = self.delegate {
            delegate.progressBar?(self, didSelectItemAtIndex: self.currentIndex)
          }
          self.animationRendering = false
        }
      }
      
      maskLayer.addAnimation(progressAnimation, forKey: "progressAnimation")
      CATransaction.commit()
    }
    previousIndex = currentIndex
  }
  
  
  func shapePath(centerPoints: Array<CGPoint>, aRadius: CGFloat, aLineHeight: CGFloat) -> UIBezierPath? {
    
    let nbPoint = centerPoints.count
    
    let path = UIBezierPath()
    
    var distanceBetweenCircles: CGFloat = 0
    
    if let first = centerPoints.first where nbPoint > 2 {
      let second = centerPoints[1]
      distanceBetweenCircles = second.x - first.x - 2 * aRadius
    }
    
    let angle = aLineHeight / 2.0 / aRadius;
    
    var xCursor: CGFloat = 0
    
    
    for i in 0...(2 * nbPoint - 1) {
      
      var index = i
      if(index >= nbPoint) {
        index = (nbPoint - 1) - (i - nbPoint)
      }
      
      let centerPoint = centerPoints[index]
      
      var startAngle: CGFloat = 0
      var endAngle: CGFloat = 0
      
      if(i == 0) {
        
        xCursor = centerPoint.x
        
        startAngle = CGFloat(M_PI)
        endAngle = -angle
        
      } else if(i < nbPoint - 1) {
        
        startAngle = CGFloat(M_PI) + angle
        endAngle = -angle
        
      } else if(i == (nbPoint - 1)){
        
        startAngle = CGFloat(M_PI) + angle
        endAngle = 0
        
      } else if(i == nbPoint) {
        
        startAngle = 0
        endAngle = CGFloat(M_PI) - angle
        
      } else if (i < (2 * nbPoint - 1)) {
        
        startAngle = angle
        endAngle = CGFloat(M_PI) - angle
        
      } else {
        
        startAngle = angle
        endAngle = CGFloat(M_PI)
        
      }
      
      path.addArcWithCenter(CGPointMake(centerPoint.x, centerPoint.y), radius: aRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
      
      
      if(i < nbPoint - 1) {
        xCursor += aRadius + distanceBetweenCircles
        path.addLineToPoint(CGPointMake(xCursor, centerPoint.y - aLineHeight / 2.0))
        xCursor += aRadius
      } else if (i < (2 * nbPoint - 1) && i >= nbPoint) {
        xCursor -= aRadius + distanceBetweenCircles
        path.addLineToPoint(CGPointMake(xCursor, centerPoint.y + aLineHeight / 2.0))
        xCursor -= aRadius
      }
    }
    return path
  }
  
  func progressMaskPath(currentProgressCenterPoint: CGPoint) -> UIBezierPath {
    let maskPath = UIBezierPath(rect: CGRectMake(0.0, 0.0, currentProgressCenterPoint.x + _progressRadius, self.bounds.height))
    return maskPath
  }
  
  func maskPath(currentProgressCenterPoint: CGPoint) -> UIBezierPath {
    
    let angle = _progressLineHeight / 2.0 / _progressRadius;
    let xOffset = cos(angle) * _progressRadius
    
    let maskPath = UIBezierPath()
    
    maskPath.moveToPoint(CGPointMake(0.0, 0.0))
    
    maskPath.addLineToPoint(CGPointMake(currentProgressCenterPoint.x + xOffset, 0.0))
    
    maskPath.addLineToPoint(CGPointMake(currentProgressCenterPoint.x + xOffset, currentProgressCenterPoint.y - _progressLineHeight))
    
    maskPath.addArcWithCenter(currentProgressCenterPoint, radius: _progressRadius, startAngle: -angle, endAngle: angle, clockwise: true)
    
    maskPath.addLineToPoint(CGPointMake(currentProgressCenterPoint.x + xOffset, self.bounds.height))
    
    maskPath.addLineToPoint(CGPointMake(0.0, self.bounds.height))
    maskPath.closePath()
    
    return maskPath
  }
  
  
  func gestureAction(gestureRecognizer:UIGestureRecognizer) {
    if(gestureRecognizer.state == UIGestureRecognizerState.Ended ||
      gestureRecognizer.state == UIGestureRecognizerState.Changed ) {
      
      let touchPoint = gestureRecognizer.locationInView(self)
      
      var smallestDistance = CGFloat(Float.infinity)
      
      var selectedIndex = 0
      
      for (index, point) in centerPoints.enumerate() {
        let distance = touchPoint.distanceWith(point)
        if(distance < smallestDistance) {
          smallestDistance = distance
          selectedIndex = index
        }
      }
      if(currentIndex != selectedIndex) {
        if let canSelect = self.delegate?.progressBar?(self, canSelectItemAtIndex: selectedIndex) {
          if (canSelect) {
            currentIndex = selectedIndex
          }
        } else {
          currentIndex = selectedIndex
        }
      }
    }
  }
  
}
