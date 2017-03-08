//
//  ProfileHeaderTableView.swift
//  ManUNews
//
//  Created by MILIKET on 3/9/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import PHExtensions
import UIKit


class ProfileHeaderTableView: UIView {
    
    fileprivate enum Size: CGFloat {
        case label = 30, padding = 10, radiusImageWidth = 5
    }
    
    var viewImageShadow: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 4.0
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.borderWidth = onePixel()
        view.layer.borderColor = UIColor.Navigation.main.cgColor
        return view
    }()
    
    // Ảnh đại diện của người dùng
    
    var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Icon.Personal.AvatarDefault
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(rgba: "F3F3F3")
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    
    var imageWidth: CGFloat = {
        switch Device.size() {
        case .screen3_5Inch:
            return 90
        case .screen4Inch:
            return 95
        case .screen4_7Inch:
            return 105
        case .screen5_5Inch:
            return 110
            
        default:
            return 110
        }
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    func setup () {
        
        backgroundColor = UIColor.clear
        addSubview(viewImageShadow)
        viewImageShadow.addSubview(avatarImage)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = imageWidth
        
        viewImageShadow.frame = CGRect(x: (bounds.width - width) / 2,
                                       y: (bounds.height - imageWidth - Size.label..  ) / 2   + Size.padding.. / 2,
                                       width: width,
                                       height: width)
        
        viewImageShadow.layer.cornerRadius = viewImageShadow.frame.height/2
        
        avatarImage.frame = CGRect(x: Size.radiusImageWidth..,
                                   y: Size.radiusImageWidth..,
                                   width: imageWidth - Size.radiusImageWidth.. * 2,
                                   height: imageWidth - Size.radiusImageWidth.. * 2)
        avatarImage.layer.cornerRadius = avatarImage.frame.height/2
        
        
    }
    
}
