//
//  MCDetectingImageView.swift
//  MCPhotoBrowser
//
//  Created by iflytek on 16/1/20.
//  Copyright © 2016年 zhmch0329. All rights reserved.
//

import UIKit

@objc protocol MCDetectingImageViewDelegate {
    func handleImageViewSingleTap(view: UIImageView, touch: UITouch)
    func handleImageViewDoubleTap(view: UIImageView, touch: UITouch)
}

class MCDetectingImageView: UIImageView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        userInteractionEnabled = true
    }
    
    weak var delegate: MCDetectingImageViewDelegate?
    
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
        delegate?.handleImageViewSingleTap(self, touch: touch)
    }
    func handleDoubleTap(touch: UITouch) {
        delegate?.handleImageViewDoubleTap(self, touch: touch)
    }
    
}
