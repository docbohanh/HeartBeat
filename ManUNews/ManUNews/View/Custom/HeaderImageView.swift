//
//  HeaderImageView.swift
//  ManUNews
//
//  Created by MILIKET on 3/12/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import PHExtensions

class HeaderImageView: UIView {
    
    enum Size: CGFloat {
        case padding7 = 7, padding10 = 10, padding15 = 15
    }
    
    var imageView: UIImageView!
    var title: UILabel!
    
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
        
        imageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        title.frame = CGRect(x: 15, y: bounds.height - 200, width: bounds.width - 15 * 2, height: 200)
    }
    
    func setup() {
       
        imageView = setupHeaderImage()
        title = setupLabel()
        addSubview(imageView)
        addSubview(title)
    }
    
    
    func setupLabel() -> UILabel {
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.font = UIFont(name: FontType.latoBold.., size: FontSize.large++)
        textLabel.textColor = UIColor.white
        textLabel.backgroundColor = .clear
        return textLabel
    }
    
    
    func setupHeaderImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
}
