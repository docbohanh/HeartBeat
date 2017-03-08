//
//  TextFieldTableViewCell.swift
//  ManUNews
//
//  Created by MILIKET on 3/9/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import PHExtensions

class TextFieldTableViewCell: SeparatorTableViewCell {
    
    fileprivate enum Size: CGFloat {
        case padding15 = 15
    }
    
    var textField: UITextField = {
        var textField = UITextField()
        textField.font = UIFont(name: FontType.latoRegular.., size: FontSize.normal++)
        textField.textColor = UIColor.black
        textField.backgroundColor = UIColor.clear
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        //        textField.enabled = false
        return textField
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        backgroundColor = UIColor.clear
        textLabel?.font = UIFont(name: FontType.latoRegular.., size: FontSize.normal--)
        textLabel?.textColor = UIColor.Table.titleHeader
        addSubview(textField)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = CGRect(x: (self.imageView?.frame)!.maxX + Size.padding15..,
                                 y: 0,
                                 width: self.bounds.width - ((self.imageView?.frame)!.maxX + Size.padding15..) - Size.padding15..,
                                 height: self.bounds.height)
        
        seperatorStyle = .padding(15)
        seperatorRightPadding = 15
    }
}

