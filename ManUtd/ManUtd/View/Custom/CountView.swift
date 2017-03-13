//
//  CountView.swift
//  ManuNews
//
//  Created by MILIKET on 2/23/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import PHExtensions

class CountView: UIView {
    
    fileprivate enum Size: CGFloat {
        case label = 24, padding5 = 5
    }
    
    var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontType.latoSemibold.., size: FontSize.small--)
        label.textAlignment = .center
        label.contentMode = .center
        label.textColor = UIColor.main
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        return label
    }()
    
    
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
        
        addSubview(countLabel)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        countLabel.frame = CGRect(x: Size.padding5.. / 2,
                                  y: (bounds.height - Size.label.. - 5) / 2,
                                  width: bounds.width - Size.padding5..,
                                  height: Size.label..)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var frame = rect
        frame.origin.x += 1
        frame.origin.y += 1
        frame.size.width -= 2
        frame.size.height -= 5
        
        let windows = UIBezierPath(roundedRect: frame, cornerRadius:  2 )
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: frame.midX - 4, y: frame.height + 1))
        arrowPath.addLine(to: CGPoint(x: rect.midX - 5, y: rect.maxY))
        arrowPath.addLine(to: CGPoint(x: frame.midX + 2, y: frame.height + 1))
        
        windows.append(arrowPath)
        
        UIColor.main.setStroke()
        windows.lineWidth = 2 * onePixel()
        windows.stroke()
        
        UIColor.white.setFill()
        windows.fill()
    }
    
}
