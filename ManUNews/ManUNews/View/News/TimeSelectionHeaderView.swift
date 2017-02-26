//
//  TimeSelectionHeaderView.swift
//  ManuNews
//
//  Created by Thành Lã on 2/24/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import PHExtensions

class TimeSelectionHeaderView: UIView {
    
    fileprivate enum Size: CGFloat {
        case padding15 = 15, padding10 = 10, padding5 = 5, segment = 35, button = 38
    }
    
    var buttonFromTime: ButtonUnderline!
    var buttonToTime: ButtonUnderline!
    var buttonArrow: UIButton!
    
    fileprivate var seperator: UIView!
    
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
        
        
        buttonFromTime.frame = CGRect(x: Size.padding5..,
                                      y: Size.padding5..,
                                      width: bounds.width / 2 - Size.padding10.. * 2 - Size.padding5..,
                                      height: Size.button..)
        buttonFromTime.layoutSubviews()
        
        buttonToTime.frame = CGRect(x: bounds.width / 2 + Size.padding10.. * 2,
                                    y: Size.padding5..,
                                    width: bounds.width / 2 - Size.padding10.. * 2 - Size.padding5..,
                                    height: Size.button..)
        buttonFromTime.layoutSubviews()
        
        
        seperator.frame = CGRect(x: 0, y: bounds.height - onePixel(), width: bounds.width, height: onePixel())
        
        
        buttonArrow.frame = CGRect(x: bounds.width / 2 - Size.button.. / 2,
                                   y: Size.padding5..,
                                   width: Size.button..,
                                   height: Size.button..)
        
    }
}

extension TimeSelectionHeaderView {
    fileprivate func setup() {
        
        buttonFromTime = setupButtonTime()
        buttonFromTime.isSelected = true
        
        buttonToTime = setupButtonTime(UIColor.white)
        buttonToTime.seperator.isHidden = true
        
        
        seperator = setupSeperator()
        buttonArrow = setupButtonArrow()
        
        addSubview(buttonArrow)
        addSubview(buttonFromTime)
        addSubview(buttonToTime)
        
        backgroundColor = UIColor.Table.tableGroup.alpha(0.5)
    }
    
    fileprivate func setupButtonTime(_ bgColor: UIColor = UIColor.Navigation.main) -> ButtonUnderline {
        let button = ButtonUnderline(frame: CGRect.zero)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont(name: FontType.latoBold.., size: FontSize.normal--)
        button.backgroundColor = bgColor
        
        button.setTitleColor(UIColor.Navigation.main, for: UIControlState())
        button.setTitleColor(UIColor.white, for: .selected)
        
        
        button.setTitleColor(UIColor.Text.grayMedium, for: UIControlState())
        button.setTitleColor(UIColor.Navigation.main, for: .selected)
        button.backgroundColor = UIColor.clear
        
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        return button
    }
    
    fileprivate func setupButtonArrow(_ image: UIImage = Icon.General.arrowRight) -> UIButton {
        let button = UIButton()
        button.setImage(image.tint(UIColor.main), for: UIControlState())
        
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }
    
    fileprivate func setupSeperator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.Misc.seperator
        return view
    }
    
    func viewHeight() -> CGFloat {
        return Size.button.. + 5 * 2
    }
}


class ButtonUnderline: UIButton {
    
    var seperator: UIView!
    
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
        
        let width = Utility.shared.widthForView(text: "00:00 - 00/00/0000",
                                                font: UIFont(name: FontType.latoBold.., size: FontSize.normal--)!,
                                                height: 20)
        
        seperator.frame = CGRect(x: (bounds.width - width ) / 2,
                                 y: bounds.height - onePixel() - 9,
                                 width: width,
                                 height: onePixel())
    }
    
    fileprivate func setup() {
        seperator = setupSeperator()
        addSubview(seperator)
    }
    
    fileprivate func setupSeperator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.Navigation.main
        return view
    }
}
