//
//  TimeSelectionFooterView.swift
//  ManuNews
//
//  Created by Thành Lã on 2/24/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import PHExtensions

class TimeSelectionFooterView: UIView {
    
    fileprivate enum Size: CGFloat {
        case padding15 = 15, padding10 = 10, padding5 = 5, button = 44
    }
    
    var buttonRight: UIButton!
    var buttonLeft: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        buttonLeft.frame = CGRect(x: Size.padding15..,
                                  y: 0,
                                  width: bounds.width / 2 - Size.padding15.. - Size.padding10.. / 2,
                                  height: Size.button..)
        
        buttonRight.frame = CGRect(x: bounds.width / 2 + Size.padding10.. / 2,
                                   y: 0,
                                   width: bounds.width / 2 - Size.padding15.. - Size.padding10.. / 2,
                                   height: Size.button..)
    }
}

extension TimeSelectionFooterView {
    fileprivate func setup() {
        buttonLeft = setupButton("Bỏ qua", titleColor: UIColor.main, bgColor: UIColor.white, borderColor: UIColor.lightGray)
        buttonRight = setupButton("Xác nhận", titleColor: UIColor.Text.whiteNormal, bgColor: UIColor.main)
        
        addSubview(buttonLeft)
        addSubview(buttonRight)
    }
    
    fileprivate func setupButton(_ title: String, titleColor: UIColor, bgColor: UIColor, borderColor: UIColor? = nil) -> UIButton {
        let button = UIButton()
        button.setTitle(title.uppercased(), for: UIControlState())
        button.titleLabel?.font = UIFont(name: FontType.latoBold.., size: FontSize.normal--)
        button.setTitleColor(titleColor, for: UIControlState())
        button.backgroundColor = bgColor
        
        guard let borderColor = borderColor else { return button }
        button.layer.borderColor = borderColor.cgColor
        button.layer.borderWidth = onePixel()
        return button
    }
    
    func viewHeight() -> CGFloat {
        return Size.button.. + Size.padding10..
    }
}
