//
//  HeartBeatViewController.swift
//  HeartBeatAnimation
//
//  Created by Thành Lã on 2/28/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit

class HeartBeatViewController: UIViewController {
    fileprivate enum Size: CGFloat {
        case padding15 = 15, padding5 = 5, padding10 = 10, button = 44
    }
    var didSetupConstraints = false
    
    // MARK: Vars
    
    var dragAreaView: UIView! = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    var dragView: HeartView! = {
        let view = HeartView()
        return view
    }()
    
    var goalView: UIView!
    
    var dragViewX: NSLayoutConstraint!
    var dragViewY: NSLayoutConstraint!
    
    var panGesture: UIPanGestureRecognizer!
    
    var initialDragViewY: CGFloat = 0.0
    var isGoalReached: Bool {
        get {
            let distanceFromGoal: CGFloat = sqrt(
                pow(self.dragView.center.x - self.goalView.center.x, 2) + pow(self.dragView.center.y - self.goalView.center.y, 2)
            )
            return distanceFromGoal < self.dragView.bounds.size.width / 2
        }
    }
    let dragAreaPadding = 5
    var lastBounds = CGRect.zero
    
    var completion: (() -> Void)?
    
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
extension HeartBeatViewController {
    
}

//------------------------------
//MARK: PRIVATE METHOD
//------------------------------
extension HeartBeatViewController {
    
}

//------------------------------
//MARK: SETUP VIEW
//------------------------------
extension HeartBeatViewController {
    func setupAllSubviews() {
        view.backgroundColor = .white
    }
    
    func setupAllConstraints() {
        
    }
    
    
    
}
