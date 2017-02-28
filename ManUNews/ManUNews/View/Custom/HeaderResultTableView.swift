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
        case padding15 = 15, padding10 = 10, label = 16, Image = 20, button = 36
    }
    
    var orderIcon: UIImageView!
    var order: UILabel!
    var logo: UIImageView!
    var teamName: UILabel!
    var matched: UILabel!
    var goals: UILabel!
    var difference: UILabel!
    var score: UILabel!
    
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
        
    }
    
    func setup() {
        
    }
    
    
    func setupLabel(alignment: NSTextAlignment, textColor: UIColor) -> UILabel {
        let textLabel = UILabel()
        textLabel.textAlignment = alignment
        textLabel.font = UIFont(name: FontType.latoRegular.., size: FontSize.normal--)
        textLabel.textColor = textColor
        textLabel.numberOfLines = 1
        return textLabel
    }
    
    func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
}
