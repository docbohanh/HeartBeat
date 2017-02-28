//
//  ResultTableViewCell.swift
//  ManUNews
//
//  Created by Thành Lã on 2/28/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import PHExtensions

class ResultTableViewCell: UITableViewCell {
    
    static let resultIdentifier = "ResultTableViewCell"
    
    enum Size: CGFloat {
        case padding15 = 15, padding10 = 10, label = 20, logo = 24, icon = 12, padding7 = 7, padding5 = 5, cell = 30
    }
    
    var seperator: UIView!
    
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
        seperator.frame = CGRect(x: 0, y: bounds.height - onePixel(), width: bounds.width, height: onePixel())
        
        let w = Utility.shared.widthForView(
            text: "0",
            font:  UIFont(name: FontType.latoRegular.., size: FontSize.small++)!,
            height: Size.cell..)
        let h = Utility.shared.heightForView(
            text: "0",
            font: UIFont(name: FontType.latoRegular.., size: FontSize.small++)!,
            width: Size.cell..)
        
        orderIcon.frame = CGRect(
            x: Size.padding5..,
            y: (bounds.height - Size.icon..) / 2,
            width: Size.icon..,
            height: Size.icon..)
        
        order.frame = CGRect(
            x: orderIcon.frame.maxX + Size.padding5..,
            y: (bounds.height - h) / 2,
            width: 2 * w,
            height: h)
        
        logo.frame = CGRect(
            x: order.frame.maxX + Size.padding5..,
            y: (bounds.height - Size.logo..) / 2,
            width: Size.logo..,
            height: Size.logo..)
        
        
        
        
    }
    
}

extension ResultTableViewCell {
    
    func setup() {
        
        seperator = setupView()
        
        orderIcon = setupImageView()
        order = setupLabel(alignment: .center, textColor: .darkGray)
        logo = setupImageView()
        teamName = setupLabel(alignment: .left, textColor: .darkGray)
        matched = setupLabel(alignment: .center, textColor: .gray)
        goals = setupLabel(alignment: .center, textColor: .gray)
        difference = setupLabel(alignment: .center, textColor: .gray)
        score = setupLabel(alignment: .center, textColor: .darkGray)
        
        [orderIcon,order,logo,teamName,matched,goals,difference,score].forEach { contentView.addSubview($0) }
        
        contentView.addSubview(seperator)
    }
    
    func setupView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.General.separator
        return view
    }
    
    func setupImageView() -> UIImageView {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.backgroundColor = UIColor.clear
        icon.clipsToBounds = true
        return icon
    }
    
    
    func setupLabel(alignment: NSTextAlignment, textColor: UIColor) -> UILabel {
        let textLabel = UILabel()
        textLabel.textAlignment = alignment
        textLabel.font = UIFont(name: FontType.latoRegular.., size: FontSize.small++)
        textLabel.textColor = textColor
        textLabel.numberOfLines = 1
        return textLabel
    }
}
