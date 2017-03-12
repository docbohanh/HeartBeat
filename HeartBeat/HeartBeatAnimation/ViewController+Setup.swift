//
//  ViewController+Setup.swift
//  HeartBeatAnimation
//
//  Created by MILIKET on 3/12/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import SnapKit

//--------------------------
//MARK: SETUP VIEW
//--------------------------
extension ViewController {
    func setupAllSubviews() {
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
        btAction = setupButtonAction()
        tableAction = setupTable()
        btTraining = setupButtonTraining()
        labelSkillRating = setupLabel()
        
        view.addSubview(btAction)
        view.addSubview(tableAction)
        view.addSubview(btTraining)
        view.addSubview(labelSkillRating)
        
    }
    
    func setupAllConstraints() {
        btAction.snp.makeConstraints { (make) in
            make.left.equalTo(dragAreaView.snp.left)
            make.bottom.equalTo(dragAreaView.snp.top).offset(-30)
            make.size.equalTo(CGSize(width: 130, height: 31))
        }
        
        tableAction.snp.makeConstraints { (make) in
            make.left.width.equalTo(btAction)
            make.top.equalTo(btAction.snp.bottom)
            make.height.equalTo(1 + Size.cell.rawValue * CGFloat(arrayAction.count))
        }
        
        btTraining.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(btAction)
            make.right.equalTo(dragAreaView.snp.right)
        }
        
        labelSkillRating.snp.makeConstraints { (make) in
            make.left.equalTo(dragAreaView.snp.left)
            make.width.equalTo(dragAreaView.snp.width)
            make.height.equalTo(btAction.snp.height)
            make.top.equalTo(dragAreaView.snp.bottom).offset(30)
        }
        
    }
    
    func setupButtonAction() -> UIButton {
        let button = UIButton()
        button.setTitle(arrayAction[0].name, for: UIControlState())
        button.setTitleColor(.darkGray, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 50)
        button.setBackgroundImage(Icon.General.button, for: UIControlState())
        button.addTarget(self, action: #selector(self.showTableAction(_:)), for: .touchUpInside)
        return button
    }
    
    func setupButtonTraining() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Train", for: UIControlState())
        button.setTitleColor(.darkGray, for: UIControlState.normal)
        button.setTitleColor(.white, for: UIControlState.highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.alpha(0.7).cgColor
        button.addTarget(self, action: #selector(self.trainingAction(_:)), for: .touchUpInside)
        
        return button
    }
    
    func setupLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Skill Rating: 0%"
        label.backgroundColor = .clear
        return label
    }
    
    func setupTable() -> UITableView {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.isHidden = true
        table.layer.cornerRadius = 3
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cellString")
        return table
    }
    
}
