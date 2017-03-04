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
import MXParallaxHeader

class ResultViewController: GeneralViewController {
    fileprivate enum Size: CGFloat {
        case padding15 = 15, padding5 = 5, padding10 = 10, button = 44, cell = 30
    }
    
    /// VIEW
    var tableView: UITableView!
    
    var results: [Int] = [1,2,3,4,5]
    
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
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.resultIdentifier, for: indexPath) as! ResultTableViewCell
        
        configCell(for: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configCell(for cell: ResultTableViewCell, atIndexPath indexPath: IndexPath) {
        
        cell.seperatorRightPadding = 0
        cell.seperatorStyle = (indexPath.row == results.count - 1) ? .padding(0) : .padding(15)
                
        cell.order.text = results[indexPath.row].description
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
    
    
}

// MARK: - Parallax header delegate
extension ResultViewController: MXParallaxHeaderDelegate {
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        NSLog("progress %f", parallaxHeader.progress)
    }
}

//------------------------------
//MARK: SETUP VIEW
//------------------------------
extension ResultViewController {
    func setupAllSubviews() {
        view.backgroundColor = UIColor.white
        title = "Kết quả"
        
        tableView = setupTableView()
        
        view.addSubview(tableView)
        
    }
    
    func setupAllConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func setupTableView() -> UITableView {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.resultIdentifier)
        
        let headerView = setupHeaderView()
        tableView.parallaxHeader.view = headerView // You can set the parallax header view from the floating view
        tableView.parallaxHeader.height =  Size.cell..
        tableView.parallaxHeader.mode = .fill
        tableView.parallaxHeader.minimumHeight = 64
        
        tableView.parallaxHeader.delegate = self
        
        return tableView
    }
    
    func setupHeaderView() -> HeaderResultTableView {
        let view = HeaderResultTableView()
        view.backgroundColor = UIColor.white
        return view
    }
    
}
