//
//  FrameLayoutSupport.swift
//  SwiftLayoutExample
//
//  Created by Evgeny Mikhaylov on 14/12/2016.
//  Copyright © 2016 Evgeny Mikhaylov. All rights reserved.
//

import CoreGraphics

public protocol FrameLayoutSupport: class {
    var frame: CGRect { get set }
    var frameLayout: FrameLayout { get }
    var parent: FrameLayoutSupport? { get }
    var childs: [FrameLayoutSupport] { get }
}

public extension FrameLayoutSupport {
    var frameLayout: FrameLayout {
        var frameLayoutKey = "frameLayout"
        var frameLayout = objc_getAssociatedObject(self, &frameLayoutKey) as! FrameLayout?;
        if (frameLayout == nil) {
            frameLayout = FrameLayout(layoutedObject: self)
            objc_setAssociatedObject(self, &frameLayoutKey, frameLayout, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return frameLayout!
    }
}
