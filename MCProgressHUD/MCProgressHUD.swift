//
//  MCProgressHUD.swift
//  zhixue_teacher
//
//  Created by 张敏超 on 15/11/18.
//  Copyright © 2015年 zhmch0329. All rights reserved.
//

import UIKit

enum MCProgressHUDStyle {
    case Light, Dark
}

class MCProgressHUDView: UIView {
    
    var text: String? {
        willSet {
            if newValue != text {
                needLayout = true
            }
        }
    }
    var detailText: String? {
        willSet {
            if newValue != detailText {
                needLayout = true
            }
        }
    }
    var imageNames: [String]? {
        willSet {
            if let names = imageNames {
                if let value = newValue {
                    if names == value {
                        needLayout = true
                    }
                }
            }
        }
    }
    var duration: NSTimeInterval = 1.0
    var style: MCProgressHUDStyle = .Light {
        willSet {
            if newValue != style {
                needLayout = true
            }
        }
    }
    
    private var hudView: UIView?
    private var indicatorView: UIView?
    private let textLabel = UILabel()
    private var needLayout: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showInTargetView(targetView: UIView? = nil) {        
        guard needLayout else {
            addToTargetView(targetView)
            return
        }
        
        hudView?.removeFromSuperview()
        switch style {
        case .Light:
            hudView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
            hudView!.layer.cornerRadius = 8.0
            hudView!.layer.masksToBounds = true
            hudView!.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleRightMargin]
            
            textLabel.textColor = UIColor.blackColor()
        case .Dark:
            hudView = UIView()
            hudView!.layer.cornerRadius = 8.0
            hudView!.layer.masksToBounds = true
            hudView!.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
            hudView!.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleRightMargin]
            
            textLabel.textColor = UIColor.whiteColor()
        }
        
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.numberOfLines = 2
        hudView!.addSubview(textLabel)
        
        var textSize: CGSize = CGSizeZero
        if text != nil && text?.characters.count != 0 {
            let attText = NSMutableAttributedString(string: text!, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(15.0)])
            if detailText != nil && detailText?.characters.count != 0 {
                attText.appendAttributedString(NSAttributedString(string: "\n" + detailText!, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(11.0)]))
            }
            textSize = attText.boundingRectWithSize(CGSize(width: CGFloat(MAXFLOAT), height: 40), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).size
            
            textLabel.attributedText = attText
        }
        
        // the load view
        if imageNames?.count > 0 {
            let imageView = UIImageView()
            imageView.image = UIImage(named: imageNames!.first!)
            var images = [UIImage]()
            for name in imageNames! {
                if let image = UIImage(named: name) {
                    images.append(image)
                }
            }
            imageView.animationImages = images
            imageView.animationDuration = duration
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.startAnimating()
            hudView!.addSubview(imageView)
            indicatorView = imageView
        } else {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            if style == .Light {
                activityIndicator.color = UIColor.blackColor()
            }
            activityIndicator.startAnimating()
            hudView!.addSubview(activityIndicator)
            indicatorView = activityIndicator
        }
        
        // set views' frame
        let padding = CGFloat(14.0)
        let hudHeight = CGFloat(37)
        let mainSide = max(textSize.width, hudHeight + padding + textSize.height) + 2 * padding
        let loadFrame = CGRectMake(0, (mainSide - textSize.height - hudHeight - padding)/2, mainSide, hudHeight)
        indicatorView!.frame = loadFrame
        let textFrame = CGRectMake(padding, CGRectGetMaxY(loadFrame) + padding, mainSide - 2 * padding, textSize.height)
        textLabel.frame = textFrame
        
        let mainFrame = CGRectMake(0, 0, mainSide, mainSide)
        hudView!.frame = mainFrame
        hidden = false
        addSubview(hudView!)
        
        addToTargetView(targetView)
        
        needLayout = false
    }
    
    private func keyWindow() -> UIWindow? {
        let windows = UIApplication.sharedApplication().windows
        for window in windows {
            let windowOnMainScreen = window.screen == UIScreen.mainScreen()
            let windowIsVisible = !window.hidden && window.alpha > 0
            let windowLevelNormal = window.windowLevel == UIWindowLevelNormal
            if windowOnMainScreen && windowIsVisible && windowLevelNormal {
                return window
            }
        }
        return nil
    }
    
    // add to targetView
    private func addToTargetView(targetView: UIView?) {
        transform = CGAffineTransformIdentity
        if let view = targetView {
            frame = view.bounds
            hudView!.center = center
            view.addSubview(self)
        } else {
            // if targetView is nil, add to the window
            if let window = keyWindow() {
                frame = window.bounds
                hudView!.center = center
                window.addSubview(self)
            }
        }
    }
}

class MCProgressHUD {
    
    private var showCount = 0
    private let progressHudView = MCProgressHUDView()
    class var sharedManager: MCProgressHUD {
        struct Static {
            static let manager = MCProgressHUD()
        }
        return Static.manager
    }
    
    private func showInTargetView(targetView: UIView? = nil, imageNames: [String]? = nil, timeInterval: Int = 0, text: String?, detailText: String? = nil, style: MCProgressHUDStyle = .Light, animated: Bool = true) {
        // fix different view controller not call hide, show hud all the time
        if progressHudView.superview == nil {
            showCount = 0
        }
        
        ++showCount
        progressHudView.text = text
        progressHudView.detailText = detailText
        progressHudView.imageNames = imageNames
        progressHudView.style = style
        progressHudView.showInTargetView(targetView)
        
        if animated {
            // the scale and fade animation
            progressHudView.alpha = 0.0
            progressHudView.transform = CGAffineTransformMakeScale(0.8, 0.8)
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.progressHudView.alpha = 1.0
                self.progressHudView.transform = CGAffineTransformIdentity
            })
        }
    }
    
    private func hideWithAnimated(animated: Bool = true) {
        guard progressHudView.superview != nil || showCount != 0 else {
            showCount = 0
            return
        }
        guard showCount == 1 else {
            --showCount
            return
        }
        if animated {
            // the hide animation
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.progressHudView.alpha = 0.0
                self.progressHudView.transform = CGAffineTransformMakeScale(0.8, 0.8)
                }, completion: { (finished) -> Void in
                    self.progressHudView.removeFromSuperview()
                    self.showCount = 0
            })
        } else {
            progressHudView.removeFromSuperview()
            showCount = 0
        }
    }
    
}

extension MCProgressHUD {
    
    class func show(targetView targetView: UIView? = nil, imageNames: [String]? = nil, timeInterval: Int = 0, text: String?, detailText: String? = nil, style: MCProgressHUDStyle = .Dark, animated: Bool = true) {
        MCProgressHUD.sharedManager.showInTargetView(targetView, imageNames: imageNames, timeInterval: timeInterval, text: text, detailText: detailText, style: style, animated: animated)
    }
    
    class func hide(animated: Bool = true) {
        MCProgressHUD.sharedManager.hideWithAnimated(animated)
    }
    
}


