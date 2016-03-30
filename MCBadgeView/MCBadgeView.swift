//
//  MCBadgeView.swift
//  MCBadgeView
//
//  Created by iflytek on 16/1/8.
//  Copyright © 2016年 zhmch0329. All rights reserved.
//

import UIKit

enum MCBadgeViewAlignment {
    case TopLeft, TopCenter, TopRight, CenterLeft, Center, CenterRight, BottomLeft, BottomCenter, BottomRitght
}

let MCBadgeViewShadowRadius: CGFloat = 1.0
let MCBadgeViewHeight: CGFloat = 16.0
let MCBadgeViewTextSideMargin: CGFloat = 8.0
let MCBadgeViewCornerRadius: CGFloat = 10.0
let MCBadgeViewRadius: CGFloat = 4.0

class MCBadgeView: UIView {
    
    var badgeValue: Int? {
        didSet {
            if badgeValue != oldValue {
                self.setNeedsLayout()
            }
        }
    }
    
    var badgeAlignment: MCBadgeViewAlignment = .TopRight {
        didSet {
            if badgeAlignment != oldValue {
                self.setNeedsLayout()
            }
        }
    }
    
    dynamic var badgeTextColor: UIColor = UIColor.whiteColor() {
        didSet {
            if badgeTextColor != oldValue {
                self.setNeedsLayout()
            }
        }
    }
    
    dynamic var badgeTextShadowOffset: CGSize = CGSizeZero {
        didSet {
            if badgeTextShadowOffset != oldValue {
                self.setNeedsLayout()
            }
        }
    }
    
    dynamic var badgeTextShadowColor = UIColor.clearColor() {
        didSet {
            if badgeTextShadowColor != oldValue {
                self.setNeedsLayout()
            }
        }
    }
    
    dynamic var badgeTextFont = UIFont.boldSystemFontOfSize(UIFont.systemFontSize()) {
        didSet {
            if badgeTextFont != oldValue {
                self.setNeedsLayout()
            }
        }
    }
    
    dynamic var badgeBackgroundColor = UIColor.redColor() {
        didSet {
            if badgeBackgroundColor != oldValue {
                self.setNeedsLayout()
            }
        }
    }
    
    dynamic var badgeShadowColor = UIColor.clearColor() {
        didSet {
            if badgeShadowColor != oldValue {
                self.setNeedsLayout()
            }
        }
    }
    
    dynamic var badgeShadowSize = CGSizeMake(0.0, 3.0) {
        didSet {
            if badgeShadowSize != oldValue {
                self.setNeedsLayout()
            }
        }
    }
    
    dynamic var badgeStrokeWidth: CGFloat = 0.0 {
        didSet {
            if badgeStrokeWidth != oldValue {
                self.setNeedsLayout()
            }
        }
    }
    
    dynamic var badgeStrokeColor = UIColor.redColor() {
        didSet {
            if badgeStrokeColor != oldValue {
                self.setNeedsLayout()
            }
        }
    }
    
    dynamic var badgePositionAdjustment = CGPointZero {
        didSet {
            if badgePositionAdjustment != oldValue {
                self.setNeedsLayout()
            }
        }
    }
    
    dynamic var frameToPositionInRelationWith: CGRect = CGRectZero {
        didSet {
            if frameToPositionInRelationWith != oldValue {
                self.setNeedsLayout()
            }
        }
    }
    
