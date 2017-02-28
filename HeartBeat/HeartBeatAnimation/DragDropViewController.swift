
import UIKit

class DragDropViewController: UIViewController {
    
    // MARK: Vars
    
    @IBOutlet weak var dragAreaView: UIView!
    @IBOutlet weak var dragView: HeartView!
    @IBOutlet weak var goalView: UIView!
    
    @IBOutlet weak var dragViewX: NSLayoutConstraint!
    @IBOutlet weak var dragViewY: NSLayoutConstraint!
        
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
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
    
    var completion: (() -> ())?
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lastBounds = self.view.bounds
        self.dragAreaView.layer.borderWidth = 1
        self.dragAreaView.layer.borderColor = UIColor.white.cgColor
        
        self.dragView.layer.cornerRadius = self.dragView.bounds.size.height / 2
        
        self.goalView.layer.cornerRadius = self.goalView.bounds.size.height / 2
        self.goalView.layer.borderWidth = 2
        
        self.initialDragViewY = self.dragViewY.constant 
        
        self.updateGoalView() 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !self.view.bounds.equalTo(self.lastBounds) {
            self.boundsChanged()
            self.lastBounds = self.view.bounds
        }
    }
    
    func boundsChanged() {
        self.returnToStartLocationAnimated(animated: false)
        
        self.dragAreaView.bringSubview(toFront: self.goalView)
        self.dragAreaView.bringSubview(toFront: self.dragView)
        self.view.layoutIfNeeded()
        
    }
    
    // MARK: Actions
    @IBAction func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func panAction() {
        switch self.panGesture.state {
        case .began:
            addHeartBeatAnimation(for: self.dragView)
        case .changed:
            self.moveObject()
        default:
            break
        }
        /*
        if self.panGesture.state == .changed {
            self.moveObject() 
        }
        else if self.panGesture.state == .ended {
            if self.isGoalReached {
                addHeartBeatAnimation(for: self.dragView)
            }
            else {
                self.returnToStartLocationAnimated(animated: true)
            }
        }
        */
    }
    
    
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
        
        self.updateGoalView() 
    }
    
    func updateGoalView() {
        let goalColor = self.isGoalReached ? UIColor.white : UIColor.red
        self.goalView.layer.borderColor = goalColor.cgColor
        
        
    }
    
    func returnToStartLocationAnimated(animated: Bool) {
        self.dragViewX.constant = (self.dragAreaView.bounds.size.width - self.dragView.bounds.size.width) / 2
        self.dragViewY.constant = self.initialDragViewY
        
        if (animated) {
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: .beginFromCurrentState,
                animations: { () -> Void in
                    self.view.layoutIfNeeded()
                },
                completion: nil)
        }
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


