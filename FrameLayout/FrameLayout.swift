//
//  Layout.swift
//
//  Created by Evgeny Mikhaylov on 05/12/2016.
//  Copyright © 2016 Evgeny Mikhaylov. All rights reserved.
//

import CoreGraphics

public class FrameLayout {
    init(layoutedObject: FrameLayoutSupport) {
        _applying = false
        self.layoutedObject = layoutedObject
    }

    private init(frameLayout: FrameLayout) {
        layoutedObject = frameLayout.layoutedObject
        _applying = frameLayout._applying
        _left = frameLayout._left
        _right = frameLayout._right
        _width = frameLayout._width
        _centerX = frameLayout._centerX
        _top = frameLayout._top
        _bottom = frameLayout._bottom
        _height = frameLayout._height
        _centerY = frameLayout._centerY
    }

    private(set) unowned var layoutedObject: FrameLayoutSupport

    // MARK: - Base

    var left: CGFloat {
        set {
            _left = newValue
            _apply()
        }
        get {
            return _originX
        }
    }
    var right: CGFloat {
        set {
            _right = newValue
            _apply()
        }
        get {
            return _originX + _sizeWidth
        }
    }
    var width: CGFloat {
        set {
            _width = newValue
            _apply()
        }
        get {
            return _sizeWidth
        }
    }
    var centerX: CGFloat {
        set {
            _centerX = newValue
            _apply()
        }
        get {
            return _originX + _sizeWidth / 2.0
        }
    }
    var top: CGFloat {
        set {
            _top = newValue
            _apply()
        }
        get {
            return _originY
        }
    }
    var bottom: CGFloat {
        set {
            _bottom = newValue
            _apply()
        }
        get {
            return _originY + _sizeHeight
        }
    }
    var height: CGFloat {
        set {
            _height = newValue
            _apply()
        }
        get {
            return _sizeHeight
        }
    }
    var centerY: CGFloat {
        set {
            _centerY = newValue
            _apply()
        }
        get {
            return _originY + _sizeHeight / 2.0
        }
    }

    // MARK: - Center

    func centerHorizontally() {
        if let parent = layoutedObject.parent {
            centerX = parent.frameLayout.width / 2.0
        }
    }
    
    func centerVertically() {
        if let parent = layoutedObject.parent {
            centerY = parent.frameLayout.height / 2.0
        }
    }
    
    // MARK: - Margins
    
    var leftMargin: CGFloat {
        set {
            _left = newValue
            _apply()
        }
        get {
            return _originX
        }
    }
    var rightMargin: CGFloat {
        set {
            if let parent = layoutedObject.parent {
                _right = parent.frameLayout.width - newValue
                _apply()
            }
        }
        get {
            if let parent = layoutedObject.parent {
                return parent.frameLayout.width - right
            }
            return 0.0
        }
    }
    var topMargin: CGFloat {
        set {
            _top = newValue
            _apply()
        }
        get {
            return _originY
        }
    }
    var bottomMargin: CGFloat {
        set {
            if let parent = layoutedObject.parent {
                _bottom = parent.frameLayout.height - newValue
                _apply()
            }
        }
        get {
            if let parent = layoutedObject.parent {
                return parent.frameLayout.height - bottom
            }
            return 0.0
        }
    }
//    var margins: UIEdgeInsets {
//        set {
//            _left = newValue.left
//            _top = newValue.top
//            if let superLayoutingObject = layoutedObject?.superObject {
//                _right = superLayoutingObject.frameLayout.width - newValue.right
//                _bottom = superLayoutingObject.frameLayout.height - newValue.bottom
//            }
//            _apply()
//        }
//        get {
//            if let superLayoutingObject = layoutedObject?.superObject {
//                return UIEdgeInsets(
//                    top: _originY,
//                    left: _originX,
//                    bottom: superLayoutingObject.frameLayout.height - bottom,
//                    right: superLayoutingObject.frameLayout.width - right
//                )
//            }
//            return UIEdgeInsets.zero
//        }
//    }
    
    func apply(block: (FrameLayout) -> Void) {
        let frameLayout = FrameLayout(frameLayout: self)
        frameLayout._applying = true
        block(frameLayout)
        frameLayout._applying = false
        frameLayout._apply()
    }
    
    func upsideDownChilds() {
        for child in layoutedObject.childs {
            child.frame.origin.y = height - child.frameLayout.bottom
        }
    }
    
    // MARK: - Private
    
    private var _applying: Bool
    
    private var _left: CGFloat?
    private var _right: CGFloat?
    private var _width: CGFloat?
    private var _centerX: CGFloat?
    private var _top: CGFloat?
    private var _bottom: CGFloat?
    private var _height: CGFloat?
    private var _centerY: CGFloat?
    
    private var _originX: CGFloat {
        var originX: CGFloat = 0.0
        if let left = _left {
            originX = left
        }
        else if let right = _right, let width = _width {
            originX = right - width
        }
        else if let right = _right, let centerX = _centerX {
            originX = right - 2.0 * (right - centerX)
        }
        else if let centerX = _centerX, let width = _width {
            originX = centerX - width / 2.0
        }
        else {
            originX = layoutedObject.frame.minX
        }
        return originX
    }
    
    private var _originY: CGFloat {
        var originY: CGFloat = 0.0
        if let top = _top {
            originY = top
        }
        else if let bottom = _bottom, let height = _height {
            originY = bottom - height
        }
        else if let bottom = _bottom, let centerY = _centerY {
            originY = bottom - 2.0 * (bottom - centerY)
        }
        else if let centerY = _centerY, let height = _height {
            originY = centerY - height / 2.0
        }
        else {
            originY = layoutedObject.frame.minY
        }
        return originY
    }

    private var _sizeWidth: CGFloat {
        var sizeWidth: CGFloat = 0.0
        if let width = _width {
            sizeWidth = width
        }
        else if let left = _left, let right = _right {
            sizeWidth = right - left
        }
        else if let left = _left, let centerX = _centerX {
            sizeWidth = 2.0 * (centerX - left)
        }
        else if let centerX = _centerX, let right = _right {
            sizeWidth = 2.0 * (right - centerX)
        }
        else {
            sizeWidth = layoutedObject.frame.width
        }
        return sizeWidth
    }
    
    private var _sizeHeight: CGFloat {
        var sizeHeight: CGFloat = 0.0
        if let height = _height {
            sizeHeight = height
        }
        else if let top = _top, let bottom = _bottom {
            sizeHeight = bottom - top
        }
        else if let top = _top, let centerY = _centerY {
            sizeHeight = 2.0 * (centerY - top)
        }
        else if let centerY = _centerY, let bottom = _bottom {
            sizeHeight = 2.0 * (bottom - centerY)
        }
        else {
            sizeHeight = layoutedObject.frame.height
        }
        return sizeHeight
    }
    
    private var _frame: CGRect {
        return CGRect(x: _originX, y: _originY, width: _sizeWidth, height: _sizeHeight)
    }
    
    private func _apply() {
        if !_applying {
            layoutedObject.frame = _frame
        }
    }
}
