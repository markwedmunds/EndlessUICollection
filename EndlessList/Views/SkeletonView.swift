//
//  SkeletonView.swift
//  EndlessList
//
//  Created by Mark Edmunds on 25/03/2023.
//

import UIKit

class SkeletonView: UIView {
  private let gradientLayer = CAGradientLayer()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .red
    setupGradient()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupGradient()
  }
  
  private func setupGradient() {
    gradientLayer.colors = [
      UIColor(white: 0.85, alpha: 1.0).cgColor,
      UIColor(white: 0.95, alpha: 1.0).cgColor,
      UIColor(white: 0.85, alpha: 1.0).cgColor
    ]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    gradientLayer.locations = [0, 0.5, 1]
    layer.addSublayer(gradientLayer)
    animateGradient()
  }
  
  //  public func animateGradient() {
  //    let animation = CABasicAnimation(keyPath: "locations")
  //    animation.fromValue = [-1, -0.5, 0]
  //    animation.toValue = [1, 1.5, 2]
  //    animation.duration = 1.25
  //    animation.repeatCount = .infinity
  //    gradientLayer.add(animation, forKey: "skeletonAnimation")
  //  }
  
  public func animateGradient() {
    let animation = CAKeyframeAnimation(keyPath: "locations")
    animation.values = [
      [-1.0, -0.5, 0.0],
      [1.0, 1.5, 2.0]
    ]
    animation.keyTimes = [0, 1]
    animation.timingFunctions = [
      CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    ]
    animation.duration = 1.25
    animation.repeatCount = .infinity
    
    // Set the speed and timeOffset to synchronize the animation
    let currentTime = CACurrentMediaTime()
    animation.speed = 1.0
    animation.timeOffset = currentTime.truncatingRemainder(dividingBy: animation.duration)
    
    gradientLayer.add(animation, forKey: "skeletonAnimation")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = CGRect(x: -bounds.width, y: 0, width: bounds.width * 3, height: bounds.height)
    gradientLayer.removeAllAnimations()
    animateGradient()
  }
  
  func stopAnimation() {
    gradientLayer.removeAllAnimations()
  }
}
