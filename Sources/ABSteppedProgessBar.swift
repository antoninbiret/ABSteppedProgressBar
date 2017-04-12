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
  
  @objc optional func progressBar(_ progressBar: ABSteppedProgressBar,
                            willSelectItemAtIndex index: Int)
  
  @objc optional func progressBar(_ progressBar: ABSteppedProgressBar,
                            didSelectItemAtIndex index: Int)
  
  @objc optional func progressBar(_ progressBar: ABSteppedProgressBar,
                            canSelectItemAtIndex index: Int) -> Bool
  
  @objc optional func progressBar(_ progressBar: ABSteppedProgressBar,
                            textAtIndex index: Int) -> String
  
}

@IBDesignable open class ABSteppedProgressBar: UIView {
  
  //MARK: - Public properties
  
  /// The number of displayed points in the component
  @IBInspectable open var numberOfPoints: Int = 3 {
    didSet {
      self._setNeedsRedraw()
    }
  }
  
  /// The current selected index
  open var currentIndex: Int = 0 {
    willSet(newValue){
      if let delegate = self.delegate {
        delegate.progressBar?(self, willSelectItemAtIndex: newValue)
      }
    }
    didSet {
      self._animationRendering = true
      self.setNeedsDisplay()
    }
  }
  
  /// The line height between points
  @IBInspectable open var lineHeight: CGFloat = 0.0 {
    didSet {
      self._setNeedsRedraw()
    }
  }
  
  fileprivate var _lineHeight: CGFloat {
    get {
      if(self.lineHeight == 0.0 || self.lineHeight > self.bounds.height) {
        return self.bounds.height * 0.4
      }
      return self.lineHeight
    }
  }
  
  /// The point's radius
  @IBInspectable open var radius: CGFloat = 0.0 {
    didSet {
      self._setNeedsRedraw()
    }
  }
  
  fileprivate var _radius: CGFloat {
    get{
      if(self.radius == 0.0 || self.radius > self.bounds.height / 2.0) {
        return self.bounds.height / 2.0
      }
      return self.radius
    }
  }
  
  /// The progress points's raduis
  @IBInspectable open var progressRadius: CGFloat = 0.0 {
    didSet {
      self._maskLayer.cornerRadius = self.progressRadius
      self._setNeedsRedraw()
    }
  }
  
  fileprivate var _progressRadius: CGFloat {
    get {
      if(self.progressRadius == 0.0 || self.progressRadius > self.bounds.height / 2.0) {
        return self.bounds.height / 2.0
      }
      return self.progressRadius
    }
  }
  
  /// The progress line height between points
  @IBInspectable open var progressLineHeight: CGFloat = 0.0 {
    didSet {
      self._setNeedsRedraw()
    }
  }
  
  fileprivate var _progressLineHeight: CGFloat {
    get {
      if(self.progressLineHeight == 0.0 || self.progressLineHeight > self._lineHeight) {
        return self._lineHeight
      }
      return self.progressLineHeight
    }
  }
  
  /// The selection animation duration
  @IBInspectable open var stepAnimationDuration: CFTimeInterval = 0.4
  
  /// True if some text should be rendered in the step points. The text value is provided by the delegate
  @IBInspectable open var displayStepText: Bool = true {
    didSet {
      self._setNeedsRedraw()
    }
  }
  
  /// The text font in the step points
  open var stepTextFont: UIFont? {
    didSet {
      self._setNeedsRedraw()
    }
  }
  
  /// The text color in the step points
  open var stepTextColor: UIColor? {
    didSet {
      self._setNeedsRedraw()
    }
  }
  
  
  /// The component's background color
  @IBInspectable open var backgroundShapeColor: UIColor = UIColor(red: 166.0/255.0, green: 160.0/255.0, blue: 151.0/255.0, alpha: 0.8) {
    didSet {
      self._setNeedsRedraw()
    }
  }
  
  /// The component selected background color
  @IBInspectable open var selectedBackgoundColor: UIColor = UIColor(red: 150.0/255.0, green: 24.0/255.0, blue: 33.0/255.0, alpha: 1.0) {
    didSet {
      self._setNeedsRedraw()
    }
  }
  
  /// The component's delegate
  open weak var delegate: ABSteppedProgressBarDelegate?
  
  //MARK: - Deprecated properties
  
  @available(*, deprecated: 0.0.5, message: "Use `displayTextIndexes` instead")
  @IBInspectable open var displayNumbers: Bool = true {
    didSet {
      self.displayStepText = self.displayNumbers
    }
  }
  
  @available(*, deprecated: 0.0.5, message: "Use `stepTextFont` instead")
  open var numbersFont: UIFont? {
    didSet {
      self.stepTextFont = self.numbersFont
    }
  }
  
  @available(*, deprecated: 0.0.5, message: "Use `stepTextColor` instead")
  open var numbersColor: UIColor? {
    didSet {
      self.stepTextColor = self.numbersColor
    }
  }
  
  open var centerPoints: [CGPoint] {
    return self._centerPoints
  }
  
