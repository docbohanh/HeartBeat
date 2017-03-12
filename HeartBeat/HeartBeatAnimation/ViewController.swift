//
//  ViewController.swift
//  HeartBeatAnimation
//
//  Created by Thành Lã on 2/27/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dragAreaView: UIView!
    @IBOutlet weak var dragView: UIImageView!
    
    @IBOutlet weak var dragViewX: NSLayoutConstraint!
    @IBOutlet weak var dragViewY: NSLayoutConstraint!
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    
    let dragAreaPadding = 5
    var lastBounds = CGRect.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastBounds = self.view.bounds
        dragAreaView.layer.borderWidth = 1
        dragAreaView.layer.borderColor = UIColor.white.cgColor
        
        dragView.backgroundColor = .clear
        dragView.contentMode = .scaleAspectFill
        dragView.image = UIImage(named: "Circle")
        dragView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapOnDragView(_:))))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: SELECTOR
extension ViewController {
    
    @IBAction func panAction() {
        switch self.panGesture.state {
        case .began:
            addAnimation(for: dragView)
            
        case .changed:
            moveObject()
            
        case .ended:
            dragView.layer.removeAllAnimations()
            
        default:
            break
        }
    }
    
    func tapOnDragView(_ sender: UITapGestureRecognizer) {
        addAnimation(for: dragView)
    }
}

//MARK: PRIVATE METHOD
extension ViewController {
    // MARK: UI Updates
    
    func moveObject() {
        let minX = CGFloat(self.dragAreaPadding)
        let maxX = self.dragAreaView.bounds.size.width - self.dragView.bounds.size.width - minX
        
        let minY = CGFloat(self.dragAreaPadding)
        let maxY = self.dragAreaView.bounds.size.height - self.dragView.bounds.size.height - minY
        
        var translation =  self.panGesture.translation(in: self.dragAreaView)
        
        var dragViewX = self.dragViewX.constant + translation.x
        var dragViewY = self.dragViewY.constant + translation.y
        
        if dragViewX < minX {
            dragViewX = minX
            translation.x += self.dragViewX.constant - minX
        }
        else if dragViewX > maxX {
            dragViewX = maxX
            translation.x += self.dragViewX.constant - maxX
        }
        else {
            translation.x = 0
        }
        
        if dragViewY < minY {
            dragViewY = minY
            translation.y += self.dragViewY.constant - minY
        }
        else if dragViewY > maxY {
            dragViewY = maxY
            translation.y += self.dragViewY.constant - maxY
        }
        else {
            translation.y = 0
        }
        
        self.dragViewX.constant = dragViewX
        self.dragViewY.constant = dragViewY
        
        self.panGesture.setTranslation(translation, in: self.dragAreaView)
        
        UIView.animate(
            withDuration: 0.05,
            delay: 0,
            options: .beginFromCurrentState,
            animations: { () -> Void in
                self.view.layoutIfNeeded()
        },
            completion: nil)
        
    }
    
    
    /**
     Basic animation
     */
    func addAnimation(for sender: AnyObject) {
        
        let theAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        theAnimation.duration = 0.3
        theAnimation.repeatCount = HUGE
        theAnimation.autoreverses = true
        theAnimation.fromValue = NSNumber(value: 1.0)
        theAnimation.toValue = NSNumber(value: 0.85)
        theAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        sender.layer.add(theAnimation, forKey: "animateOpacity")
    }
}
