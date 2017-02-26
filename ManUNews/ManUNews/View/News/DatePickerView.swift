//
//  DatePickerView.swift
//  ManuNews
//
//  Created by Thành Lã on 2/24/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import PHExtensions
import CVCalendar


protocol DatePickerViewDelegate: class {
    func changeDateTime(_ time: TimeInterval)
}

class DatePickerView: UIView {
    
    //==============================
    // MARK: - ENUM
    //==============================
    
    fileprivate enum Size: CGFloat {
        case rowWidth = 60, pickerView = 142, label = 35, button = 40, padding10 = 10, padding5 = 5
    }
    
    
    
    var pickerView: UIPickerView!
    var calendar: CVCalendarView!
    var menuView: CVCalendarMenuView!
    
    
    
    var animationFinished = true
    var monthLabel: UILabel!
    
    fileprivate var seperator: UIView!
    fileprivate var buttonRowLeft: UIButton!
    fileprivate var buttonRowRight: UIButton!
    
    
    fileprivate var seperatorCalendar: UIView!
    
    fileprivate var labelDots: UILabel!
    fileprivate var labelHour: UILabel!
    fileprivate var labelMinute: UILabel!
    
    var size: CGSize = CGSize(width: UIScreen.main.bounds.width,
                              height: UIScreen.main.bounds.height)
    
    weak var delegate: DatePickerViewDelegate?
    
    /**
     Độ cao của Calendar theo màn hình
     */
    fileprivate var calendarHeight: CGFloat {
        get {
            switch Device.size() {
            case .screen3_5Inch:
                return 200
                
            case .screen4Inch:
                return 220
                
            default:
                return 270
            }
        }
    }
    
    
    //-------------------------------------------
    //MARK: - INIT
    //-------------------------------------------
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAllSubviews()
    }
    
    
    //-------------------------------------------
    //MARK: - LAYOUT SUBVIEW
    //-------------------------------------------
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        monthLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: Size.label..)
        
        buttonRowRight.frame = CGRect(x: monthLabel.frame.width - Size.label..,
                                      y: 0,
                                      width: Size.label..,
                                      height: Size.label..)
        buttonRowLeft.frame = CGRect(x: 0,
                                     y: 0,
                                     width: Size.label..,
                                     height: Size.label..)
        
        seperator.frame = CGRect(x: Size.padding10..,
                                 y: monthLabel.frame.height - onePixel(),
                                 width: monthLabel.frame.width - Size.padding10.. * 2,
                                 height: onePixel())
        
        
        
        menuView.frame = CGRect(x: 0, y: 0, width: size.width, height: 0)
        
        
        calendar.frame = CGRect(x: 0,
                                y: monthLabel.frame.maxY,
                                width: size.width,
                                height: calendarHeight)
        
        calendar.frame.size.width = size.width
        
        
        seperatorCalendar.frame = CGRect(x: Size.padding10..,
                                         y: calendar.frame.maxY,
                                         width: calendar.frame.width - Size.padding10.. * 2,
                                         height: onePixel())
        
        
        pickerView.frame = CGRect(x: 0,
                                  y: calendar.frame.maxY + 1,
                                  width: calendar.frame.width ,
                                  height: Size.pickerView..)
        
        pickerView.frame.size.width = calendar.frame.width
        
        
        labelDots.frame = CGRect(x: 0,
                                 y: pickerView.frame.minY + (pickerView.frame.height - Size.button..) / 2 - 2 ,
                                 width: calendar.frame.width,
                                 height: Size.button..)
        
        labelHour.frame = CGRect(x: Size.padding10..,
                                 y: pickerView.frame.minY + (pickerView.frame.height - Size.button..) / 2,
                                 width: calendar.frame.width / 3,
                                 height: Size.button..)
        
        labelMinute.frame = CGRect(x: calendar.frame.width * 2 / 3 - Size.padding10..,
                                   y: pickerView.frame.minY + (pickerView.frame.height - Size.button..) / 2,
                                   width: calendar.frame.width / 3,
                                   height: Size.button..)
        
        
        calendar.commitCalendarViewUpdate()
        
    }
    
    
    //-------------------------------------------
    //MARK: - PRIVATE METHOD
    //-------------------------------------------
    
    
    func reloadCalendarView() {
        
        self.subviews.forEach { if $0.tag == 1000 { $0.removeFromSuperview() } }
        calendar = setupCalendar()
        addSubview(calendar)
        calendar.commitCalendarViewUpdate()
    }
    
    
    func reloadPickerView() {
        
        self.subviews.forEach { if $0.tag == 1001 { $0.removeFromSuperview() } }
        pickerView = setupPickerView()
        addSubview(pickerView)
    }
    
    
    func reloadDatePickerViewWithSize(_ size: CGSize) {
        self.size = size
        reloadCalendarView()
        reloadPickerView()
        layoutSubviews()
    }
    
    
    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription.uppercased()
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransform.identity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
}


