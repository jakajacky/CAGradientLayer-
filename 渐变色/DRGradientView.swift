//
//  DRGradientView.swift
//  渐变色
//
//  Created by xqzh on 16/9/13.
//  Copyright © 2016年 xqzh. All rights reserved.
//

import UIKit

class DRGradientView: UIView, CAAnimationDelegate {

  var newShadow:CAGradientLayer!
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    newShadow = CAGradientLayer()
    self.layer.addSublayer(shadowAsInverse())
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func shadowAsInverse() -> CAGradientLayer {
    
    let newShadowFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    newShadow.frame = newShadowFrame
    // 渐变的方向
    newShadow.startPoint = CGPoint(x: 0.0, y: 0.5)
    newShadow.endPoint   = CGPoint(x: 1.0, y: 0.5)
    // 添加渐变的颜色组合
    let  colors = NSMutableArray()
    var hue = 0
    for _ in 0...360 {
      if hue > 360 {
        break
      }
      let color:UIColor
      color = UIColor(hue: 1.0 * CGFloat(hue) / 360.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
      colors.add(color.cgColor)
      hue += 5
    }
    newShadow.colors = colors as [AnyObject]
    
    
    let colorArray = NSMutableArray(array: newShadow.colors!)
    let lastColor = colorArray.lastObject!
    colorArray.removeLastObject()
    colorArray.insert(lastColor, at: 0)
    let shiftedColors = NSArray(array: colorArray)
    newShadow.colors = shiftedColors as [AnyObject]
    let animation = CABasicAnimation(keyPath: "a")
    animation.toValue = shiftedColors
    animation.duration = 0.02
    animation.fillMode = kCAFillModeForwards
    animation.delegate = self
    newShadow.add(animation, forKey: "gavin_animateGradient")
    
    return newShadow;
  }
  
}

extension DRGradientView {
  
   func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    
    let colorArray = NSMutableArray(array: newShadow.colors!)
    let lastColor = colorArray.lastObject!
    colorArray.removeLastObject()
    colorArray.insert(lastColor, at: 0)
        
    let shiftedColors = NSArray(array: colorArray)
    newShadow.colors = shiftedColors as [AnyObject]
    
    let animation = CABasicAnimation(keyPath: "a")
    animation.toValue = shiftedColors
    animation.duration = 0.02
    animation.fillMode = kCAFillModeForwards
    animation.delegate = self
    newShadow.add(animation, forKey: "gavin_animateGradient")
    
  }
}

