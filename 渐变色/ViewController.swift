//
//  ViewController.swift
//  渐变色
//
//  Created by xqzh on 16/9/8.
//  Copyright © 2016年 xqzh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var newShadow:CAGradientLayer!
  var gradientLayer1:CAGradientLayer!
  var gradientLayer2:CAGradientLayer!
  override func viewDidLoad() {
    super.viewDidLoad()
     newShadow = CAGradientLayer()
     gradientLayer1 =  CAGradientLayer()
     gradientLayer2 =  CAGradientLayer()
    // Do any additional setup after loading the view, typically from a nib.
    self.view.layer.addSublayer(shadowAsInverse())
    self.view.layer.addSublayer(circleShape())
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func shadowAsInverse() -> CAGradientLayer {

    let newShadowFrame = CGRectMake(0, 50, self.view.bounds.width, 2)
    newShadow.frame = newShadowFrame
    // 渐变的方向
    newShadow.startPoint = CGPointMake(0.0, 0.5)
    newShadow.endPoint   = CGPointMake(1.0, 0.5)
    // 添加渐变的颜色组合
    let  colors = NSMutableArray()
    var hue = 0
    for _ in 0...360 {
      if hue > 360 {
        break
      }
      let color:UIColor
      color = UIColor(hue: 1.0 * CGFloat(hue) / 360.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
      colors.addObject(color.CGColor)
      hue += 5
    }
    newShadow.colors = colors as [AnyObject]
    
    
    let colorArray = NSMutableArray(array: newShadow.colors!)
    let lastColor = colorArray.lastObject!
    colorArray.removeLastObject()
    colorArray.insertObject(lastColor, atIndex: 0)
    let shiftedColors = NSArray(array: colorArray)
    newShadow.colors = shiftedColors as [AnyObject]
    let animation = CABasicAnimation(keyPath: "a")
    animation.toValue = shiftedColors
    animation.duration = 0.02
    animation.fillMode = kCAFillModeForwards
    animation.delegate = self
    newShadow.addAnimation(animation, forKey: "gavin_animateGradient")
    
    return newShadow;
  }
  
  func circleShape() -> CALayer {
    let arcCenter = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    let radius:CGFloat = 50.0
    let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: CGFloat(M_PI), endAngle: CGFloat(-M_PI), clockwise: false)
    
    let backgroundLayer = CAShapeLayer()
    backgroundLayer.path = circlePath.CGPath;
    backgroundLayer.strokeColor = UIColor.lightGrayColor().CGColor
    backgroundLayer.fillColor = UIColor.clearColor().CGColor
    backgroundLayer.lineWidth = 5
    
    
    let gradientLayer = CALayer()
    
    gradientLayer1.frame = CGRectMake(0, CGRectGetMidY(self.view.bounds) - radius - 5, self.view.bounds.width/2, 200);
    gradientLayer1.colors = newShadow.colors//NSArray(objects: UIColor.redColor().CGColor, UIColor.blueColor().CGColor) as [AnyObject]
    //gradientLayer1.locations = [0.5,0.9,1]
    gradientLayer1.startPoint = CGPointMake(0.5, 1)
    gradientLayer1.endPoint = CGPointMake(0.5, 0)
    gradientLayer.addSublayer(gradientLayer1)
    
    
    //gradientLayer2.locations = [0.1,0.5,1]
    gradientLayer2.frame = CGRectMake(self.view.bounds.width/2, CGRectGetMidY(self.view.bounds) - radius - 5, self.view.bounds.width/2, 200);
    gradientLayer2.colors = newShadow.colors//NSArray(objects: UIColor.blueColor().CGColor, UIColor.yellowColor().CGColor) as [AnyObject]
    gradientLayer2.startPoint = CGPointMake(0.5, 0)
    gradientLayer2.endPoint = CGPointMake(0.5, 1)
    gradientLayer.addSublayer(gradientLayer2)
    
    
    
    gradientLayer.mask = backgroundLayer //用progressLayer来截取渐变层
    
    
    let colorArray = NSMutableArray(array: newShadow.colors!)
    let lastColor = colorArray.lastObject!
    colorArray.removeLastObject()
    colorArray.insertObject(lastColor, atIndex: 0)
    let shiftedColors = NSArray(array: colorArray)
    gradientLayer1.colors = shiftedColors as [AnyObject]
    gradientLayer2.colors = shiftedColors as [AnyObject]
    let animation = CABasicAnimation(keyPath: "a")
    animation.toValue = shiftedColors
    animation.duration = 0.02
    animation.fillMode = kCAFillModeForwards
    animation.delegate = self
    newShadow.addAnimation(animation, forKey: "gavin_animateGradient")
    
    
    return gradientLayer
  }

}
var i:CGFloat = 0.0
extension ViewController {
  
  override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
    
    let colorArray = NSMutableArray(array: newShadow.colors!)
    let lastColor = colorArray.lastObject!
    colorArray.removeLastObject()
    colorArray.insertObject(lastColor, atIndex: 0)
    let shiftedColors = NSArray(array: colorArray)
    newShadow.colors = shiftedColors as [AnyObject]
    gradientLayer1.colors = shiftedColors as [AnyObject]
    gradientLayer2.colors = shiftedColors as [AnyObject]

    let animation = CABasicAnimation(keyPath: "a")
    animation.toValue = shiftedColors
    animation.duration = 0.02
    animation.fillMode = kCAFillModeForwards
    animation.delegate = self
    newShadow.addAnimation(animation, forKey: "gavin_animateGradient")
    
    // 增加 进度模式
    let maskLayer = CALayer()
    maskLayer.frame = CGRectMake(0.0, 0.0, 0.0, 2.0)
    maskLayer.backgroundColor = UIColor.blackColor().CGColor
    newShadow.mask = maskLayer
    
    var maskRect = maskLayer.frame
    maskRect.size.width = CGRectGetWidth(self.view.bounds) * i
    maskLayer.frame = maskRect
    
    i += 0.01
  }
}
