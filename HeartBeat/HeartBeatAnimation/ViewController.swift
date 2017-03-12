//
//  ViewController.swift
//  HeartBeatAnimation
//
//  Created by Thành Lã on 2/27/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Size: CGFloat {
        case cell = 44
    }
    
    var didSetupConstraints = false
    
    @IBOutlet weak var dragAreaView: UIView!
    @IBOutlet weak var dragView: UIImageView!
    
    @IBOutlet weak var dragViewX: NSLayoutConstraint!
    @IBOutlet weak var dragViewY: NSLayoutConstraint!
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    let dragAreaPadding = 5
    var lastBounds = CGRect.zero
    
    var labelSkillRating: UILabel!
    var btTraining: UIButton!
    var btAction: UIButton!
    var tableAction: UITableView!
    
    
    var arrayAction: [(name: String, action: MentalAction_enum)] = [
        ("Push", Mental_Push),
        ("Pull", Mental_Pull),
        ("Left", Mental_Left),
        ("Right", Mental_Right)
    ]
    
    /**
     Engine
     */
    let engineWidget: EngineWidget = EngineWidget()
    
    var currentPow: CGFloat!
    var currentAct: MentalAction_t!
    var isTraining: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        engineWidget.delegate = self
        
        currentPow = 0.0
        currentAct = arrayAction[0].action
        isTraining = false
        
        Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(ViewController.updateCubePosition),
            userInfo: nil, repeats: true
        )
        
        lastBounds = self.view.bounds
        dragAreaView.backgroundColor = UIColor.General.background
        dragAreaView.layer.cornerRadius = 2
        
        dragView.backgroundColor = .clear
        dragView.contentMode = .scaleAspectFill
        dragView.image = Icon.General.circle
        dragView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapOnDragView(_:))))
        
        
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

//--------------------------
//MARK: SELECTOR
//--------------------------
extension ViewController {
    
    @IBAction func panAction() {
        switch self.panGesture.state {
        case .began:
            addAnimation(for: dragView)
            
        case .changed:
            moveCubeAndCheckConstraints()
            
        case .ended:
            dragView.layer.removeAllAnimations()
            
        default:
            break
        }
    }
    
    /// 
    func tapOnDragView(_ sender: UITapGestureRecognizer) {
        addAnimation(for: dragView)
    }
    
    ///
    func showTableAction(_ sender: AnyObject) {
         tableAction.isHidden = !tableAction.isHidden
    }
    
    ///
    func trainingAction(_ sender: UIButton) {
        guard !isTraining, sender.tag < arrayAction.count else { return }
        
        let action = arrayAction[sender.tag].action
        engineWidget.setActiveAction(action)
        engineWidget.setTrainingAction(action)
        engineWidget.setTrainingControl(Mental_Start)
        isTraining = true
    }
}




