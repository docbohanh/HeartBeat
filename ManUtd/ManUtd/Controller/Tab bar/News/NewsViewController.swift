//
//  NewsViewController.swift
//  ManuNews
//
//  Created by Thành Lã on 2/21/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import SnapKit
import PHExtensions
import PagingMenuController

class NewsViewController: GeneralViewController {
    fileprivate enum Size: CGFloat {
        case padding15 = 15, padding5 = 5, padding10 = 10, button = 44
    }
    var didSetupContraints = false
    
    var segmentedHeaderView: SegmentedHeaderView!
    var selectedSegmentIndex: Int!
    
    fileprivate let segmentArray: [Segmented] = [
        Segmented(index: 0, title: "Tuần này", value: .fixedValue(7 * 24.hour)),
        Segmented(index: 1, title: "Tháng này", value: .fixedValue(30 * 24.hour)),
        Segmented(index: 2, title: "Khác", value: .rangeValue(0, 0))]
    
    
    /// PRIVATE
    fileprivate var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/yyyy"
        return formatter
    }()
    
    /// VIEW
    var table: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    var articleList: [Article] = []
    
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
        if !didSetupContraints {
            setupAllConstraints()
            didSetupContraints = true
        }
        
        super.updateViewConstraints()
    }
    
}

//------------------------------
//MARK: SELECTOR
//------------------------------
extension NewsViewController {
    func menu(_ sender: UIBarButtonItem) {
//        if let drawerController = navigationController?.parent as? KYDrawerController {
//            drawerController.setDrawerState(.opened, animated: true)
//        }
        
    }
    
    

}

//------------------------------
//MARK: SETUP VIEW
//------------------------------
extension NewsViewController {
    func setupAllSubviews() {
        view.backgroundColor = .white
        title = "Tin bóng đá"
        
        setupPagingMenuViewController()
        
        
    }
    
    func setupAllConstraints() {
        
    }
        
    ///
    fileprivate func setupLeftBarButton() {
        let left = setupBarButton(image: Icon.Navi.menu, selector: #selector(self.menu(_:)), target: self)
        navigationItem.leftBarButtonItem = left
    }
    
    ///
    func setupPagingMenuViewController() {
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
//        pagingMenuController.view.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 20)
        pagingMenuController.didMove(toParentViewController: self)
    }
    
}

private struct PagingMenuOptions: PagingMenuControllerCustomizable {
    private let news = ArticleViewController()
    private let videos = VideosViewController()
    
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        return [news, videos]
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        
        let bgColor: UIColor = .main
        
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        
        var focusMode: MenuFocusMode {
            return .underline(height: 3 * onePixel(), color: UIColor.red, horizontalPadding: 0, verticalPadding: 0)
        }
        
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem(title: "Tin tức"), MenuItem(title: "Videos")]
        }
        
        var backgroundColor: UIColor {
            return bgColor
        }
        
        var selectedBackgroundColor: UIColor {
            return bgColor
        }
        
        var height: CGFloat {
            return 30
            
        }
    }
    
    fileprivate struct MenuItem: MenuItemViewCustomizable {
        
        let title: String
        
        var displayMode: MenuItemDisplayMode {
            return MenuItemDisplayMode.text(
                title: MenuItemText(
                    text: title,
                    color: UIColor.white.alpha(0.7),
                    selectedColor: UIColor.white,
                    font: UIFont(name: FontType.latoSemibold.., size: FontSize.normal++)!,
                    selectedFont: UIFont(name: FontType.latoSemibold.., size: FontSize.normal++)!
                )
            )
        }
    }
    
}


