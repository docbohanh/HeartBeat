//
//  SelectionTimeViewController.swift
//  ManuNews
//
//  Created by Thành Lã on 2/24/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import PHExtensions
import CVCalendar

protocol SelectionTimeControllerDelegate: class {
    func dismissTimeSelection()
    func didSelectedTime(_ fromTime: TimeInterval, toTime: TimeInterval)
}

class SelectionTimeViewController: GeneralViewController {
    
    
    fileprivate enum Component: Int {
        case hour = 0, minute
    }
    
    fileprivate enum Size: CGFloat {
        case rowWidth = 60, pickerView = 142, label = 30, button = 40, padding10 = 10, padding5 = 5
    }
    
    //-------------------------------------------
    //MARK: - BAR BUTTON
    //-------------------------------------------
    
    fileprivate var back: UIBarButtonItem!
    
    var headerView: TimeSelectionHeaderView!
    var datePickerView: DatePickerView!
    var footerView: TimeSelectionFooterView!
    
    
    
    var fromTimeInput: TimeInterval! {
        didSet {
            
            guard headerView != nil else { return }
            headerView.buttonFromTime.setTitle(dateTimeFormatter.string(from: Date(timeIntervalSince1970: fromTimeInput)), for: UIControlState())
        }
    }
    
    var toTimeInput: TimeInterval! {
        didSet {
            guard headerView != nil else { return }
            headerView.buttonToTime.setTitle(dateTimeFormatter.string(from: Date(timeIntervalSince1970: toTimeInput)), for: UIControlState())
        }
    }
    
    var rowSelected: (hour: Int, minute: Int)?
    
    var date = Date()
    
    var minDate = Date() - 2.days
    var maxDate = Date()
    
    fileprivate var dateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm - dd/MM/yyyy"
        return formatter
    }
    
    weak var delegate: SelectionTimeControllerDelegate?
    
    //====================================
    // MARK: - LIFE CYCLE
    //====================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chọn khoảng thời gian"
        
        setupAllSubviews()
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            setupAllConstraints()
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigation = navigationController {
            Utility.shared.configureAppearance(navigation: navigation)
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        datePickerView.reloadDatePickerViewWithSize(size)
        setupDelegate()
        setDateForDatePickerView(date, animation: true)
    }
}


//====================================
// MARK: - SELECTOR
//====================================

extension SelectionTimeViewController {
    
    func back(_ sender: UIBarButtonItem) {
        
        AppData.shared.gestureRecognizerShouldReceiveTouch = false
        delegate?.dismissTimeSelection()
    }
    
    func confirm(_ sender: UIButton) {
        let currentTime = Date().timeIntervalSince1970
        
        
        guard fromTimeInput <= currentTime - 1.hour else {
            HUD.showMessage("Khoảng thời gian bắt đầu phải nhỏ hơn thời gian hiện tại 1 tiếng.", onView: self.view)
            return
        }
        
        guard toTimeInput <= fromTimeInput + 3.days else {
            HUD.showMessage("Khoảng thời gian được chọn không được quá 3 ngày", onView: self.view)
            return
        }
        
        guard toTimeInput >= fromTimeInput + 1.hour else {
            HUD.showMessage("Khoảng thời gian đã chọn phải lớn hơn 1 giờ", onView: self.view)
            return
        }
        
        delegate?.didSelectedTime(fromTimeInput, toTime: toTimeInput + 59.seconds)
        
    }
    
    func cancel(_ sender: UIButton) {
        delegate?.dismissTimeSelection()
    }
    
    func buttonFrom(_ sender: ButtonUnderline) {
        sender.isSelected = true
        headerView.buttonToTime.isSelected = false
        
        date = Date(timeIntervalSince1970: fromTimeInput)
        setDateForDatePickerView(Date(timeIntervalSince1970: fromTimeInput), animation: true)
        
        sender.titleLabel?.font = UIFont(name: FontType.latoBold.., size: FontSize.normal--)!
        sender.seperator.isHidden = false
        headerView.buttonToTime.titleLabel?.font = UIFont(name: FontType.latoRegular.., size: FontSize.normal--)!
        headerView.buttonToTime.seperator.isHidden = true
    }
    
