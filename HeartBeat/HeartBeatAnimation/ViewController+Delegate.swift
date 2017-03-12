//
//  ViewController+Delegate.swift
//  HeartBeatAnimation
//
//  Created by MILIKET on 3/12/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit

//--------------------------------
//MARK: TABLE DATASOURCE DELEGATE
//--------------------------------
extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellString")
        
        let this = arrayAction[indexPath.row]
//        print("------> action | trained: \(this.name) | \(engineWidget.isActionTrained(this.action))")
        
        cell.textLabel?.text = this.name        
        
        cell.accessoryType = engineWidget.isActionTrained(this.action) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableAction.isHidden = true
        
        btAction.setTitle(arrayAction[indexPath.row].name, for: UIControlState())
        btAction.tag = indexPath.row
        
        let action = arrayAction[indexPath.row].action
        self.labelSkillRating.text = "Skill Rating: \(engineWidget.getSkillRating(action))%"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Size.cell.rawValue
    }
}

//--------------------------------
//MARK: ENGINE DELEGATE
//--------------------------------
extension ViewController: EngineWidgetDelegate {
    
    func emoStateUpdate(_ currentAction: MentalAction_t, power currentPower: Float) {
        currentAct = currentAction
        currentPow = CGFloat(currentPower)
        
    }
    
    func onMentalCommandTrainingStarted() {
        
    }
    
    func onMentalCommandTrainingCompleted() {
        isTraining = false
                
        print("---------> trained: \(currentAct) - \(engineWidget.isActionTrained(currentAct))")
        
        let alert = UIAlertController(title: "Training Completed", message: "Action was trained completed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.tableAction.reloadData()
        
    }
    
    func onMentalCommandTrainingSuccessed() {
        let alert = UIAlertController(title: "Training Successed", message: "Do you want to accept this training?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reject", style: .default, handler: { action in
            self.engineWidget.setTrainingControl(Mental_Reject)
        }))
        
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { action in
            self.engineWidget.setTrainingControl(Mental_Accept)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func onMentalCommandTrainingFailed() {
        isTraining = false;
    }
    
    func onMentalCommandTrainingDataErased() {
        let alert = UIAlertController(title: "Erase Completed", message: "Action was erased completed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.tableAction.reloadData()
    }
    
    func onMentalCommandTrainingRejected() {
        isTraining = false;
    }
    
    func onMentalCommandTrainingSignatureUpdated() {
        self.tableAction.reloadData()
    }
}
