//
//  SecondViewController.swift
//  AlexaClientDemo
//
//  Created by Rofi Uddin on 7/11/17.
//  Copyright © 2017 Rofi Uddin. All rights reserved.
//

import UIKit
import LoginWithAmazon

class SecondViewController: UIViewController, AIAuthenticationDelegate {
    @IBOutlet weak var loginWithAmazonBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!

    let lwa = LoginWithAmazonProxy.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onClickLoginWithAmazonBtn(_ sender: Any) {
        lwa.login(delegate: self)
    }
    
    @IBAction func onClickLogoutBtn(_ sender: Any) {
        lwa.logout(delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func requestDidSucceed(_ apiResult: APIResult) {
        switch(apiResult.api) {
        case API.authorizeUser:
            print("Authorized")
            lwa.getAccessToken(delegate: self)
        case API.getAccessToken:
            print("Login successfully!")
            LoginWithAmazonToken.sharedInstance.loginWithAmazonToken = apiResult.result as! String?
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "FirstViewController")
            self.present(controller, animated: true, completion: nil)
        case API.clearAuthorizationState:
            print("Logout successfully!")
        default:
            return
        }
    }
    
    func requestDidFail(_ errorResponse: APIError) {
        print("Error: \(errorResponse.error.message)")
    }
}

