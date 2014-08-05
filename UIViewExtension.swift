//
//  UIViewExtension.swift
//  Dong
//
//  Created by darkdong on 14-7-30.
//  Copyright (c) 2014年 Dong. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK:- geometry
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }
    
    var left: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self.origin.x = newValue
        }
    }
    
    var right: CGFloat {
        get {
            return self.origin.x + self.width
        }
        set {
            self.origin.x = newValue - self.width
        }
    }
    
    var top: CGFloat {
        get {
            return self.origin.y
        }
        set {
            self.origin.y = newValue
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.origin.y + self.height
        }
        set {
            self.origin.y = newValue - self.height
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y: self.centerY)
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.centerX, y: newValue)
        }
    }
    
    var centerOfSize: CGPoint {
        return CGPoint(x: self.width / 2, y: self.height / 2)
    }
    
    func setHeightWhileKeepingBottom(height: CGFloat) {
        self.origin.y += self.height - height
        self.height = height
    }
    
    // MARK:- hierarchy
    
    func viewController() -> UIViewController! {
        for var nextview = self.superview; nextview != nil; nextview = nextview!.superview {
            if let responder = nextview!.nextResponder() as? UIViewController {
                return responder
            }
        }
        return nil
    }
    
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    // MARK:- layout
    
    class func xlayoutViews(views: [UIView], constrainedToRect: CGRect, insets: UIEdgeInsets = UIEdgeInsetsZero, verticalAlignment: UIControlContentVerticalAlignment = .Center, spacings: [CGFloat]? = nil) {
        
        //exclude hidden views
        let visibleViews = views.filter {
            !$0.hidden
        }
        
        if 0 == visibleViews.count {
            return
        }
        
        if 1 == visibleViews.count {
            
            let view = visibleViews[0]
            
            //layout horizontal
            if 0 == insets.left && 0 == insets.right {
                view.centerX = constrainedToRect.midX
            }else if insets.left != 0 {
                view.left = constrainedToRect.minX + insets.left
            }else {
                view.right = constrainedToRect.maxX - insets.right
            }
            
            //layout vertical
            if insets.top != 0 {
                view.top = constrainedToRect.minY + insets.top
            }else if insets.bottom != 0 {
                view.bottom = constrainedToRect.maxY - insets.bottom
            }else {
                //no insets top or bottom，use verticalAlignment
                if UIControlContentVerticalAlignment.Top == verticalAlignment {
                    view.top = constrainedToRect.minY
                }else if UIControlContentVerticalAlignment.Bottom == verticalAlignment {
                    view.bottom = constrainedToRect.maxY
                }else {
                    view.centerY = constrainedToRect.midY
                }
            }
        }else {
            let totalViewsWidth = visibleViews.reduce(0) {
                $0 + $1.width
            }
            let autoSpacing: CGFloat = (constrainedToRect.width - insets.left - insets.right - totalViewsWidth) / (CGFloat) (visibleViews.count - 1)
            let customSpacings = spacings != nil ? spacings! : []
            
            var x = constrainedToRect.minX + insets.left
            var y: CGFloat
            
            for (i, view) in enumerate(visibleViews) {
                let spacing = i < customSpacings.count ? customSpacings[i] : autoSpacing
                
                if insets.top != 0 {
                    y = constrainedToRect.minY + insets.top
                }else if insets.bottom != 0 {
                    y = constrainedToRect.maxY - insets.bottom - view.height
                }else {
                    //no insets top or bottom，use verticalAlignment
                    if UIControlContentVerticalAlignment.Top == verticalAlignment {
                        y = constrainedToRect.minY
                    }else if UIControlContentVerticalAlignment.Bottom == verticalAlignment {
                        y = constrainedToRect.maxY - view.height
                    }else {
                        y = constrainedToRect.midY - view.height / 2
                    }
                }
                view.origin = CGPoint(x: x, y: y)
                x += view.width + spacing
            }
        }
    }
    
    func xlayoutSubviews(insets: UIEdgeInsets = UIEdgeInsetsZero, verticalAlignment: UIControlContentVerticalAlignment = .Center, spacings: [CGFloat]? = nil, constrainedToRect: CGRect? = nil) {
        
        let subviews = self.subviews as [UIView]
        let rect = constrainedToRect != nil ? constrainedToRect! : CGRect(x: 0, y: 0, width: self.width, height: self.height)
        
        UIView.xlayoutViews(subviews, constrainedToRect: rect, insets: insets, verticalAlignment: verticalAlignment, spacings: spacings)
    }
    
    class func ylayoutViews(views: [UIView], constrainedToRect: CGRect, insets: UIEdgeInsets = UIEdgeInsetsZero, horizontalAlignment: UIControlContentHorizontalAlignment = .Center, spacings: [CGFloat]? = nil) {
        
        //exclude hidden views
        let visibleViews = views.filter {
            !$0.hidden
        }
        
        if 0 == visibleViews.count {
            return
        }
        
        if 1 == visibleViews.count {
            
            let view = visibleViews[0]
            
            //layout vertical
            if 0 == insets.top && 0 == insets.bottom {
                view.centerY = constrainedToRect.midY
            }else if insets.top != 0 {
                view.top = constrainedToRect.minY
            }else {
                view.bottom = constrainedToRect.maxY - insets.bottom
            }
            
            //layout horizontal
            if insets.left != 0 {
                view.left = constrainedToRect.minX + insets.left
            }else if insets.right != 0 {
                view.right = constrainedToRect.maxX - insets.right
            }else {
                //no insets left or right，use horizontalAlignment
                if UIControlContentHorizontalAlignment.Left == horizontalAlignment {
                    view.left = constrainedToRect.minX
                }else if UIControlContentHorizontalAlignment.Right == horizontalAlignment {
                    view.right = constrainedToRect.maxX
                }else {
                    view.centerX = constrainedToRect.midX
                }
            }
        }else {
            let totalViewsHeight = visibleViews.reduce(0) {
                $0 + $1.height
            }
            let autoSpacing: CGFloat = (constrainedToRect.height - insets.top - insets.bottom - totalViewsHeight) / CGFloat(visibleViews.count - 1)
            let customSpacings = spacings != nil ? spacings! : []
            
            var x: CGFloat
            var y = constrainedToRect.minY + insets.top
            
            for (i, view) in enumerate(visibleViews) {
                let spacing = i < customSpacings.count ? customSpacings[i] : autoSpacing
                
                if insets.left != 0 {
                    x = constrainedToRect.minX + insets.left
                }else if insets.right != 0 {
                    x = constrainedToRect.maxX - insets.right - view.width
                }else {
                    //no insets left or right，use horizontalAlignment
                    if UIControlContentHorizontalAlignment.Left == horizontalAlignment {
                        x = constrainedToRect.minX
                    }else if UIControlContentHorizontalAlignment.Right == horizontalAlignment {
                        x = constrainedToRect.maxX - view.width
                    }else {
                        x = constrainedToRect.midX - view.width / 2
                    }
                }
                view.origin = CGPoint(x: x, y: y)
                y += view.height + spacing
            }
        }
    }
    
    func ylayoutSubviews(insets: UIEdgeInsets = UIEdgeInsetsZero, horizontalAlignment: UIControlContentHorizontalAlignment = .Center, spacings: [CGFloat]? = nil, constrainedToRect: CGRect? = nil) {
        
        let subviews = self.subviews as [UIView]
        let rect = constrainedToRect != nil ? constrainedToRect! : CGRect(x: 0, y: 0, width: self.width, height: self.height)
        
        UIView.ylayoutViews(subviews, constrainedToRect: rect, insets: insets, horizontalAlignment: horizontalAlignment, spacings: spacings)
    }
    
    class func xylayoutViews(views: [UIView], constrainedToRect: CGRect, columns: Int, gridSize: CGSize, insets: UIEdgeInsets = UIEdgeInsetsZero ) {
        
        if columns <= 1 {
            UIView.ylayoutViews(views, constrainedToRect: constrainedToRect, insets: insets)
            return
        }
        
        //exclude hidden views
        let visibleViews = views.filter {
            !$0.hidden
        }
        
        if 0 == visibleViews.count {
            return
        }
        
        let autoSpacing: CGFloat = (constrainedToRect.width - insets.left - insets.right - CGFloat(columns) * gridSize.width) / CGFloat(columns - 1)
        let rows = (visibleViews.count + columns - 1) / columns
        
        let firstOriginX = constrainedToRect.minX + insets.left
        let firstOriginY = constrainedToRect.minY + insets.top
        let firstCenterX = firstOriginX + gridSize.width / 2
        let firstCenterY = firstOriginY + gridSize.height / 2
        var currentCenter = CGPoint(x: firstCenterX, y: firstCenterY)
        var index = 0;
        
        for view in visibleViews {
            if index > 0 && 0 == index % columns {
                //new row
                currentCenter.x = firstCenterX
                currentCenter.y += gridSize.height + autoSpacing
            }
            view.center = currentCenter
            currentCenter.x += gridSize.width + autoSpacing
            index++
        }
    }
    
    func xylayoutSubviews(columns: Int, gridSize: CGSize, insets: UIEdgeInsets? = nil, constrainedToRect: CGRect? = nil) {
        let subviews = self.subviews as [UIView]
        let rect = constrainedToRect != nil ? constrainedToRect! : CGRect(x: 0, y: 0, width: self.width, height: self.height)
        var autoInsets: UIEdgeInsets
        if insets != nil {
            autoInsets = insets!
        }else {
            let autoSpacing: CGFloat = (rect.width - CGFloat(columns) * gridSize.width) / CGFloat(columns + 1)
            autoInsets = UIEdgeInsets(top: autoSpacing, left: autoSpacing, bottom: autoSpacing, right: autoSpacing)
        }
        UIView.xylayoutViews(subviews, constrainedToRect: rect, columns: columns, gridSize: gridSize, insets: autoInsets)
    }
}
    