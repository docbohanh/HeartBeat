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
        case padding15 = 15, padding5 = 5, padding10 = 10, button = 44, cell = 30
    }
    
    /// VIEW
    var table: UITableView!
    
    var articleList: [Int] = []
    
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
    
}

//------------------------------
//MARK: PRIVATE METHOD
//------------------------------
extension ResultViewController {
    
}

//--------------------------------------
// - MARK: - TABLE DATASOURCE
//--------------------------------------
extension ResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func configCell() {
        
        
    }
}

//-------------------------------------------
// - MARK: - TABLE DELEGATE
//-------------------------------------------

extension ResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Size.cell..
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2 * onePixel()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.General.separator
        return view
    }
}

//------------------------------
//MARK: SETUP VIEW
//------------------------------
extension ResultViewController {
    func setupAllSubviews() {
        view.backgroundColor = UIColor.white
        title = "Kết quả"
        
    }
    
    func setupAllConstraints() {
        
    }
    
    func setupTableView() -> UITableView {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        return table
    }
    
}
