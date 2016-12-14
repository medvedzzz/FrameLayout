//
//  ViewController.swift
//  FrameLayoutExample
//
//  Created by Evgeny Mikhaylov on 14/12/2016.
//  Copyright © 2016 EvgenyMikhaylov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var redView: UIView = UIView()
    var blueView: UIView = UIView()
    
    var redLayer: CALayer = CALayer()
    var blueLayer: CALayer = CALayer()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redView.backgroundColor = UIColor.red
        view.addSubview(redView)
        
        blueView.backgroundColor = UIColor.blue
        view.addSubview(blueView)
        
        redLayer.backgroundColor = UIColor.red.cgColor
        redLayer.borderColor = UIColor.black.cgColor
        redLayer.borderWidth = 1.0
        view.layer.addSublayer(redLayer)
        
        blueLayer.backgroundColor = UIColor.blue.cgColor
        blueLayer.borderColor = UIColor.black.cgColor
        blueLayer.borderWidth = 1.0
        view.layer.addSublayer(blueLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        redView.frameLayout.apply{ layout in
            layout.leftMargin = 20.0
            layout.rightMargin = 20.0
            layout.top = self.topLayoutGuide.length + 20.0
            layout.height = 50.0
        }
        blueView.frameLayout.apply{ layout in
            layout.centerHorizontally()
            layout.width = 200.0
            layout.top = redView.frameLayout.bottom + 20.0
            layout.height = 50.0
        }
        redLayer.frameLayout.apply{ layout in
            layout.left = 20.0
            layout.right = self.frameLayout.width - 20.0
            layout.top = blueView.frameLayout.bottom + 50.0
            layout.height = 50.0
        }
        blueLayer.frameLayout.apply{ layout in
            layout.centerHorizontally()
            layout.width = 200.0
            layout.top = redLayer.frameLayout.bottom + 20.0
            layout.height = 50.0
        }
    }

}

