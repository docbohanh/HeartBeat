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
    
    var results: [Team] = [Team(orderType: .normal,
                                order: 1,
                                logo: Icon.Logo.chelsea,
                                teamName: "Chelsea",
                                matched: 26,
                                goals: "55:19",
                                difference: 36,
                                score: 63),
                           Team(orderType: .normal,
                                order: 2,
                                logo: Icon.Logo.tottenham,
                                teamName: "Tottenham",
                                matched: 26,
                                goals: "55:18",
                                difference: 32,
                                score: 53),
                           Team(orderType: .descend,
                                order: 4,
                                logo: Icon.Logo.manCity,
                                teamName: "Manchester City",
                                matched: 25,
                                goals: "51:29",
                                difference: 22,
                                score: 52),
                           Team(orderType: .descend,
                                order: 5,
                                logo: Icon.Logo.arsenal,
                                teamName: "Arsenal",
                                matched: 26,
                                goals: "55:31",
                                difference: 24,
                                score: 50),
                           Team(orderType: .ascend,
                                order: 3,
                                logo: Icon.Logo.liverpool,
                                teamName: "Liverpool",
                                matched: 27,
                                goals: "58:34",
                                difference: 24,
                                score: 52),
                           Team(orderType: .normal,
                                order: 6,
                                logo: Icon.Logo.manu,
                                teamName: "Manchester Utd",
                                matched: 26,
                                goals: "39:22",
                                difference: 17,
                                score: 49),
                           Team(orderType: .normal,
                                order: 7,
                                logo: Icon.Logo.everton,
                                teamName: "Everton",
                                matched: 26,
                                goals: "42:27",
                                difference: 15,
                                score: 44)
                           ]
        .sorted { $0.order < $1.order }
    
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
        
        let team = results[indexPath.row]
        
        if indexPath.row == results.count - 1 {
            cell.seperatorRightPadding = 0
            cell.seperatorStyle = .padding(0)
            
        } else {
            cell.seperatorRightPadding = 10
            cell.seperatorStyle = .padding(10)
        }
        
        cell.orderIcon.image = team.orderType.icon
        cell.order.text = String(team.order)
        cell.logo.image = team.logo
        cell.teamName.text = team.teamName
        cell.matched.text = String(team.matched)
        cell.goals.text = team.goals
        cell.difference.text = String(team.difference)
        cell.score.text = String(team.score)
        
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
