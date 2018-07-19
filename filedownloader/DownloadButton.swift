//
//  DownloadButton.swift
//  filedownloader
//
//  Created by Daniel Hjärtström on 2018-07-18.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

class DownloadButton: UIButton {
    
    var downloadState: DownloadState = .pending {
        didSet {
            switchButtonState()
        }
    }
    
    private lazy var shapeLayer: CAShapeLayer = {
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.midX, y: frame.midY), radius: frame.width / 2, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let temp = CAShapeLayer()
        temp.frame = bounds
        temp.path = path.cgPath
        temp.isHidden = true
        temp.fillColor = UIColor.clear.cgColor
        temp.strokeColor = UIColor.blue.cgColor
        temp.strokeEnd = 0.7
        temp.lineCap = kCALineCapRound
        temp.lineWidth = 4.0
        return temp
    }()
    
    private lazy var squareLayer: CAShapeLayer = {
        let path = UIBezierPath(rect: CGRect(x: frame.midX - frame.width / 6, y: frame.midY - frame.height / 6, width: frame.width / 3, height: frame.height / 3))
        let temp = CAShapeLayer()
        temp.frame = bounds
        temp.isHidden = true
        temp.path = path.cgPath
        temp.fillColor = UIColor.blue.cgColor
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    convenience init(width: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: width))
        commonInit()
    }
    
    private func commonInit() {
        layer.addSublayer(shapeLayer)
        layer.addSublayer(squareLayer)
    }
    
    private func switchButtonState() {
        switch downloadState {
        case .pending:
            isUserInteractionEnabled = false
            shapeLayer.isHidden = false
            startAnimation()
        case .downloading:
            isUserInteractionEnabled = true
            squareLayer.isHidden = false
        case .completed:
            stopAnimation()
        case .error:
            break
        case .cancelled:
            shapeLayer.isHidden = true
            squareLayer.isHidden = true
        }
    }
    
    private func startAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.duration = 5.0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.repeatCount = .infinity
        shapeLayer.add(rotationAnimation, forKey: "rotationKey")
    }
    
    private func stopAnimation() {
        shapeLayer.removeAllAnimations()
    }
    
    deinit {
        print("Downloadbutton wwas de-initialized")
    }
    
}
