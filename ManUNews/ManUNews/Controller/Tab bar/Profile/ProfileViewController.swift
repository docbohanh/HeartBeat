//
//  ProfileViewController.swift
//  ManUNews
//
//  Created by MILIKET on 2/26/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//
import UIKit
import SnapKit
import PHExtensions
import CleanroomLogger
import FBSDKLoginKit

class ProfileViewController: GeneralViewController {
    fileprivate enum Size: CGFloat {
        case padding15 = 15, padding5 = 5, padding10 = 10, button = 44
    }
    
    fileprivate var loginFb: FBSDKLoginButton!
    
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
extension ProfileViewController {
    func loginFb(_ sender: UIButton) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
        
    }
    
}

//------------------------------
//MARK: PRIVATE METHOD
//------------------------------
extension ProfileViewController {
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    let dict = result as? [String : AnyObject]
                    
                    print(dict ?? "no data")
                }
            })
        }
    }
}

extension ProfileViewController: FBSDKLoginButtonDelegate {
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
        
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if ((error) != nil)
        {
            //handle error
        } else {
            returnUserData()
        }
    }
    
    func returnUserData() {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,interested_in,gender,birthday,email,age_range,name,picture.width(480).height(480)"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            }
            else {
                print("fetched user: \(result)")
            }
        })
    }
}

//------------------------------
//MARK: SETUP VIEW
//------------------------------
extension ProfileViewController {
    func setupAllSubviews() {
        view.backgroundColor = UIColor.white
        title = "Cá nhân"
        setupLoginButton()
    }
    
    func setupAllConstraints() {
        loginFb.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.size.equalTo(CGSize(width: view.frame.width / 2, height: 44))
        }
    }
    
    func setupLoginButton() {
        loginFb = FBSDKLoginButton()
        loginFb.addTarget(self, action: #selector(self.loginFb(_:)), for: .touchUpInside)
        loginFb.delegate = self
        view.addSubview(loginFb)
    }
}
