//
//  Image.swift
//  Dang
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 IOS. All rights reserved.
//

import UIKit
import PHExtensions

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
    
    struct Navi {
        static var menu     = UIImage(named: "Menu")!
        static var back     = UIImage(named: "Back")!
        static var done     = UIImage(named: "Done")!
        static var trash    = UIImage(named: "Trash")!
        static var delete   = UIImage(named: "Delete")!
        static var add      = UIImage(named: "Add")!
        static var filter   = UIImage(named: "Filter")!
        static var refesh   = UIImage(named: "Refesh")!
        static var arrow    = UIImage(named: "Arrow")!
        static var edit     = UIImage(named: "Edit")!
        static var setting  = UIImage(named: "Setting")!
        static var info     = UIImage(named: "Info")!
    }
    
    /// Icon các Items cho TabBar Chính
    struct TabBar {
        static var history: UIImage { return UIImage(named: "TabBarHistory")! }
        static var article: UIImage { return UIImage(named: "TabBarArticle")! }
        static var noteBook: UIImage { return UIImage(named: "TabBarNoteBook")! }
        static var personal: UIImage { return UIImage(named: "TabBarPersonal")! }
    }
    
    struct Article {
        static let markAsRead: UIImage = UIImage(named: "markAsRead")!
        static let news: UIImage = UIImage(named: "News")!
    }
    
    struct General {
        static let arrowRight = UIImage(named: "Tracking_ArrowRight")!
    }
    
    struct Home {
        static var ArrowRight: UIImage { return UIImage(named: "ArrowRight")! }
        
        static var ArrowLeft: UIImage { return UIImage(named: "ArrowLeft")! }
    }

}
