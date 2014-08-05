//
//  NSObjectExtension.swift
//  Dong
//
//  Created by darkdong on 14-8-1.
//  Copyright (c) 2014年 Dong. All rights reserved.
//

import Foundation

var associatedObjectKey = 0

extension NSObject {
    var associatedObject: AnyObject! {
        get {
            return objc_getAssociatedObject(self, &associatedObjectKey)
        }
        set {
            objc_setAssociatedObject(self, &associatedObjectKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
}