  //MARK: - Private properties
  
  fileprivate var _backgroundLayer = CAShapeLayer()
  
  fileprivate var _progressLayer = CAShapeLayer()
  
  fileprivate var _maskLayer = CAShapeLayer()
  
  fileprivate var _centerPoints = [CGPoint]()
  
  fileprivate var _textLayers = [Int:CATextLayer]()
  
  fileprivate var _previousIndex: Int = 0
  
  fileprivate var _animationRendering = false
  
  fileprivate var _needsRedraw = true {
    didSet {
      if self._needsRedraw {
        self.setNeedsDisplay()
      }
    }
  }
  
  //MARK: - Life cycle
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.commonInit()
    self.backgroundColor = UIColor.clear
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.commonInit()
  }
  
  convenience init() {
    self.init(frame:CGRect.zero)
  }
  
  func commonInit() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ABSteppedProgressBar.gestureAction(_:)))
    let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ABSteppedProgressBar.gestureAction(_:)))
    self.addGestureRecognizer(tapGestureRecognizer)
    self.addGestureRecognizer(swipeGestureRecognizer)
    
    self.layer.addSublayer(self._backgroundLayer)
    self.layer.addSublayer(self._progressLayer)
    self._progressLayer.mask = self._maskLayer
    
    self.contentMode = UIViewContentMode.redraw
  }
  
  override open func draw(_ rect: CGRect) {        
    super.draw(rect)
    print("draw")
    self._centerPoints.removeAll()
    
    let largerRadius = fmax(self._radius, self._progressRadius)
    
    let distanceBetweenCircles = (self.bounds.width - (CGFloat(self.numberOfPoints) * 2 * largerRadius)) / CGFloat(self.numberOfPoints - 1)
    
    var xCursor: CGFloat = largerRadius
    
    for _ in 0...(self.numberOfPoints - 1) {
      self._centerPoints.append(CGPoint(x: xCursor, y: bounds.height / 2))
      xCursor += 2 * largerRadius + distanceBetweenCircles
    }
    
    if(self._needsRedraw) {
      
      let bgPath = self._shapePath(self._centerPoints, aRadius: self._radius, aLineHeight: self._lineHeight)
      self._backgroundLayer.path = bgPath.cgPath
      self._backgroundLayer.fillColor = self.backgroundShapeColor.cgColor
      
      let progressPath = self._shapePath(self._centerPoints, aRadius: self._progressRadius, aLineHeight: self._progressLineHeight)
      self._progressLayer.path = progressPath.cgPath
      self._progressLayer.fillColor = self.selectedBackgoundColor.cgColor
      
      if(self.displayStepText) {
        self._renderTextIndexes()
      }
      
      self._needsRedraw = true
    }
    
    let progressCenterPoints = Array<CGPoint>(self._centerPoints[0..<(self.currentIndex+1)])
    
    if let currentProgressCenterPoint = progressCenterPoints.last {
      
      let maskPath = self._maskPath(currentProgressCenterPoint)
      self._maskLayer.path = maskPath.cgPath
      
      CATransaction.begin()
      let progressAnimation = CABasicAnimation(keyPath: "path")
      progressAnimation.duration = self.stepAnimationDuration * CFTimeInterval(abs(self.currentIndex - self._previousIndex))
      progressAnimation.toValue = maskPath
      progressAnimation.isRemovedOnCompletion = false
      progressAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      
      
      CATransaction.setCompletionBlock { () -> Void in
        if(self._animationRendering) {
          if let delegate = self.delegate {
            delegate.progressBar?(self, didSelectItemAtIndex: self.currentIndex)
          }
          self._animationRendering = false
        }
      }
      
      self._maskLayer.add(progressAnimation, forKey: "progressAnimation")
      CATransaction.commit()
    }
    self._previousIndex = self.currentIndex
  }
  
  /**
   Force the component to redraw
   */
  fileprivate func _setNeedsRedraw() {
    self._needsRedraw = true
  }
  
  /**
   Render the text indexes
   */
  fileprivate func _renderTextIndexes() {
    
    for i in 0...(self.numberOfPoints - 1) {
      let centerPoint = self._centerPoints[i]
      
      let textLayer = self._textLayer(atIndex: i)
      textLayer.contentsScale = UIScreen.main.scale
      
      let textLayerFont: UIFont
      if let stepTextFont = self.stepTextFont {
        textLayerFont = stepTextFont
      } else {
        textLayerFont = UIFont.boldSystemFont(ofSize: self._progressRadius)
      }
      textLayer.font = CTFontCreateWithName(textLayerFont.fontName as CFString, textLayerFont.pointSize, nil)
      textLayer.fontSize = textLayerFont.pointSize
      
      if let textStepColor = self.stepTextColor {
        textLayer.foregroundColor = textStepColor.cgColor
      }
      
      if let text = self.delegate?.progressBar?(self, textAtIndex: i) {
        textLayer.string = text
      } else {
        textLayer.string = "\(i)"
      }
      
      textLayer.sizeWidthToFit()
      
      textLayer.frame = CGRect(x: centerPoint.x - textLayer.bounds.width/2, y: centerPoint.y - textLayer.bounds.height/2, width: textLayer.bounds.width, height: textLayer.bounds.height)
    }
  }
  
  /**
   Provide a text layer for the given index. If it's not in cache, it'll be instanciated.
   
   - parameter index: The index where the layer will be used
   
   - returns: The text layer
   */
  fileprivate func _textLayer(atIndex index: Int) -> CATextLayer {
    
    var textLayer: CATextLayer
    if let _textLayer = self._textLayers[index] {
      textLayer = _textLayer
    } else {
      textLayer = CATextLayer()
      self._textLayers[index] = textLayer
    }
    self.layer.addSublayer(textLayer)
    
    return textLayer
  }
  
  /**
   Compte a progress path
   
   - parameter centerPoints: The center points corresponding to the indexes
   - parameter aRadius:      The index radius
   - parameter aLineHeight:  The line height between each index
   
   - returns: The computed path
   */
  fileprivate func _shapePath(_ centerPoints: Array<CGPoint>, aRadius: CGFloat, aLineHeight: CGFloat) -> UIBezierPath {
    
    let nbPoint = centerPoints.count
    
    let path = UIBezierPath()
    
    var distanceBetweenCircles: CGFloat = 0
    
    if let first = centerPoints.first , nbPoint > 2 {
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
        
        startAngle = .pi
        endAngle = -angle
        
      } else if(i < nbPoint - 1) {
        
        startAngle = .pi + angle
        endAngle = -angle
        
      } else if(i == (nbPoint - 1)){
        
        startAngle = .pi + angle
        endAngle = 0
        
      } else if(i == nbPoint) {
        
        startAngle = 0
        endAngle = .pi - angle
        
      } else if (i < (2 * nbPoint - 1)) {
        
        startAngle = angle
        endAngle = .pi - angle
        
      } else {
        
        startAngle = angle
        endAngle = .pi
        
      }
      
      path.addArc(withCenter: CGPoint(x: centerPoint.x, y: centerPoint.y), radius: aRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
      
      if(i < nbPoint - 1) {
        xCursor += aRadius + distanceBetweenCircles
        path.addLine(to: CGPoint(x: xCursor, y: centerPoint.y - aLineHeight / 2.0))
        xCursor += aRadius
      } else if (i < (2 * nbPoint - 1) && i >= nbPoint) {
        xCursor -= aRadius + distanceBetweenCircles
        path.addLine(to: CGPoint(x: xCursor, y: centerPoint.y + aLineHeight / 2.0))
        xCursor -= aRadius
      }
    }
    return path
  }
  
  /**
   Compute the mask path
   
   - parameter currentProgressCenterPoint: The current progress index's center point
   
   - returns: The computed mask path
   */
  fileprivate func _maskPath(_ currentProgressCenterPoint: CGPoint) -> UIBezierPath {
    
    let angle = self._progressLineHeight / 2.0 / self._progressRadius;
    let xOffset = cos(angle) * self._progressRadius
    
    let maskPath = UIBezierPath()
    
    maskPath.move(to: CGPoint(x: 0.0, y: 0.0))
    
    maskPath.addLine(to: CGPoint(x: currentProgressCenterPoint.x + xOffset, y: 0.0))
    
    maskPath.addLine(to: CGPoint(x: currentProgressCenterPoint.x + xOffset, y: currentProgressCenterPoint.y - self._progressLineHeight))
    
    maskPath.addArc(withCenter: currentProgressCenterPoint, radius: self._progressRadius, startAngle: -angle, endAngle: angle, clockwise: true)
    
    maskPath.addLine(to: CGPoint(x: currentProgressCenterPoint.x + xOffset, y: self.bounds.height))
    
    maskPath.addLine(to: CGPoint(x: 0.0, y: self.bounds.height))
    maskPath.close()
    
    return maskPath
  }
  
  /**
   Respond to the user action
   
   - parameter gestureRecognizer: The gesture recognizer responsible for the action
   */
  func gestureAction(_ gestureRecognizer: UIGestureRecognizer) {
    if(gestureRecognizer.state == UIGestureRecognizerState.ended ||
      gestureRecognizer.state == UIGestureRecognizerState.changed ) {
      
      let touchPoint = gestureRecognizer.location(in: self)
      
      var smallestDistance = CGFloat(Float.infinity)
      
      var selectedIndex = 0
      
      for (index, point) in self._centerPoints.enumerated() {
        let distance = touchPoint.distanceWith(point)
        if(distance < smallestDistance) {
          smallestDistance = distance
          selectedIndex = index
        }
      }
      
      if(self.currentIndex != selectedIndex) {
        if let canSelect = self.delegate?.progressBar?(self, canSelectItemAtIndex: selectedIndex) {
          if (canSelect) {
            self.currentIndex = selectedIndex
          }
        } else {
          self.currentIndex = selectedIndex
        }
      }
    }
  }
  
}
