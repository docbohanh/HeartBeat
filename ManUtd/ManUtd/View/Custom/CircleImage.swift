//
//  CircleImage.swift
//  ManUNews
//
//  Created by MILIKET on 3/9/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation
import UIKit

class CircleImage: UIView {
    var image: UIImage? {
        didSet {
            if let image = image {
                self.frame = CGRect(x: 0, y: 0, width: image.size.width/image.scale, height: image.size.width/image.scale)
            }
        }
    }
    var cornerRadius: CGFloat?
    
    private class func frameForImage(image: UIImage) -> CGRect {
        return CGRect(x: 0, y: 0, width: image.size.width/image.scale, height: image.size.width/image.scale)
    }
    
    override func draw(_ rect: CGRect) {
        if let image = self.image {
            image.draw(in: rect)
            
            let cornerRadius = self.cornerRadius ?? rect.size.width / 2
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            UIColor.main.setStroke()
            path.lineWidth = cornerRadius
            path.stroke()
        }
    }
}
