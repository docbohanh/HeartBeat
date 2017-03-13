//
//  ProfileViewController+Setup.swift
//  ManUNews
//
//  Created by MILIKET on 3/9/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import PHExtensions
import FBSDKLoginKit
import MXParallaxHeader

//-------------------------------------------
//MARK:    - SETUP VIEW
//-------------------------------------------
extension ProfileViewController {
    internal func setupAllSubview() {
        
        view.backgroundColor = UIColor.white
        title = "Cá nhân"
        
        back = setupBarButtonItem(Icon.Navi.back, selector: #selector(self.back(_:)))
        edit = setupBarButtonItem(Icon.Navi.edit, selector: #selector(self.edit(_:)))
        
        navigationItem.leftBarButtonItem = back
        navigationItem.rightBarButtonItem = edit
        
        loginFb = setupLoginButton()
        table = setupTable()
        
        headerView = setupHeaderView()
        
        table.parallaxHeader.view = headerView // You can set the parallax header view from the floating view
        table.parallaxHeader.height =  150
        table.parallaxHeader.mode = .fill
        table.parallaxHeader.minimumHeight = 64
        
        table.parallaxHeader.delegate = self
        
        view.addSubview(table)
        
        view.addSubview(loginFb)
        
    }
    
    func setupAllConstraints() {
        
        table.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        loginFb.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: view.frame.width * 2 / 3, height: 44))
            make.bottom.equalTo(view.snp.bottom).offset(-15)
        }
    }
    
    func setupHeaderView() -> ProfileHeaderTableView {
        let view = ProfileHeaderTableView()
        view.backgroundColor = UIColor.white
        view.avatarImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.changeAvatar(_:))))
                
        guard let url = URL(string: "") else { return view }
        let cache = URLCache.shared
        
        if let response = cache.cachedResponse(for: URLRequest(url: url)) {
            if let image = UIImage(data: response.data) {
                view.avatarImage.image = image
                
                return view
            }
        }
        
        let task = URLSession.shared.dataTask(with: url) { (responseData, responseUrl, error) -> Void in
            
            guard let data = responseData else { return }
            DispatchQueue.main.async(execute: { () -> Void in
                if let image = UIImage(data: data) {
                    view.avatarImage.image = image
                }
                let respond = CachedURLResponse(response: responseUrl ?? URLResponse(), data: data)
                cache.storeCachedResponse(respond, for: URLRequest(url: url))
                
            })
        }
        
        task.resume()
        
        return view
    }
    
    func setupLoginButton() -> FBSDKLoginButton {
        let loginFb = FBSDKLoginButton()
        loginFb.addTarget(self, action: #selector(self.loginFb(_:)), for: .touchUpInside)
        loginFb.delegate = self
        
        return loginFb
    }
    
    /**
     setup Notification Observer
     */
    func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /// Setup Bar Button
    fileprivate func setupBarButtonItem(_ image: UIImage, selector: Selector) -> UIBarButtonItem {
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
        button.tintColor = UIColor.white
        return button
    }
    
    /// Setup Table
    func setupTable() -> UITableView {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.backgroundColor = UIColor.white
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "Cell")
        table.keyboardDismissMode = .onDrag
        return table
    }
    
    /// Setup Scroll
    fileprivate func setupScroll() -> UIScrollView {
        let scroll = UIScrollView()
        scroll.delegate = self
        return scroll
    }
}

