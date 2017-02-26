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
        case padding15 = 15, padding5 = 5, padding10 = 10, button = 44, heart = 150
    }
    
    var dragView: UIButton!
    var box: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.main.cgColor
        view.layer.borderWidth = 2 * onePixel()
        return view
    }()
    
    var dragViewX: Constraint!
    var dragViewY: Constraint!
    
    var initialDragViewY: CGFloat = 0.0
//    var isGoalReached: Bool {
//        get {
//            let distanceFromGoal: CGFloat = sqrt(pow(self.dragView.center.x - self.goalView.center.x, 2) + pow(self.dragView.center.y - self.goalView.center.y, 2))
//            return distanceFromGoal < self.dragView.bounds.size.width / 2
//        }
//    }
    let dragAreaPadding = 5
    var lastBounds = CGRect.zero
    
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
    func didTapHeart(_ sender: UIButton) {
        testAnimation()
    }
    
    func didLongPressHeart(_ guesture: UILongPressGestureRecognizer) {
        if guesture.state == UIGestureRecognizerState.began {
            print("Long Press")
            addHeartBeatAnimation(for: self.dragView)
        }
    }
    
    func didLongPress(_ sender: UIButton) {
        print("Long Press")
        addHeartBeatAnimation(for: self.dragView)
    }
    
    func buttonMoved(_ sender: UIButton, event: UIEvent) {
        
        guard let touches = event.allTouches else { return }
        guard let touch = touches.first else { return }
        
        let prev = touch.previousLocation(in: sender)
        let translation = touch.location(in: sender)
        var center = sender.center
        center.x += translation.x - prev.x
        center.y += translation.y - prev.y
        
        if center.x - Size.heart.. / 2 > box.frame.origin.x
            && center.x + Size.heart.. / 2 < box.frame.origin.x + box.bounds.width
            && center.y + Size.heart.. / 2 > box.frame.origin.y
            && center.y + Size.heart.. / 2 < box.frame.origin.y + box.bounds.height {
            
            sender.center = center
        }
        
        
        addHeartBeatAnimation(for: sender)
    }
    
    func handlePanFrom(_ recognizer : UIPanGestureRecognizer) {
        /*
        if recognizer.state == .began {
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            
            self.selectNodeForTouch(touchLocation)
        } else if recognizer.state == .changed {
            var translation = recognizer.translation(in: recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            self.panForTranslation(translation)
            
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
        } else if recognizer.state == .ended {
            if selectedNode.name != kAnimalNodeName {
                let scrollDuration = 0.2
                let velocity = recognizer.velocity(in: recognizer.view)
                let pos = selectedNode.position
                
                // This just multiplies your velocity with the scroll duration.
                let p = CGPoint(x: velocity.x * CGFloat(scrollDuration), y: velocity.y * CGFloat(scrollDuration))
                
                var newPos = CGPoint(x: pos.x + p.x, y: pos.y + p.y)
                newPos = self.boundLayerPos(newPos)
                selectedNode.removeAllActions()
                
                let moveTo = SKAction.move(to: newPos, duration: scrollDuration)
                moveTo.timingMode = .easeOut
                selectedNode.run(moveTo)
            }
        }
 */
        switch recognizer.state {
        case .began:
            break
        case .ended:
            break
        default:
            break
        }
    }
}

//------------------------------
//MARK: PRIVATE METHOD
//------------------------------
extension ResultViewController {
    
    func snapshopOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    func testAnimation() {
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.3
        animation.repeatCount = HUGE
        animation.autoreverses = true
        animation.fromValue = NSNumber(value: 1.0)
        animation.toValue = NSNumber(value: 0.7)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        dragView.layer.add(animation, forKey: "animateOpacity")
    }
    
    /**
     Heart beating animation
     */
    func addHeartBeatAnimation(for sender: AnyObject) {
        let beatLong: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        beatLong.fromValue = NSValue(cgSize: CGSize(width: 1, height: 1))
        beatLong.toValue = NSValue(cgSize: CGSize(width: 0.8, height: 0.8))
        beatLong.autoreverses = true
        beatLong.duration = 0.5
        beatLong.beginTime = 0.0
        
        let beatShort: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        beatShort.fromValue = NSValue(cgSize: CGSize(width: 1, height: 1))
        beatShort.toValue = NSValue(cgSize: CGSize(width: 0.6, height: 0.6))
        beatShort.autoreverses = true
        beatShort.duration = 0.7
        beatShort.beginTime = beatLong.duration
        beatLong.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let heartBeatAnim: CAAnimationGroup = CAAnimationGroup()
        heartBeatAnim.animations = [beatLong, beatShort]
        heartBeatAnim.duration = beatShort.beginTime + beatShort.duration
        heartBeatAnim.fillMode = kCAFillModeForwards
        heartBeatAnim.isRemovedOnCompletion = false
        heartBeatAnim.repeatCount = HUGE
        
        sender.layer.add(heartBeatAnim, forKey: nil)
    }
}

//------------------------------
//MARK: SETUP VIEW
//------------------------------
extension ResultViewController {
    func setupAllSubviews() {
        view.backgroundColor = UIColor.white
        title = "Kết quả"
        
        dragView = setupButton()
//        heart.addTarget(self, action: #selector(self.didTapHeart(_:)), for: .touchUpInside)
        
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.dragButton(_:_:)))
//        heart.addGestureRecognizer(longPress)

        // drag support
        dragView.addTarget(self, action: #selector(buttonMoved(_:event:)), for: .touchDragInside)
        dragView.addTarget(self, action: #selector(buttonMoved(_:event:)), for: .touchDragOutside)

        
        box.addSubview(dragView)
        view.addSubview(box)
    }
    
    func setupAllConstraints() {
        box.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(view)
            make.width.height.equalTo(200)
        }
        
        dragView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(box)
            make.width.height.equalTo(Size.heart..)
            
        }
    }
    
    func setupButton() -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setImage(UIImage(named: "Heart"), for: UIControlState())
        return button
    }
    
}