//-------------------------------------------
//MARK: - SETUP VIEW
//-------------------------------------------

extension DatePickerView {
    func setupAllSubviews() {
        
        
        labelDots = setupLabel(":", textColor: UIColor.Navigation.main,
                               font: UIFont(name: FontType.latoSemibold.., size: FontSize.large++)!)
        
        pickerView = setupPickerView()
        
        calendar = setupCalendar()
        menuView = setupCalendarMenu()
        monthLabel = setupLabel( CVDate(date: Date(), calendar: Calendar.current).globalDescription.uppercased() ,
                                 textColor: UIColor.Text.grayNormal,
                                 font: UIFont(name: FontType.latoRegular.., size: FontSize.large--)!)
        
        labelHour = setupLabel("Giờ",
                               textColor: UIColor.Navigation.main,
                               font: UIFont(name: FontType.latoRegular..,
                                            size: FontSize.normal++)!)
        
        labelMinute = setupLabel("Phút",
                                 textColor: UIColor.Navigation.main,
                                 font: UIFont(name: FontType.latoRegular..,
                                              size: FontSize.normal++)!)
        
        buttonRowLeft = setupButtonArrow(Icon.Home.ArrowLeft)
        buttonRowRight = setupButtonArrow(Icon.Home.ArrowRight)
        
        seperator = setupSeperator()
        seperatorCalendar = setupSeperator()
        
        
        addSubview(labelHour)
        addSubview(labelMinute)
        addSubview(labelDots)
        addSubview(pickerView)
        addSubview(calendar)
        addSubview(menuView)
        
        addSubview(monthLabel)
        addSubview(buttonRowLeft)
        addSubview(buttonRowRight)
        addSubview(seperator)
        
        //        addSubview(seperatorCalendar)
        
        calendar.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    func setupSeperator(_ bgColor: UIColor = UIColor.Misc.seperator) -> UIView {
        let view = UIView()
        view.backgroundColor = bgColor
        return view
    }
    
    func setupLabel(_ text: String? = nil, textColor: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = font
        label.textColor = textColor
        label.text = text
        return label
    }
    
    func setupButton(_ image: UIImage, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(image.tint(UIColor.main), for: UIControlState())
        button.setImage(image.tint(UIColor.Text.grayMedium), for: .disabled)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    func setupButtonArrow(_ image: UIImage, tintColor: UIColor = UIColor.Text.grayNormal) -> UIButton {
        let button = UIButton()
        button.setImage(image.tint(tintColor), for: UIControlState())
        return button
    }
    
    func setupPickerView() -> UIPickerView {
        let picker = UIPickerView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: size.width,
                                                height: Size.pickerView..))
        
        picker.showsSelectionIndicator = true
        picker.tag = 1001
        return picker
    }
    
    
    func setupCalendar() -> CVCalendarView {
        
        let calendar = CVCalendarView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: size.width,
                                                    height: calendarHeight))
        calendar.tag = 1000
        
        
        
        return calendar
    }
    
    func setupCalendarMenu() -> CVCalendarMenuView {
        let menu = CVCalendarMenuView()
        return menu
    }
}