    func buttonTo(_ sender: ButtonUnderline) {
        sender.isSelected = true
        headerView.buttonFromTime.isSelected = false
        
        date = Date(timeIntervalSince1970: toTimeInput)
        setDateForDatePickerView(Date(timeIntervalSince1970: toTimeInput), animation: true)
        
        sender.titleLabel?.font = UIFont(name: FontType.latoBold.., size: FontSize.normal--)!
        sender.seperator.isHidden = false
        headerView.buttonFromTime.titleLabel?.font = UIFont(name: FontType.latoRegular.., size: FontSize.normal--)!
        headerView.buttonFromTime.seperator.isHidden = true
        
    }
}

//====================================
// MARK: - PRIVATE METHOD
//====================================

extension SelectionTimeViewController {
    
    func isRowEnable(_ row: Int, component: Int) -> Bool {
        
        guard let rowSelected = rowSelected else { return false }
        
        switch component {
        case Component.hour..:
            if row == rowSelected.hour { return true }
            
        case Component.minute..:
            if row == rowSelected.minute { return true }
            
        default:
            break
        }
        return false
    }
    
    func setDateForDatePickerView(_ date: Date, animation: Bool) {
        
        
        let componentsDate = (Calendar.current as NSCalendar).components([ .year, .month, .day, .hour, .minute], from: date)
        
        if !animation {
            guard rowSelected == nil else { return }
        }
        
        rowSelected = (componentsDate.hour!,componentsDate.minute!)
        datePickerView.pickerView.reloadAllComponents()
        datePickerView.pickerView.selectRow(componentsDate.hour!, inComponent: Component.hour.., animated: animation)
        datePickerView.pickerView.selectRow(componentsDate.minute!, inComponent: Component.minute.., animated: animation)
        
        datePickerView.calendar.toggleViewWithDate(date)
    }
}

//-------------------------------------------
//MARK: - DATE PICKER VIEW DELEGATE
//-------------------------------------------

extension SelectionTimeViewController {
    func changeDateTime(_ time: TimeInterval) {
        if headerView.buttonFromTime.isSelected {
            fromTimeInput = time
        } else {
            toTimeInput = time
        }
    }
}


//-------------------------------------------
//MARK: - PICKERVIEW DELEGATE
//-------------------------------------------

extension SelectionTimeViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label = view as? UILabel
        if label == nil { label = UILabel() }
        
        label!.text = (row.toString(0).characters.count > 1 ? "" : "0") + "\(row)"
        label!.textAlignment = .center
        label!.font = UIFont(name: FontType.latoSemibold.., size: FontSize.large++)
        label!.textColor = isRowEnable(row, component: component) ? UIColor.main : UIColor.Text.blackMedium
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return Size.rowWidth..
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Size.button..
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if rowSelected == nil { rowSelected = (0,0) }
        
        switch component {
        case Component.hour..:
            date = date + (row - rowSelected!.hour).hour
            rowSelected!.hour = row
            
        case Component.minute..:
            date = date + (row - rowSelected!.minute).minute
            rowSelected!.minute = row
            
        default:
            break
        }
        
        pickerView.reloadComponent(component)
        setDateForDatePickerView(date, animation: false)
        changeDateTime(date.timeIntervalSince1970)
    }
}

//-------------------------------------------
//MARK: - PICKERVIEW DATASOURCE
//-------------------------------------------

extension SelectionTimeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Component.minute++
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case Component.hour..:
            return 24
        case Component.minute..:
            return 60
        default:
            return 0
        }
    }
}


//====================================
// MARK: - CVCALENDAR
//====================================

//====================================
// MARK: - -CVCALENDAR MENU DELEGATE
//====================================
extension SelectionTimeViewController: CVCalendarMenuViewDelegate {
    func dayLabelWeekdayInTextColor() -> UIColor {
        return UIColor.Text.blackMedium
    }
    
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .veryShort
    }
    
    
    func dayOfWeekFont() -> UIFont {
        return UIFont(name: FontType.latoRegular.., size: FontSize.normal--)!
    }
}

//====================================
// MARK: - -CVCALENDAR  DELEGATE
//====================================

extension SelectionTimeViewController: CVCalendarViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return false
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        
        let componentsDate = (Calendar.current as NSCalendar).components([.year, .month, .day, .hour, .minute], from: date)
        date = Foundation.Date(timeIntervalSince1970: dayView.date.convertedDate(calendar: Calendar.current)!.timeIntervalSince1970  + componentsDate.hour!.hours + componentsDate.minute!.minutes)
        changeDateTime(date.timeIntervalSince1970)
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        datePickerView.presentedDateUpdated(date)
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }
    
}

