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
        case Padding15 = 15, Padding10 = 10, Label = 20, Image = 60, icon = 22, padding7 = 7, Padding5 = 5, button = 64
    }
    
    var labelTime: UILabel!
    var liked: UIButton!
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
        
        contentView.frame = CGRect(x: Size.Padding10..,
                                   y: Size.Padding5..,
                                   width: bounds.width - Size.Padding10.. * 2,
                                   height: bounds.height - Size.Padding5.. * 2)
        
        liked.frame = CGRect(x: bounds.width - Size.button.. - Size.Padding10..,
                             y: 0,
                             width: Size.button..,
                             height: contentView.frame.height)
        
        imageView?.frame = CGRect(x: Size.Padding5..,
                                  y: Size.Padding10..,
                                  width: contentView.frame.height - Size.Padding10.. * 2,
                                  height: contentView.frame.height - Size.Padding10.. * 2)
        
        imageView?.layer.cornerRadius = contentView.frame.height / 2 - Size.Padding10..
        
        countView.frame = CGRect(x: contentView.frame.width - Size.Label.. - Size.Padding10.. / 2,
                                 y: contentView.frame.height - Size.Label.. - Size.Padding5.. / 2,
                                 width: Size.Label..,
                                 height: Size.Label..)
        
        guard let imageView = imageView else { return }
        
        
        textLabel?.frame = CGRect(x: imageView.frame.maxX + Size.Padding10..,
                                  y: Size.Padding10.. / 4,
                                  width: contentView.frame.width - Size.Padding15.. - (imageView.frame.maxX + Size.Padding10..),
                                  height: contentView.frame.height / 2 )
        
        labelTime.frame =  CGRect(x: imageView.frame.maxX + Size.Padding10..,
                                  y: contentView.frame.height  - Size.Label.. - Size.Padding10.. / 2,
                                  width: contentView.frame.width - Size.Padding10.. - (imageView.frame.maxX + Size.Padding10..) - Size.Label..,
                                  height: Size.Label..)
        
        detailTextLabel?.frame = CGRect(x: imageView.frame.maxX + Size.Padding10..,
                                        y: contentView.frame.height / 2,
                                        width: contentView.frame.width - (imageView.frame.maxX + Size.Padding10..),
                                        height: 2 * FontSize.small-- + Size.padding7..)
        
        
        
        
        
    }
    
}

extension ArticleTableViewCell {
    
    func setup() {
        setupImageView()
        setupTitle()
        
        labelTime = setupLabel()
        liked = setupButton()
        countView = setupCountView()
        
        contentView.addSubview(countView)
        contentView.addSubview(liked)
        contentView.addSubview(labelTime)
        
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 4
        
        contentView.layer.masksToBounds = false
        contentView.layer.shadowRadius = 2.0
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: 2, height: -2)
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        
        //        contentView.layer.borderColor = UIColor.lightGray.cgColor
        //        contentView.layer.borderWidth = onePixel()
    }
    
    func setupButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setImage(Icon.Article.liked.tint(.main), for: .selected)
        button.setImage(Icon.Article.liked.tint(.lightGray), for: .normal)
        
        button.clipsToBounds = false
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 80, right: 0)
        
        return button
    }
    
    func setupCountView() -> CountView {
        let view = CountView()
        return view
    }
    
    func setupImageView() {
        
        imageView?.contentMode = .scaleAspectFill
        imageView?.backgroundColor = UIColor.clear
        imageView?.clipsToBounds = true
        
        imageView?.layer.borderColor = UIColor.lightGray.cgColor
        imageView?.layer.borderWidth = onePixel()
        
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
