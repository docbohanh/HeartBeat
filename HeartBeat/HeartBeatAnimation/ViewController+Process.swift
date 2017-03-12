//
//  ViewController+Process.swift
//  HeartBeatAnimation
//
//  Created by MILIKET on 3/12/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit

//--------------------------
//MARK: PRIVATE METHOD
//--------------------------
extension ViewController {
    
    // MARK: UI Updates
    func moveCubeAndCheckConstraints() {
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
    
    ///
    func updateCubePosition() {
        
        UIView.animate(withDuration: 0.3) {
            let range = self.currentPow * 4
            
            //move cube to left or right direction
            if (self.currentAct.rawValue == Mental_Left.rawValue || self.currentAct.rawValue == Mental_Right.rawValue) && range > 0 {
                self.dragViewX.constant = self.currentAct.rawValue == Mental_Left.rawValue
                    ? min(70, self.dragViewX.constant + range)
                    : max(-70, self.dragViewX.constant - range)
                
            }
            else if self.dragViewX.constant != 0 {
                self.dragViewX.constant = self.dragViewX.constant > 0
                    ? max(0, self.dragViewX.constant - 4)
                    : min(0, self.dragViewX.constant + 4)
                
            }
            
            //move cube to up or down direction
            if (self.currentAct.rawValue == Mental_Lift.rawValue || self.currentAct.rawValue == Mental_Drop.rawValue) && range > 0 {
                self.dragViewY.constant = self.currentAct.rawValue == Mental_Lift.rawValue
                    ? min(70, self.dragViewY.constant + range)
                    : max(-70, self.dragViewY.constant - range)
            }
            else if self.dragViewY.constant != 0 {
                self.dragViewY.constant = self.dragViewY.constant > 0
                    ? max(0, self.dragViewY.constant - 4)
                    : min(0, self.dragViewY.constant + 4)
            }
            
            //move cube to forward or backward direction
            if (self.currentAct.rawValue == Mental_Pull.rawValue || self.currentAct.rawValue == Mental_Push.rawValue) && range > 0 {
                self.dragView.transform = self.currentAct.rawValue == Mental_Push.rawValue
                    ? CGAffineTransform.identity.scaledBy(x: max(0.3, self.dragView.transform.a - self.currentPow/4), y: max(0.3, self.dragView.transform.d - self.currentPow/4))
                    : CGAffineTransform.identity.scaledBy(x: min(2.3, self.dragView.transform.a + self.currentPow/4), y: min(2.3, self.dragView.transform.d + self.currentPow/4))
            }
            else if self.dragView.transform.a != 1 {
                let scale : CGFloat! = self.dragView.transform.a < 1 ? 0.05 : -0.05
                self.dragView.transform = CGAffineTransform.identity.scaledBy(x: max(1, self.dragView.transform.a + scale), y: max(1, self.dragView.transform.d + scale))
            }
            
//            self.moveCubeAndCheckConstraints()
            
        }
        
    }
    
}








