//
//  MCToast.swift
//  zhixue_teacher
//
//  Created by iflytek on 15/11/9.
//  Copyright © 2015年 zhmch0329. All rights reserved.
//

import UIKit

class MCToast {
    
    class MCToastView: UIView {
        var text: String? {
            willSet {
                let font = UIFont.boldSystemFontOfSize(14.0)
                let width = UIScreen.mainScreen().bounds.size.width * 0.8
                if let newString = newValue {
                    let attString = NSAttributedString(string: newString, attributes: [NSFontAttributeName: font])
                    var size = attString.boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).size
                    size = CGSize(width: size.width + 12, height: size.height + 12)
                    
                    label.text = newString
                    label.frame = CGRect(origin: CGPointZero, size: size)
                    frame = CGRect(origin: frame.origin, size: size)
                } else {
                    label.text = ""
                    label.frame = CGRectZero
                    frame = CGRectZero
                }
            }
        }
        
        private let label = UILabel()
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.cornerRadius = 5.0
            layer.masksToBounds = true
            layer.borderColor = UIColor(white: 0.5, alpha: 0.5).CGColor
            layer.borderWidth = 1
            backgroundColor = UIColor(white: 0.2, alpha: 0.75)
            autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleRightMargin]
            alpha = 0
            
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = NSTextAlignment.Center
            label.textColor = UIColor.whiteColor()
            label.font = UIFont.boldSystemFontOfSize(14.0)
            label.numberOfLines = 0
            addSubview(label)
        }
    }
    
    private let toastView = MCToastView(frame: CGRectZero)
    private var toastCount = 0
    
    class var sharedManager: MCToast {
        struct Static {
            static let manager: MCToast = MCToast()
        }
        return Static.manager
    }
    
    private func showAnimate() {
        UIView.animateWithDuration(0.25) { () -> Void in
            self.toastView.alpha = 1.0
        }
    }
    
    private func hideAnimate() {
        --toastCount
        if toastCount == 0 {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.toastView.alpha = 0.0
            }, completion: { (finished) -> Void in
                if (self.toastCount == 0) {
                    self.toastView.removeFromSuperview()
                }
            })
        }
    }
    
    private func show(text: String?, yOffset: CGFloat = UIScreen.mainScreen().bounds.size.height * 0.8, duration: UInt64 = 2) {
        if toastCount == 0 {
            toastView.text = text
            let windows = UIApplication.sharedApplication().windows
            for window in windows {
                let windowOnMainScreen = window.screen == UIScreen.mainScreen()
                let windowIsVisible = !window.hidden && window.alpha > 0
                let windowLevelNormal = window.windowLevel == UIWindowLevelNormal
                
                if windowOnMainScreen && windowIsVisible && windowLevelNormal {
                    toastView.center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2, yOffset)
                    window.addSubview(toastView)
                    
                    showAnimate()
                    break;
                }
            }
        } else {
            toastView.text = text
            toastView.center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2, yOffset)
        }
        
        ++toastCount
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(duration * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.hideAnimate()
        }
    }
}

extension MCToast {
    class func show(text text: String?) {
        MCToast.sharedManager.show(text)
    }
    
    class func show(text text: String?, yOffset: CGFloat) {
        MCToast.sharedManager.show(text, yOffset: yOffset)
    }
    
    class func show(text text: String?, duration: UInt64) {
        MCToast.sharedManager.show(text, duration: duration)
    }
    
    class func show(text text: String?, yOffset: CGFloat, duration: UInt64) {
        MCToast.sharedManager.show(text, yOffset: yOffset, duration: duration)
    }
}
