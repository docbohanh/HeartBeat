//
//  Image.swift
//  Dang
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 IOS. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func tint(_ color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        color.set()
        UIRectFill(rect)
        draw(in: rect, blendMode: CGBlendMode.destinationIn, alpha: CGFloat(1.0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}

struct Icon {
    
    struct General {
        static let circle = UIImage(named: "Circle")!
        static let button = UIImage(named: "Button")!
    }
    
    
}