    dynamic var badgeMinWidth: CGFloat = 0 {
        didSet {
            if badgeMinWidth != oldValue {
                self.setNeedsLayout()
            }
        }
    }
    
    
    init(alignment: MCBadgeViewAlignment = .TopRight) {
        super.init(frame: CGRectMake(0, 0, 1, 1))
        self.backgroundColor = UIColor.clearColor()
        badgeAlignment = alignment
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Private
    private func sizeOfTextForCurrentSettings() -> CGSize {
        if let value = badgeValue {
            if value > 0 {
                let textAtt = NSAttributedString(string: "\(value)", attributes: [NSFontAttributeName: badgeTextFont])
                return textAtt.size()
            }
        }
        return CGSizeZero
    }
    
    private func marginToDrawInside() -> CGFloat {
        return badgeStrokeWidth * 2
    }
    
    // MARK: - override
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var newFrame = self.frame
        let superviewBounds = CGRectIsEmpty(frameToPositionInRelationWith) ? self.superview!.bounds : frameToPositionInRelationWith
        
        let textWidth = sizeOfTextForCurrentSettings().width
        
        let margin = marginToDrawInside()
        let viewWidth = max(badgeMinWidth, textWidth + MCBadgeViewTextSideMargin + (margin * 2))
        let viewHeight = MCBadgeViewHeight + (margin * 2)
        
        let superviewWidth = superviewBounds.size.width
        let superviewHeight = superviewBounds.size.height
        
        newFrame.size.width = max(viewWidth, viewHeight)
        newFrame.size.height = viewHeight
        
        switch badgeAlignment {
        case .TopLeft:
            newFrame.origin.x = -viewWidth / 2.0
            newFrame.origin.y = -viewHeight / 2.0
        case .TopCenter:
            newFrame.origin.x = (superviewWidth - viewWidth) / 2.0
            newFrame.origin.y = -viewHeight / 2.0
        case .TopRight:
            newFrame.origin.x = superviewWidth - (viewWidth / 2.0)
            newFrame.origin.y = -viewHeight / 2.0
        case .CenterLeft:
            newFrame.origin.x = -viewWidth / 2.0
            newFrame.origin.y = (superviewHeight - viewHeight) / 2.0
        case .Center:
            newFrame.origin.x = (superviewWidth - viewWidth) / 2.0
            newFrame.origin.y = (superviewHeight - viewHeight) / 2.0
        case .CenterRight:
            newFrame.origin.x = superviewWidth - (viewWidth / 2.0)
            newFrame.origin.y = (superviewHeight - viewHeight) / 2.0
        case .BottomLeft:
            newFrame.origin.x = -viewWidth / 2.0
            newFrame.origin.y = superviewHeight - (viewHeight / 2.0)
        case .BottomCenter:
            newFrame.origin.x = (superviewWidth - viewWidth) / 2.0
            newFrame.origin.y = superviewHeight - (viewHeight / 2.0)
        case .BottomRitght:
            newFrame.origin.x = superviewWidth - (viewWidth / 2.0)
            newFrame.origin.y = superviewHeight - (viewHeight / 2.0)
        }
        
        newFrame.origin.x += badgePositionAdjustment.x
        newFrame.origin.y += badgePositionAdjustment.y
        
        // Do not set frame directly so we do not interfere with any potential transform set on the view.
        self.bounds = CGRectIntegral(CGRectMake(0, 0, CGRectGetWidth(newFrame), CGRectGetHeight(newFrame)))
        self.center = CGPointMake(ceil(CGRectGetMidX(newFrame)), ceil(CGRectGetMidY(newFrame)))
        
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        if let value = badgeValue {
            if value > 0 {
                let ctx = UIGraphicsGetCurrentContext()
                
                let marginToDrawInside = self.marginToDrawInside()
                let rectToDraw = CGRectInset(rect, marginToDrawInside, marginToDrawInside)
                
                let borderPath = UIBezierPath(roundedRect: rectToDraw, byRoundingCorners: .AllCorners, cornerRadii: CGSizeMake(MCBadgeViewCornerRadius, MCBadgeViewCornerRadius))
                
                /* Background and shadow */
                CGContextSaveGState(ctx)
                CGContextAddPath(ctx, borderPath.CGPath)
                
                CGContextSetFillColorWithColor(ctx, badgeBackgroundColor.CGColor)
                CGContextSetShadowWithColor(ctx, badgeShadowSize, MCBadgeViewShadowRadius, badgeShadowColor.CGColor)
                
                CGContextDrawPath(ctx, .Fill)
                CGContextRestoreGState(ctx)
                
                /* Stroke */
                CGContextSaveGState(ctx)
                CGContextAddPath(ctx, borderPath.CGPath)
                
                CGContextSetLineWidth(ctx, badgeStrokeWidth)
                CGContextSetStrokeColorWithColor(ctx, badgeStrokeColor.CGColor)
                
                CGContextDrawPath(ctx, .Stroke)
                CGContextRestoreGState(ctx)
                
                /* Text */
                
                CGContextSaveGState(ctx)
                CGContextSetFillColorWithColor(ctx, badgeTextColor.CGColor)
                CGContextSetShadowWithColor(ctx, badgeTextShadowOffset, 1.0, badgeTextShadowColor.CGColor)
                
                var textFrame = rectToDraw
                let textSize = sizeOfTextForCurrentSettings()
                
                textFrame.size.height = textSize.height
                textFrame.origin.y = rectToDraw.origin.y + floor((rectToDraw.size.height - textFrame.size.height) / 2.0)
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .Center
                let badgeText = NSAttributedString(string: "\(value)", attributes: [NSFontAttributeName: badgeTextFont, NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: badgeTextColor])
                badgeText.drawInRect(textFrame)
                CGContextRestoreGState(ctx)
            }
        } else {
            let ctx = UIGraphicsGetCurrentContext()
            
            let rectToDraw = CGRectMake(rect.size.width/2 - MCBadgeViewRadius, rect.size.height/2 - MCBadgeViewRadius, MCBadgeViewRadius * 2, MCBadgeViewRadius * 2)
            
            let borderPath = UIBezierPath(roundedRect: rectToDraw, cornerRadius: MCBadgeViewRadius)
            
            /* Background and shadow */
            CGContextSaveGState(ctx)
            CGContextAddPath(ctx, borderPath.CGPath)
            
            CGContextSetFillColorWithColor(ctx, badgeBackgroundColor.CGColor)
            CGContextSetShadowWithColor(ctx, badgeShadowSize, MCBadgeViewShadowRadius, badgeShadowColor.CGColor)
            
            CGContextDrawPath(ctx, .Fill)
            CGContextRestoreGState(ctx)
            
            /* Stroke */
            CGContextSaveGState(ctx)
            CGContextAddPath(ctx, borderPath.CGPath)
            
            CGContextSetLineWidth(ctx, badgeStrokeWidth)
            CGContextSetStrokeColorWithColor(ctx, badgeStrokeColor.CGColor)
            
            CGContextDrawPath(ctx, .Stroke)
            CGContextRestoreGState(ctx)
            
        }
    }
    
}

extension UIView {
    func showBadgeValue(badgeValue: Int?, alignment: MCBadgeViewAlignment = .TopRight) {
        for view in self.subviews {
            if view.isKindOfClass(MCBadgeView.classForCoder()) {
                let badgeView = view as! MCBadgeView
                badgeView.badgeAlignment = alignment
                badgeView.badgeValue = badgeValue
                return
            }
        }
        let badgeView = MCBadgeView(alignment: alignment)
        badgeView.badgeValue = badgeValue
        self.addSubview(badgeView)
    }
}







