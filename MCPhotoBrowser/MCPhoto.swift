//
//  MCPhoto.swift
//  MCPhotoBrowser
//
//  Created by iflytek on 16/1/20.
//  Copyright © 2016年 zhmch0329. All rights reserved.
//

import UIKit

// MARK: - MCPhoto
class MCPhoto: NSObject {
    
    var underlyingImage: UIImage!
    var photoURL: String!
    var shouldCachePhotoURLImage: Bool = false
    var caption: String!
    
    override init() {
        super.init()
    }
    
    convenience init(image: UIImage){
        self.init()
        underlyingImage = image
    }
    
    convenience init(url: String){
        self.init()
        photoURL = url
    }
    
    func checkCache(){
        if photoURL != nil && shouldCachePhotoURLImage {
            if let img = UIImage.sharedMCPhotoCache().objectForKey(photoURL) as? UIImage{
                underlyingImage = img
            }
        }
    }
    
    func loadUnderlyingImageAndNotify(){
        if underlyingImage != nil{
            loadUnderlyingImageComplete()
        }
        
        if photoURL != nil {
            // Fetch Image
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            if let nsURL = NSURL(string: photoURL) {
                session.dataTaskWithURL(nsURL, completionHandler: { [weak self](response: NSData?, data: NSURLResponse?, error: NSError?) in
                    if let _self = self {
                        if error != nil {
                            dispatch_async(dispatch_get_main_queue()) {
                                _self.loadUnderlyingImageComplete()
                            }
                        }
                        if let res = response, let image = UIImage(data: res) {
                            if _self.shouldCachePhotoURLImage {
                                UIImage.sharedMCPhotoCache().setObject(image, forKey: _self.photoURL)
                            }
                            dispatch_async(dispatch_get_main_queue()) {
                                _self.underlyingImage = image
                                _self.loadUnderlyingImageComplete()
                            }
                        }
                        session.finishTasksAndInvalidate()
                    }
                    }).resume()
            }
        }
    }
    
    func loadUnderlyingImageComplete(){
        NSNotificationCenter.defaultCenter().postNotificationName(MCPHOTO_LOADING_DID_END_NOTIFICATION, object: self)
    }
    
    // MARK: - class func
    class func photoWithImage(image: UIImage) -> MCPhoto {
        return MCPhoto(image: image)
    }
    class func photoWithImageURL(url: String) -> MCPhoto {
        return MCPhoto(url: url)
    }
}

// MARK: - extension UIImage
extension UIImage {
    private class func sharedMCPhotoCache() -> NSCache! {
        struct StaticSharedMCPhotoCache {
            static var sharedCache: NSCache? = nil
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&StaticSharedMCPhotoCache.onceToken) {
            StaticSharedMCPhotoCache.sharedCache = NSCache()
        }
        return StaticSharedMCPhotoCache.sharedCache!
    }
}