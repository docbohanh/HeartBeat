//
//  Utility.swift
//  P01.TapCounter
//
//  Created by Thành Lã on 12/29/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import UIKit
import PHExtensions
import CleanroomLogger


public func crashApp(message:String) -> Never  {
    let log = "CRASH - " + message
    Log.message(.error, message: log)
    fatalError(log)
}

public func delay(_ delay: Double, closure:@escaping () -> () ) {    
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
}

struct Utility {
    static let shared = Utility()
    
    /**
     Kiểm tra định dạng email
     */
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    /**
     Tính chiều rộng của text
     */
    func widthForView(text: String, font: UIFont, height: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0,  width: CGFloat.greatestFiniteMagnitude, height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.width
    }
    
    /**
     Tính độ cao cho text
     */
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    /// Căn giữa cho text và image của button
    func centeredTextAndImage(for button: UIButton) {
        let spacing: CGFloat = 3.0
        let imageSize: CGSize = button.imageView!.image!.size
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0);
        let labelString = NSString(string: button.titleLabel!.text!)
        let titleSize = labelString.size(attributes: [NSFontAttributeName: button.titleLabel!.font])
        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width);
    }
    
//    func getGMSPath(from coordinate: [Coordinate]) -> GMSPath {
//        let path = GMSMutablePath()
//        coordinate.forEach { path.add($0) }
//        return path
//    }
    
    /*
     Format khoảng cách
     */
    func stringFromConvertDistanceToText(_ distance: Double, metersAccuracy: Bool = true) -> String {
        if distance < 1000 && metersAccuracy {
            return distance.toString(0) + " " + "m"
        } else {
            return (distance / 1000).toString(1) + " " + "Km"
        }
    }
    
    func stringMinuteFromTimeInterval(_ duration: TimeInterval) -> String {
        
        guard duration >= 0 else { crashApp(message: "duration < 0 : get minute") }
        guard duration > 0 else { return "0" + " " + "phút" }
        guard duration > 30 else { return "Dưới 1 phút"  }
        
        var hour, minute, second: Int
        hour = Int(duration / 1.hour)
        minute = (Int(duration) - (hour * Int(1.hour))) / Int(1.minute)
        second = Int(duration) - (hour * Int(1.hour)) - (minute * Int(1.minute))
        
        if second >= 30 { minute += 1 }
        if minute == 60 { hour += 1; minute = 0 }
        
        
        var stringTime = ""
        if hour > 0 { stringTime += "\(hour) " + (hour > 1 ? "giờ" :"giờ")}
        if minute > 0 { stringTime += " \(minute) " + (minute > 1 ? "phút" : "phút") }
        return stringTime
    }
    
    /*
     Format khoảng cách
     */
    static func stringFromConvertDistanceToText(_ distance: Double, metersAccuracy: Bool = true) -> String {
        if distance < 1000 && metersAccuracy {
            return distance.toString(0) + " " + "m"
        } else {
            return (distance / 1000).toString(1) + " " + "Km"
        }
    }
    
    /**
     Convert thời gian theo dạn quá khứ
     */
    func stringFromPastTimeToText(_ time: TimeInterval) -> String {
        let deltaTime = Date().timeIntervalSince1970 - time
        
        var string = String()
        switch deltaTime {
        case 0..<10:
            string = "vừa xong"
        case 10..<1.minutes:
            string = deltaTime.toString(0) + " giây"
        case 1.minutes..<1.hours:
            string =  (deltaTime / 1.minutes).toString(0) + " phút"
        case 1.hours..<1.days:
            string = (deltaTime / 1.hours).toString(0) + " giờ"
        case 1.days..<7.days:
            string = (deltaTime / 1.days).toString(0) + " ngày"
        case 7.days..<31.days:
            string = (deltaTime / 7.days).toString(0) + " tuần"
        case 31.days..<1.years:
            string = (deltaTime / 31.days).toString(0) + " tháng"
        case 1.year..<100.years:
            string = (deltaTime / 1.years).toString(0) + " năm"
        default:
            break
        }
        
        guard deltaTime > 10 else { return string }
        
        string += " trước"
        return string
    }
    
    /**
     Chỉnh lại giao diện navigation bar
     
     - parameter navController:
     */
    func configureAppearance(navigation navController: UINavigationController) {
        
        navController.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: FontType.latoRegular.., size: FontSize.large--)!,
            NSForegroundColorAttributeName: UIColor.white]
        navController.navigationBar.barTintColor = UIColor.main
        
        
        navController.navigationBar.barStyle = .black
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navController.navigationBar.isTranslucent = false
    }
    
    ///
    func setupTabBarController() -> UITabBarController {
        
        let tabbarVC = UITabBarController()
        
        let naviNewsVC = UINavigationController(rootViewController: NewsViewController())
        let naviComunityVC = UINavigationController(rootViewController: ComunityViewController())
        let naviResultVC = UINavigationController(rootViewController: ResultViewController())
        let naviScheduleVC = UINavigationController(rootViewController: ScheduleViewController())
        let naviProfileVC = UINavigationController(rootViewController: ProfileViewController())
        
        let viewControllers = [naviNewsVC, naviResultVC, naviScheduleVC, naviComunityVC, naviProfileVC]
        
        viewControllers.forEach { Utility.shared.configureAppearance(navigation: $0) }
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        tabbarVC.viewControllers = viewControllers
        
        tabbarVC.tabBar.barStyle = .default
        tabbarVC.tabBar.backgroundColor = UIColor.Navi.main
        tabbarVC.tabBar.barTintColor = UIColor.white.alpha(0.8)
        tabbarVC.tabBar.isTranslucent = false
        
        let items: [(title: String, image: UIImage)] = [
            ("Tin tức", Icon.TabBar.article),
            ("Kết quả",  Icon.TabBar.noteBook),
            ("Lịch thi đấu", Icon.TabBar.history),
            ("Bình loạn",  Icon.TabBar.noteBook),
            ("Cá nhân", Icon.TabBar.personal)
        ]
        
        
        for (i, item)  in tabbarVC.tabBar.items!.enumerated() {
            item.selectedImage = items[i].image.tint(UIColor.main)
            item.image = items[i].image.tint(UIColor.lightGray)
            item.title = items[i].title
                        
            item.setTitleTextAttributes([
                NSFontAttributeName: UIFont(name: FontType.latoSemibold.., size: FontSize.small--)!], for: .normal)
            
        }
        
        return tabbarVC
    }
    

}

