//
//  Color.swift
//  BAMapTools
//
//  Created by Thành Lã on 7/7/16.
//  Copyright © 2016 Binh Anh. All rights reserved.
//

import UIKit

extension UIColor {
    
    func alpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
    
    convenience init(_ r: Int, _ g: Int, _ b: Int, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat(Double(r)/255.0),
            green: CGFloat(Double(g)/255),
            blue: CGFloat(Double(b)/255),
            alpha: alpha)
    }
    
    convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        let formattedCode = rgba.replacingOccurrences(of: "#", with: "")
        let formattedCodeLength = formattedCode.characters.count
        if formattedCodeLength != 3 && formattedCodeLength != 4 && formattedCodeLength != 6 && formattedCodeLength != 8 {
            fatalError("invalid color")
        }
        
        var hexValue: UInt32 = 0
        if Scanner(string: formattedCode).scanHexInt32(&hexValue) {
            switch formattedCodeLength {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    static var main: UIColor { return UIColor(rgba: "297FC8")  }//Màu xanh duong
    static var greenery: UIColor { return UIColor(rgba: "88B04B")  } //Màu xanh greenery
    
    struct Navi {
        
        static var background   = UIColor(rgba: "0087df")
        static var tint         = UIColor.white
        static var main         = UIColor(rgba: "0087df")
        static var sub          = UIColor(rgba: "FF783C")     // Màu đỏ FF783C
        static var highLightText    = UIColor(rgba: "7bbbec")
        
    }
    
    /**
     Màu nền cho các Table
     */
    struct Table {
        
        static var titleHeader = UIColor(rgba: "647d91")
        static var tableEmpty = UIColor(rgba: "f5f7fa")
        static var tablePlain = UIColor(rgba: "eeeeee")
        static var tableGroup = UIColor(rgba: "#EFEFEF")
        
    }
    
    /**
     Màu nền cho các Text
     */
    struct Text {
        
        static var blackNormal = UIColor.black
        
        static var whiteNormal = UIColor.white
        
        static var grayNormal = UIColor(rgba: "6E6E6E")
        
        static var blackMedium = UIColor.black.alpha(0.8)
        
        static var grayMedium = UIColor.gray.alpha(0.8)
        
        static var disableText = UIColor.gray.alpha(0.8)
        
        static var deselected =  UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0)
        
        
    }
    
    struct Navigation {
        
        static var background = UIColor(rgba: "363a5b")
        
        static var tint = UIColor.white
        
        
        /**
         Màu chính trong app
         */
        static var main = UIColor(rgba: "297FC8")   
        
        static var sub = UIColor(rgba: "88B04B")
        
        static var highLightText = UIColor(rgba: "afd6f3")
        
    }
    
    struct SideBar {
        static var text = UIColor.white
        
        //        static var selectedText = UIColor(rgba: "FF854F")
        static var selectedText = UIColor.white
        
        static var selectedBackground = UIColor.white.withAlphaComponent(0.2)
        
        //        static var headerBackground = UIColor(rgba: "2d4473")
        
        static var headerBackground = UIColor(rgba: "1B2430")
        
        static var cellBackground = UIColor(rgba: "1B2430")
        
        //        static var cellBackground = UIColor(rgba: "EEEEEE")
        
        
    }
    
    struct Segment {
        //        static var selectedText = UIColor(rgba: "107FC9")
        
        static var selectedText = UIColor(rgba: "3B5998")
        
        static var deselectedText = UIColor.white
        
        static var selectedBackground = UIColor.clear
        
        static var deselectedBackground = UIColor.clear
        
        static var devider = UIColor.clear
        
        static var background = UIColor.clear
        
        static var indicator = UIColor.white
    }
    
    struct Misc {
        static var seperator = UIColor(rgba: "DDD")
        
        //        static var seperatorUpBooking = UIColor(rgba: "00BFF3")
        static var seperatorUpBooking = UIColor(rgba: "1F4999")
        
        //        static var seperatorDownBooking = UIColor(rgba: "0090D6")
        static var seperatorDownBooking = UIColor(rgba: "4465AD")
        
        //        static var seperatorUpSidebar = UIColor(rgba: "00A8E7")
        static var seperatorUpSidebar = UIColor(rgba: "223357")
        
        static var seperatorDownSidebar = UIColor(rgba: "3b4c70")
        
        static var borderBooking = UIColor(rgba: "C5C5C5")
    }
    
    struct Background {
        static var headerView = UIColor.white.withAlphaComponent(0.9)
        
        static var footerView = UIColor.white
        
        static var button = UIColor(red: 136/255.0, green: 196/255.0, blue: 37/255.0, alpha: 1.0)
        
        //        static var footerViewDetailsBooking = UIColor(rgba: "00AEEF")
        static var footerViewDetailsBooking = UIColor(rgba: "3B5998")
        
        static var footerViewButtonBooking = UIColor(rgba: "F59324")
        //        static var footerViewButtonBooking = UIColor(rgba: "F3802C")
        
        
        static var textView = UIColor(rgba: "f8f8f8")
        
        static var textViewSeperator = UIColor(rgba: "ebebeb")
        
        // Màu nền cho quick help
        static var quickHelp = UIColor.black.withAlphaComponent(0.65)
        
        // Màu nền cho Empty table view
        static var emptyTable = UIColor(rgba: "f5f7fa")
        
        static var notification = UIColor(rgba: "333333")
    }
    
    
    
    
    /**
     Màu nền cho các Button
     */
    struct Button {
        
        static var whiteBackground = UIColor.white
        
        static var normalBackground = UIColor(red: 220/255.0, green: 225/255.0, blue: 231/255.0, alpha: 1.0)
        
        static var highlightBackground = UIColor(rgba: "2196F3")
        
        
        
        
        // Màu đỏ (nút hủy cuốc)
        //        static var cancelBackground = UIColor(rgba: "EE3233")
        static var cancelBackground = UIColor(rgba: "FF5252")
        
        // Màu Đỏ (Cho các button bên trái)
        static var leftBackground = UIColor(rgba: "ED5921")
        //        static var leftBackground = UIColor(rgba: "009A3D")
        
        
        // Màu Xanh (Cho các button bên phải và trong trường hợp footer chỉ có 1 nút)
        static var rightBackground = UIColor(rgba: "297FC8")
        //        static var rightBackground = UIColor(rgba: "F3802C")
        
        
        
        // Màu xám khi button bị disable
        static var disableBackground = UIColor.lightGray
        
        //        static var disableBackground = UIColor(rgba: "F78181")
        
        // Màu xanh nút đã gặp xe
        static var greenBackground = UIColor(rgba: "4CAF50")
        
    }
    
    
    struct Shadow {
        static var active = UIColor(rgba: "00AEEF")
        
        static var normal = UIColor(rgba: "C5C5C5")
    }
    
    struct Popup {
        static var highlightText = UIColor(rgba: "F59425")
        
        static var normalText = UIColor.white
    }
    
    struct General {
        static var separator = UIColor(rgba: "c8c7cc")
    }
    
}

