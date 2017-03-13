//
//  SegmentedHeaderView.swift
//  ManuNews
//
//  Created by Thành Lã on 2/24/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import PHExtensions

class SegmentedHeaderView: UIView {
    
    fileprivate enum Size: CGFloat {
        case padding15 = 15, padding10 = 10, padding5 = 5, segment = 35, label = 30
    }
    
    var segment: FUISegmentedControl!
    
    fileprivate var contentView: UIView!
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
        
        contentView.frame = CGRect(x: 0,
                                   y: 0,
                                   width: bounds.width ,
                                   height: Size.segment.. + Size.padding10..)
        
        
        segment.frame = CGRect(x: Size.padding10.. / 2,
                               y: contentView.frame.height - Size.segment.. - Size.padding10.. / 2,
                               width: contentView.frame.width - Size.padding10.. ,
                               height: Size.segment..)
        
        seperator.frame = CGRect(x: 0,
                                 y: bounds.height - onePixel(),
                                 width: bounds.width,
                                 height: onePixel())
    }
}

extension SegmentedHeaderView {
    
    func setup() {
        segment = setupSegmentView()
        
        seperator = setupView(UIColor.lightGray.alpha(0.9))
        contentView = setupView(UIColor.main)
        
        
        addSubview(seperator)
        addSubview(contentView)
        contentView.addSubview(segment)
        
        
        backgroundColor = UIColor.main
        layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
    }
    
    func setupView(_ bgColor: UIColor = UIColor.clear) -> UIView {
        let view = UIView()
        view.backgroundColor = bgColor
        return view
    }
    
    func setupLabel(_ alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: FontType.latoSemibold.., size: FontSize.normal--)
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }
    
    func setupSegmentView() -> FUISegmentedControl {
        
        
        let segment = FUISegmentedControl()
        
        //        segment.selectedSegmentIndex = 0
        
        segment.selectedFont = UIFont(name: FontType.latoBold.., size: FontSize.small++)
        segment.selectedColor = UIColor.Text.whiteNormal
        segment.selectedFontColor = UIColor.main
        
        segment.disabledFont = UIFont(name: FontType.latoBold.., size: FontSize.small++)
        segment.disabledColor = UIColor.Text.whiteNormal
        segment.disabledFontColor = UIColor.main
        
        segment.deselectedFont = UIFont(name: FontType.latoBold.., size: FontSize.small++)
        segment.deselectedColor = UIColor.main
        segment.deselectedFontColor = UIColor.Text.whiteNormal
        
        segment.borderWidth = onePixel()
        segment.borderColor = UIColor.white
        
        segment.highLightColor = UIColor.white.alpha(0.5)
        
        segment.backgroundColor = UIColor.main
        segment.dividerColor = UIColor.white
        segment.cornerRadius = 0
        
        
        return segment
    }
    
    
    func viewHeight() -> CGFloat {
        return Size.segment.. + Size.padding10..
    }
}
