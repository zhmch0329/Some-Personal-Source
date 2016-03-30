//
//  MCIndicatorView.swift
//  MCPhotoBrowser
//
//  Created by iflytek on 16/1/20.
//  Copyright © 2016年 zhmch0329. All rights reserved.
//

import UIKit

class MCIndicatorView: UIActivityIndicatorView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        center = CGPointMake(frame.width/2, frame.height/2)
        activityIndicatorViewStyle = .WhiteLarge
    }
}
