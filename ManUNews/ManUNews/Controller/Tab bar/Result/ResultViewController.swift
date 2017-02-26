//
//  ResultViewController.swift
//  ManUNews
//
//  Created by MILIKET on 2/26/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import SnapKit
import PHExtensions

class ResultViewController: GeneralViewController {
    fileprivate enum Size: CGFloat {
        case padding15 = 15, padding5 = 5, padding10 = 10, button = 44
    }
    
    var headerView: UIImageView!
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAllSubviews()
        view.setNeedsUpdateConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            setupAllConstraints()
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
}

//------------------------------
//MARK: SELECTOR
//------------------------------
extension ResultViewController {
    
}

//------------------------------
//MARK: PRIVATE METHOD
//------------------------------
extension ResultViewController {
    
}

//------------------------------
//MARK: SETUP VIEW
//------------------------------
extension ResultViewController {
    func setupAllSubviews() {
        view.backgroundColor = UIColor.white
        
    }
    
    func setupAllConstraints() {
    }
    
}
