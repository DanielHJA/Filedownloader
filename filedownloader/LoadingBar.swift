//
//  LoadingBar.swift
//  filedownloader
//
//  Created by Daniel Hjärtström on 2018-07-18.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

class LoadingBar: UIView {
    
    private var progress50: Bool = false
    private var progress90: Bool = false
    
    private lazy var loadingLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.minX, y: frame.minY))
        path.addLine(to: CGPoint(x: frame.maxX, y: frame.minY))
        let temp = CAShapeLayer()
        temp.frame = bounds
        temp.path = path.cgPath
        temp.lineWidth = 3.0
        temp.lineCap = kCALineCapRound
        temp.fillColor = UIColor.clear.cgColor
        temp.strokeColor = UIColor.red.cgColor
        temp.strokeEnd = 0.0
        return temp
    }()
    
    var finished: Bool = false {
        didSet {
            loadingLayer.strokeEnd = progress
            animateBarToColor(UIColor.green)
        }
    }

    var progress: CGFloat = 0.0 {
        didSet {
            loadingLayer.strokeEnd = progress
            downloadProgress()
        }
    }
    
    func downloadProgress() {
        if progress > 0.50 && !progress50 {
            progress50 = true
            animateBarToColor(UIColor.orange)
        } else if progress > 0.90 && !progress90 {
            progress90 = true
            animateBarToColor(UIColor.green)
        }
    }
    
    private func animateBarToColor(_ color: UIColor) {
        self.loadingLayer.removeAllAnimations()

        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            self?.loadingLayer.strokeColor = color.cgColor
            self?.loadingLayer.removeAllAnimations()
        }
        
        let animation = CABasicAnimation(keyPath: "strokeColor")
        animation.fromValue = loadingLayer.strokeColor
        animation.toValue = color.cgColor
        animation.duration = 0.5
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        loadingLayer.add(animation, forKey: "strokeColor")
    
        CATransaction.commit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func commonInit() {
        layer.addSublayer(loadingLayer)
    }
    
}
