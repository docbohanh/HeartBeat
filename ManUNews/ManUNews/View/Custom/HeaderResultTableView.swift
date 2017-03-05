//
//  HeaderResultTableView.swift
//  ManUNews
//
//  Created by Thành Lã on 2/28/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import PHExtensions

class HeaderResultTableView: UIView {
    
    enum Size: CGFloat {
        case padding7 = 7, padding10 = 10, padding15 = 15
    }
    
    var matched: UILabel!
    var goals: UILabel!
    var difference: UILabel!
    var score: UILabel!
    
    var seperator: UIView! = {
        var view = UIView()
        view.backgroundColor = UIColor.Misc.seperator
        return view
    }()
    
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
        
        let w = Utility.shared.widthForView(
            text: "0",
            font:  UIFont(name: FontType.latoRegular.., size: FontSize.small++)!,
            height: bounds.height)
        
        score.frame = CGRect(
            x: bounds.width - Size.padding7.. - 3 * w,
            y: 0,
            width: 3 * w,
            height: bounds.height)
        
        difference.frame = CGRect(
            x: score.frame.minX - Size.padding10.. - 3 * w,
            y: 0,
            width: 3 * w,
            height: bounds.height)
        
        goals.frame = CGRect(
            x: difference.frame.minX - Size.padding10.. - 5 * w,
            y: 0,
            width: 5 * w,
            height: bounds.height)
        
        matched.frame = CGRect(
            x: goals.frame.minX - Size.padding10.. - 2 * w,
            y: 0,
            width: 2 * w,
            height: bounds.height)
        
        seperator.frame = CGRect(
            x: 0,
            y: bounds.height - onePixel(),
            width: bounds.width,
            height: onePixel())
    }
    
    func setup() {
        matched = setupLabel(text: "P")
        goals = setupLabel(text: "Goals")
        difference = setupLabel(text: "GD")
        score = setupLabel(text: "Pts.")
        [matched,goals,difference,score,seperator].forEach { addSubview($0) }
    }
    
    
    func setupLabel(text: String) -> UILabel {
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.font = UIFont(name: FontType.latoSemibold.., size: FontSize.normal--)
        textLabel.textColor = UIColor.Table.titleHeader
        textLabel.numberOfLines = 1
        textLabel.text = text
        return textLabel
    }
    
    
}
