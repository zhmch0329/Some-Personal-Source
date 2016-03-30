//
//  MCDetectingView.swift
//  MCPhotoBrowser
//
//  Created by iflytek on 16/1/20.
//  Copyright © 2016年 zhmch0329. All rights reserved.
//

import UIKit

@objc protocol MCDetectingViewDelegate {
    func handleSingleTap(view:UIView, touch: UITouch)
    func handleDoubleTap(view:UIView, touch: UITouch)
}

class MCDetectingView: UIView {
    
    weak var delegate: MCDetectingViewDelegate?
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        let touch = touches.first!
        switch touch.tapCount {
        case 1 : handleSingleTap(touch)
        case 2 : handleDoubleTap(touch)
        default: break
        }
        nextResponder()
    }
    
    func handleSingleTap(touch: UITouch) {
        delegate?.handleSingleTap(self, touch: touch)
    }
    func handleDoubleTap(touch: UITouch) {
        delegate?.handleDoubleTap(self, touch: touch)
    }
    
}
