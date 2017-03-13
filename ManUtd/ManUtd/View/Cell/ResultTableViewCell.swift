//
//  ResultTableViewCell.swift
//  ManUNews
//
//  Created by Thành Lã on 2/28/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import PHExtensions

class ResultTableViewCell: SeparatorTableViewCell {
    
    static let resultIdentifier = "ResultTableViewCell"
    
    enum Size: CGFloat {
        case padding15 = 15, padding10 = 10, label = 20, logo = 22, icon = 12, padding7 = 7, padding5 = 5, cell = 30
    }
    
    var orderIcon: UIImageView!
    var order: UILabel!
    var logo: UIImageView!
    var teamName: UILabel!
    var matched: UILabel!
    var goals: UILabel!
    var difference: UILabel!
    var score: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
        
        let w = Utility.shared.widthForView(
            text: "0",
            font:  UIFont(name: FontType.latoRegular.., size: FontSize.small++)!,
            height: bounds.height)
        
        orderIcon.frame = CGRect(
            x: Size.padding7..,
            y: (bounds.height - Size.icon..) / 2,
            width: Size.icon..,
            height: Size.icon..)
        
        order.frame = CGRect(
            x: orderIcon.frame.maxX + Size.padding5..,
            y: 0,
            width: 2 * w,
            height: bounds.height)
        
        logo.frame = CGRect(
            x: order.frame.maxX + Size.padding5..,
            y: (bounds.height - Size.logo..) / 2,
            width: Size.logo..,
            height: Size.logo..)
        
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
        
        teamName.frame = CGRect(
            x: logo.frame.maxX + Size.padding5..,
            y: 0,
            width: matched.frame.minX - logo.frame.maxX - Size.padding5.. * 2,
            height: bounds.height)
        
    }
    
}

extension ResultTableViewCell {
    
    func setup() {
        
        orderIcon = setupImageView()
        order = setupLabel(alignment: .center, textColor: .darkGray)
        logo = setupImageView()
        teamName = setupLabel(alignment: .left, textColor: .darkGray)
        matched = setupLabel(alignment: .center, textColor: .gray)
        goals = setupLabel(alignment: .center, textColor: .gray)
        difference = setupLabel(alignment: .center, textColor: .gray)
        score = setupLabel(alignment: .center, textColor: .darkGray, fontName: FontType.latoSemibold..)
        
        [orderIcon,order,logo,teamName,matched,goals,difference,score].forEach { contentView.addSubview($0) }
        
    }
    
    func setupImageView() -> UIImageView {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.backgroundColor = UIColor.clear
        icon.clipsToBounds = true
        return icon
    }
    
    func setupLabel(alignment: NSTextAlignment, textColor: UIColor, fontName: String = FontType.latoRegular..) -> UILabel {
        let label = UILabel()
        label.textAlignment = alignment
        label.font = UIFont(name: fontName, size: FontSize.small++)
        label.textColor = textColor
        label.numberOfLines = 1
        label.contentMode = .center
        return label
    }
}
