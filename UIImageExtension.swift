//
//  UIImageExtension.swift
//  Dong
//
//  Created by darkdong on 14-8-5.
//  Copyright (c) 2014年 Dong. All rights reserved.
//

import UIKit

var rgbColorSpace: CGColorSpace?

extension UIImage {
    convenience init(namedNoCache: String!) {
        let baseNames = [namedNoCache + "@2x", namedNoCache]
        let extNames = ["png", "jpg"]
        let bundle = NSBundle.mainBundle()
        
        for extName in extNames {
            for baseName in baseNames {
                if let path = bundle.pathForResource(baseName, ofType: extName) {
                    return self.init(contentsOfFile: path)
                }
            }
        }
        
        return self.init()
    }
    
    func resizableImage() -> UIImage! {
        let width = self.size.width
        let height = self.size.height
        let insets = UIEdgeInsets(top: height / 2, left: width / 2, bottom: height / 2, right: width / 2)
        return self.resizableImageWithCapInsets(insets)
    }
    
    func croppedImage(#rect: CGRect) -> UIImage! {
        let cgimage = CGImageCreateWithImageInRect(self.CGImage, rect)
        return UIImage(CGImage: cgimage, scale: self.scale, orientation: self.imageOrientation)
    }
    
    func resizedImage(#size: CGSize, quality: CGInterpolationQuality = kCGInterpolationDefault) -> UIImage! {
        var drawTransposed = false
        switch self.imageOrientation {
        case .Left, .LeftMirrored, .Right, .RightMirrored:
            drawTransposed = true
        default:
            break
        }
        let transform = self.transformForSize(size)
        return self.resizedImage(size: size, transform: transform, drawTransposed: drawTransposed, quality: quality)
    }
    
    func transformForSize(size: CGSize) -> CGAffineTransform {
        var transform = CGAffineTransformIdentity
        
        switch self.imageOrientation {
        case .Down, // EXIF = 3
        .DownMirrored: // EXIF = 4
            transform = CGAffineTransformTranslate(transform, size.width, size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        case .Left, // EXIF = 6
        .LeftMirrored: // EXIF = 5
            transform = CGAffineTransformTranslate(transform, size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        case .Right, // EXIF = 8
        .RightMirrored: // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
        default:
            break
        }
        
        switch self.imageOrientation {
        case .UpMirrored, // EXIF = 2
        .DownMirrored: // EXIF = 4
            transform = CGAffineTransformTranslate(transform, size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        case .LeftMirrored, // EXIF = 5
        .RightMirrored: // EXIF = 7
            transform = CGAffineTransformTranslate(transform, size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        default:
            break
        }
        
        return transform
    }
    
    func resizedImage(#size: CGSize, transform: CGAffineTransform, drawTransposed: Bool, quality: CGInterpolationQuality = kCGInterpolationDefault) -> UIImage {
        let rect = CGRectIntegral(CGRectMake(0, 0, size.width * self.scale, size.height * self.scale))
        let transposedRect = CGRect(x: 0, y: 0, width: rect.height, height: rect.width)
        let cgimage = self.CGImage
        
        if rgbColorSpace == nil {
            rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        }
        
        let bitmapInfo = CGBitmapInfo.fromRaw(CGImageAlphaInfo.PremultipliedFirst.toRaw())!
        let bitmap: CGContext = CGBitmapContextCreate(nil, UInt(rect.width), UInt(rect.height), 8, UInt(rect.width) * 4, rgbColorSpace, bitmapInfo);
        
        CGContextConcatCTM(bitmap, transform);
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(bitmap, quality);
        
        // Draw into the context; this scales the image
        CGContextDrawImage(bitmap, drawTransposed ? transposedRect : rect, cgimage);
        
        // Get the resized image from the context and a UIImage
        let resizedCGImage = CGBitmapContextCreateImage(bitmap);
        
        return UIImage(CGImage: resizedCGImage, scale: self.scale, orientation: .Up)
    }
}