//============================================
// MARK: - -CVCALENDAR APPEARANCE DELEGATE
//============================================

extension SelectionTimeViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelWeekdaySelectedTextColor() -> UIColor {
        return UIColor.white
    }
    
    func dayLabelWeekdaySelectedBackgroundColor() -> UIColor {
        return UIColor.Navigation.main
    }
    
    func dayLabelPresentWeekdayTextColor() -> UIColor {
        return UIColor.main
    }
    
    func dayLabelPresentWeekdaySelectedBackgroundColor() -> UIColor {
        return UIColor.Navigation.main
    }
    
    func dayLabelPresentWeekdayFont() -> UIFont {
        return UIFont(name: FontType.latoBold.., size: FontSize.normal..)!
    }
    
    func dayLabelWeekdaySelectedFont() -> UIFont {
        return UIFont(name: FontType.latoBold.., size: FontSize.normal..)!
    }
    
    func dayLabelPresentWeekdaySelectedFont() -> UIFont {
        return UIFont(name: FontType.latoBold.., size: FontSize.normal..)!
    }
    
    func dayLabelWeekdayFont() -> UIFont {
        return UIFont(name: FontType.latoRegular.., size: FontSize.normal..)!
    }
    func spaceBetweenDayViews() -> CGFloat {
        return 10.0
    }
}


//====================================
// MARK: - SETUP
//====================================

extension SelectionTimeViewController {
    
    fileprivate func setupAllSubviews() {
        
        setupBackBarButton()
        setupHeaderView()
        setupFooterView()
        setupDatePickerView()
        
        AppData.shared.gestureRecognizerShouldReceiveTouch = true
        
        view.addSubview(headerView)
        view.addSubview(datePickerView)
        view.addSubview(footerView)
        
        view.backgroundColor = UIColor.white
    }
    
    internal func setupAllConstraints() {
        headerView.snp.makeConstraints { make in
            make.trailing.leading.top.equalTo(view)
            make.height.equalTo(headerView.viewHeight())
        }
        
        footerView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalTo(view)
            make.height.equalTo(footerView.viewHeight())
        }
        
        datePickerView.snp.makeConstraints { make in
            make.trailing.leading.equalTo(view)
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(footerView.snp.top)
        }
        
    }
    
    fileprivate func setupBackBarButton() {
        back = setupBarButton(image: Icon.Navi.delete, selector: #selector(self.back(_:)), target: self)
        navigationItem.leftBarButtonItem = back
    }
    
    fileprivate func setupHeaderView() {
        
        headerView = TimeSelectionHeaderView()
        
        headerView.buttonFromTime.setTitle(dateTimeFormatter.string(from: Date(timeIntervalSince1970: fromTimeInput)), for: UIControlState())
        headerView.buttonToTime.setTitle(dateTimeFormatter.string(from: Date(timeIntervalSince1970: toTimeInput)), for: UIControlState())
        
        headerView.buttonFromTime.addTarget(self, action: #selector(self.buttonFrom(_:)), for: .touchUpInside)
        headerView.buttonToTime.addTarget(self, action: #selector(self.buttonTo(_:)), for: .touchUpInside)
        
    }
    
    fileprivate func setupDelegate() {
        
        datePickerView = DatePickerView()
        
        datePickerView.pickerView.dataSource = self
        datePickerView.pickerView.delegate = self
        
        
        datePickerView.calendar.animatorDelegate = self
        datePickerView.calendar.calendarAppearanceDelegate = self
        datePickerView.calendar.calendarDelegate = self
    }
    
    fileprivate func setupDatePickerView() {
        
        setupDelegate()
        date = Date(timeIntervalSince1970: fromTimeInput)
        setDateForDatePickerView(Date(timeIntervalSince1970: fromTimeInput), animation: true)
    }
    
    fileprivate func setupFooterView() {
        footerView = TimeSelectionFooterView()
        
        footerView.buttonRight.addTarget(self, action: #selector(self.confirm(_:)), for: .touchUpInside)
        footerView.buttonLeft.addTarget(self, action: #selector(self.cancel(_:)), for: .touchUpInside)
        
    }
}
