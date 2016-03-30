//
//  MCZoomingScrollView.swift
//  MCPhotoBrowser
//
//  Created by iflytek on 16/1/20.
//  Copyright © 2016年 zhmch0329. All rights reserved.
//

import UIKit

class MCZoomingScrollView: UIScrollView, UIScrollViewDelegate, MCDetectingViewDelegate, MCDetectingImageViewDelegate {

    weak var photoBrowser: MCPhotoBrowser!
    var photo: MCPhoto!{
        didSet{
            photoImageView.image = nil
            displayImage()
        }
    }
    
    var captionView: MCCaptionView!
    var tapView: MCDetectingView!
    var photoImageView: MCDetectingImageView!
    var indicatorView: MCIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(frame: CGRect, browser: MCPhotoBrowser) {
        self.init(frame: frame)
        photoBrowser = browser
        setup()
    }
    
    
    func setup() {
        // tap
        tapView = MCDetectingView(frame: bounds)
        tapView.delegate = self
        tapView.backgroundColor = UIColor.clearColor()
        tapView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        addSubview(tapView)
        
        // image
        photoImageView = MCDetectingImageView(frame: frame)
        photoImageView.delegate = self
        photoImageView.backgroundColor = UIColor.clearColor()
        addSubview(photoImageView)
        
        // indicator
        indicatorView = MCIndicatorView(frame: frame)
        addSubview(indicatorView)
        
        // self
        backgroundColor = UIColor.clearColor()
        delegate = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        decelerationRate = UIScrollViewDecelerationRateFast
        autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    }
    
    // MARK: - override
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tapView.frame = bounds
        
        let boundsSize = bounds.size
        var frameToCenter = photoImageView.frame
        
        // horizon
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = floor((boundsSize.width - frameToCenter.size.width) / 2)
        } else {
            frameToCenter.origin.x = 0
        }
        // vertical
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = floor((boundsSize.height - frameToCenter.size.height) / 2)
        } else {
            frameToCenter.origin.y = 0
        }
        
        // Center
        if !CGRectEqualToRect(photoImageView.frame, frameToCenter){
            photoImageView.frame = frameToCenter
        }
    }
    
    func setMaxMinZoomScalesForCurrentBounds(){
        
        maximumZoomScale = 1
        minimumZoomScale = 1
        zoomScale = 1
        
        if photoImageView == nil {
            return
        }
        
        let boundsSize = bounds.size
        let imageSize = photoImageView.frame.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        var maxScale: CGFloat = 4.0
        let minScale: CGFloat = min(xScale, yScale)
        
        maximumZoomScale = maxScale
        minimumZoomScale = minScale
        zoomScale = minScale
        
        // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
        // maximum zoom scale to 0.5
        maxScale = maxScale / UIScreen.mainScreen().scale
        if maxScale < minScale {
            maxScale = minScale * 2
        }
        
        // reset position
        photoImageView.frame = CGRectMake(0, 0, photoImageView.frame.size.width, photoImageView.frame.size.height)
        setNeedsLayout()
    }
    
    func prepareForReuse(){
        photo = nil
    }
    
    // MARK: - image
    func displayImage(){
        // reset scale
        maximumZoomScale = 1
        minimumZoomScale = 1
        zoomScale = 1
        contentSize = CGSizeZero
        
        let image = photoBrowser.imageForPhoto(photo)
        if let image = image {
            
            // indicator
            indicatorView.stopAnimating()
            
            // image
            photoImageView.image = image
            
            var photoImageViewFrame = CGRectZero
            photoImageViewFrame.origin = CGPointZero
            photoImageViewFrame.size = image.size
            
            photoImageView.frame = photoImageViewFrame
            
            contentSize = photoImageViewFrame.size
            
            setMaxMinZoomScalesForCurrentBounds()
        } else {
            // indicator
            indicatorView.startAnimating()
        }
        
        setNeedsLayout()
    }
    
    func displayImageFailure(){
        indicatorView.stopAnimating()
    }
    
    
    // MARK: - handle tap
    func handleDoubleTap(touchPoint: CGPoint){
        NSObject.cancelPreviousPerformRequestsWithTarget(photoBrowser)
        
        if zoomScale > minimumZoomScale{
            // zoom out
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            // zoom in
            var newZoom: CGFloat = zoomScale * 2.0
            if newZoom >= maximumZoomScale {
                newZoom = maximumZoomScale
            }
            
            zoomToRect(zoomRectForScrollView(newZoom, touchPoint:touchPoint), animated:true)
        }
        
        // delay control
        photoBrowser.hideControlsAfterDelay()
    }
    
    func zoomRectForScrollView(withScale: CGFloat, touchPoint:CGPoint) -> CGRect{
        return CGRectMake(touchPoint.x - (frame.size.width / 2.0),
            touchPoint.y - (frame.size.height / 2.0),
            frame.size.width, frame.size.height)
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        photoBrowser.cancelControlHiding()
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    
    // MARK: - MCDetectingViewDelegate
    func handleSingleTap(view: UIView, touch: UITouch) {
        photoBrowser.toggleControls()
    }
    
    func handleDoubleTap(view: UIView, touch: UITouch) {
        // nothing to do
    }
    
    // MARK: - MCDetectingImageViewDelegate
    func handleImageViewSingleTap(view: UIImageView, touch: UITouch) {
        photoBrowser.toggleControls()
    }
    
    func handleImageViewDoubleTap(view: UIImageView, touch: UITouch) {
        handleDoubleTap(touch.locationInView(view))
    }
    
}
