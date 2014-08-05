//
//  DDClosureButton.swift
//  Dong
//
//  Created by darkdong on 14-8-4.
//  Copyright (c) 2014年 Dong. All rights reserved.
//

import UIKit

typealias ButtonActionHandler = (button: UIButton!) -> Void

class DDClosureButton: UIButton {
    
    var touchUpInsideHandler: ButtonActionHandler? {
    willSet {
        let action: Selector = "buttonClicked:"
        let event: UIControlEvents = .TouchUpInside
        
        if newValue != nil {
            self.addTarget(self, action: action, forControlEvents: event)
        }else {
            self.removeTarget(self, action: action, forControlEvents: event)
        }
    }
    }
    
    func buttonClicked(sender: UIButton!) {
        println("call touchUpInsideHandler")
        self.touchUpInsideHandler!(button: self)
    }
}
