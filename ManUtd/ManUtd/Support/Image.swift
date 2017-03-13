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
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

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
        static let newsEmpty: UIImage = UIImage(named: "News")!
        
        static let orderNormal = UIImage(named: "order_normal")!
        static let orderAscend = UIImage(named: "order_plus")!
        static let orderDescend = UIImage(named: "order_less")!
        
        static let liked = UIImage(named: "Liked")!
        
    }
    
    struct General {
        static let arrowRight = UIImage(named: "Tracking_ArrowRight")!
    }
    
    struct Home {
        static var ArrowRight = UIImage(named: "ArrowRight")!        
        static var ArrowLeft = UIImage(named: "ArrowLeft")!
    }
    
    struct Logo {
        static var chelsea = UIImage(named: "Chelsea")!
        static var arsenal = UIImage(named: "Arsenal")!
        static var liverpool = UIImage(named: "Liverpool")!
        static var manCity = UIImage(named: "ManCity")!
        static var tottenham = UIImage(named: "Tottenham")!
        static var manu = UIImage(named: "ManU")!
        static var everton = UIImage(named: "Everton")!
    }

    // Icon cho Đăng ký
    struct Register {
        static var SelectedCheckbox: UIImage { return UIImage(named: "CheckBox")! }
        
        static var DeselectedCheckbox: UIImage { return UIImage(named: "UncheckBox")! }
        
        static var Email: UIImage { return UIImage(named: "Email")!}
        
        static var Personal: UIImage { return UIImage(named: "Person")!}
        
        static var Phone: UIImage { return UIImage(named: "Phone")!}
        
        static var Key: UIImage { return UIImage(named: "Key")!}
        
    }
    
    // Icon cho thông tin cá nhân
    struct Personal {
        static var AvatarDefault: UIImage { return UIImage(named: "AvatarDefault")!}
    }
}
