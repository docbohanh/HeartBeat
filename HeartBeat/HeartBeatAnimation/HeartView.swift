//
//  HeartView.swift
//  HeartBeatAnimation
//
//  Created by Thành Lã on 2/27/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit

class HeartView: UIView {
    
    fileprivate enum Size: CGFloat {
        case label = 24, padding5 = 5
    }
    
    var filled: Bool = true
    var strokeWidth: CGFloat = 2 / UIScreen.main.scale
    
    var strokeColor: UIColor? = .red
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        
        backgroundColor = UIColor.clear
        layer.masksToBounds = false
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowColor = UIColor.black.cgColor
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let bezierPath = UIBezierPath(heartIn: self.bounds)
        
        if self.strokeColor != nil {
            self.strokeColor!.setStroke()
        } else {
            self.tintColor.setStroke()
        }
        
        bezierPath.lineWidth = self.strokeWidth
        bezierPath.stroke()
        
        if self.filled {
            UIColor.red.setFill()
            bezierPath.fill()
        }
    }
    
}


extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        self.init()
        
        //Calculate Radius of Arcs using Pythagoras
        let sideOne = rect.width * 0.4
        let sideTwo = rect.height * 0.3
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2
        
        //Left Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.3, y: rect.height * 0.35),
                    radius: arcRadius,
                    startAngle: 135.degreesToRadians,
                    endAngle: 315.degreesToRadians,
                    clockwise: true)
        
        //Top Centre Dip
        self.addLine(to: CGPoint(x: rect.width/2, y: rect.height * 0.2))
        
        //Right Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.7, y: rect.height * 0.35),
                    radius: arcRadius,
                    startAngle: 225.degreesToRadians,
                    endAngle: 45.degreesToRadians,
                    clockwise: true)
        
        //Right Bottom Line
        self.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.95))
        
        //Left Bottom Line
        self.close()
    }
}

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}

