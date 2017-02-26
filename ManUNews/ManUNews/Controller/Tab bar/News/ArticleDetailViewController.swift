//
//  ArticleDetailViewController.swift
//  ManuNews
//
//  Created by MILIKET on 2/21/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import SnapKit
import PHExtensions

class ArticleDetailViewController: GeneralViewController {
    fileprivate enum Size: CGFloat {
        case padding15 = 15, padding5 = 5, padding10 = 10, button = 44
    }
    
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
extension ArticleDetailViewController {
    func back(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
}

//------------------------------
//MARK: PRIVATE METHOD
//------------------------------
extension ArticleDetailViewController {
    
}

//------------------------------
//MARK: SETUP VIEW
//------------------------------
extension ArticleDetailViewController {
    func setupAllSubviews() {
        view.backgroundColor = UIColor.white
        setupBarButtonItem()
    }
    
    func setupAllConstraints() {
        
    }
    
    func setupBarButtonItem() {
        let left = setupBarButton(image: Icon.Navi.back, selector: #selector(self.back(_:)), target: self)
        navigationItem.leftBarButtonItem = left
    }
    
}
