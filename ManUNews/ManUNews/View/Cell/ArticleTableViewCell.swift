//
//  ArticleTableViewCell.swift
//  ManuNews
//
//  Created by MILIKET on 2/23/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import PHExtensions

class ArticleTableViewCell: UITableViewCell {
    
    static let articleIdentifier = "ArticleCell"
    
    enum Size: CGFloat {
        case Padding15 = 15, Padding10 = 10, Label = 20, Image = 60, icon = 22, padding7 = 7
    }
    
    var seperator: UIView!
    var labelTime: UILabel!
    var markReadIcon: UIImageView!
    var countView: CountView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    override func layoutSubviews() {
        
        contentView.frame = bounds
        seperator.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 2 * onePixel())
        markReadIcon.frame = CGRect(x: bounds.width - Size.icon.., y: seperator.frame.maxY, width: Size.icon.., height: Size.icon..)
        
        imageView?.frame = CGRect(x: Size.Padding10..,
                                  y: Size.Padding10..,
                                  width: bounds.height + Size.Padding10.. * 2,
                                  height: bounds.height - Size.Padding10.. * 2)
        
        countView.frame = CGRect(x: bounds.width - Size.Label.. - Size.Padding10.. / 2,
                                 y: bounds.height - Size.Label.. - Size.padding7.. / 2,
                                 width: Size.Label..,
                                 height: Size.Label..)
        
        guard let imageView = imageView else { return }
        
        
        textLabel?.frame = CGRect(x: imageView.frame.maxX + Size.Padding10..,
                                  y: Size.Padding10.. / 4,
                                  width: contentView.frame.width - Size.Padding15.. - (imageView.frame.maxX + Size.Padding10..),
                                  height: contentView.frame.height / 2 )
        
        labelTime.frame =  CGRect(x: imageView.frame.maxX + Size.Padding10..,
                                  y: bounds.height  - Size.Label.. - Size.Padding10.. / 2,
                                  width: contentView.frame.width - Size.Padding10.. - (imageView.frame.maxX + Size.Padding10..) - Size.Label..,
                                  height: Size.Label..)
        
        detailTextLabel?.frame = CGRect(x: imageView.frame.maxX + Size.Padding10..,
                                        y: bounds.height / 2,
                                        width: bounds.width - (imageView.frame.maxX + Size.Padding10..),
                                        height: 2 * FontSize.small-- + Size.padding7..)
        
        
        
        
        
    }
    
}

extension ArticleTableViewCell {
    
    func setup() {
        setupImageView()
        setupTitle()
        
        labelTime = setupLabel()
        seperator = setupView()
        markReadIcon = setupIconView()
        countView = setupCountView()
        
        contentView.addSubview(countView)
        contentView.addSubview(markReadIcon)
        contentView.addSubview(labelTime)
        contentView.addSubview(seperator)
    }
    
    func setupView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.General.separator
        return view
    }
    
    func setupCountView() -> CountView {
        let view = CountView()
        return view
    }
    
    func setupImageView() {
        
        imageView?.contentMode = .scaleAspectFill
        imageView?.backgroundColor = UIColor.clear
        imageView?.clipsToBounds = true
        
    }
    
    func setupIconView() -> UIImageView {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.backgroundColor = UIColor.clear
        icon.clipsToBounds = true
        return icon
    }
    
    func setupTitle() {
        
        textLabel?.textAlignment = .left
        textLabel?.font = UIFont(name: FontType.latoSemibold.., size: FontSize.normal..)
        textLabel?.numberOfLines = 2
        textLabel?.textColor = UIColor.darkGray
        textLabel?.backgroundColor = UIColor.clear
        
        textLabel?.layer.shadowRadius = 0.3
        textLabel?.layer.shadowOpacity = 0.2
        textLabel?.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        textLabel?.layer.shadowColor = UIColor.black.cgColor
        
        detailTextLabel?.textAlignment = .left
        detailTextLabel?.font = UIFont(name: FontType.latoRegular.., size: FontSize.small--)
        detailTextLabel?.numberOfLines = 2
        detailTextLabel?.textColor = UIColor.gray
        detailTextLabel?.backgroundColor = UIColor.clear
        
        detailTextLabel?.layer.shadowRadius = 0.5
        detailTextLabel?.layer.shadowOpacity = 0.3
        detailTextLabel?.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        detailTextLabel?.layer.shadowColor = UIColor.black.cgColor
    }
    
    func setupLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont(name: FontType.latoRegular.., size: FontSize.small-- - 2)
        label.numberOfLines = 1
        label.textColor = UIColor.gray
        label.backgroundColor = UIColor.clear
        
        label.layer.masksToBounds = false
        label.layer.shadowRadius = 1.0
        label.layer.shadowOpacity = 0.3
        label.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        label.layer.shadowColor = UIColor.black.cgColor
        
        return label
    }
}
