//
//  LoginViewController.swift
//  Parsetagram
//
//  Created by Jerry Tsui on 10/11/16.
//  Copyright © 2016 Jerry Tsui. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    let font = UIFont(name: "HelveticaNeue-UltraLight", size: 20)
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfPassword.font = self.font
        tfUsername.font = self.font
        logo.image = UIImage(named: "CameraIcon")
        btnLogin.titleLabel!.font = self.font
        btnSignUp.titleLabel!.font = self.font
        lblTitle.font = UIFont(name: "HelveticaNeue-Light", size: 36)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogin(_ sender: AnyObject) {
        PFUser.logInWithUsername(inBackground: tfUsername.text!, password: tfPassword.text!) { (user, error) -> Void in
            if user != nil {
                print("successful login!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    @IBAction func onSignUp(_ sender: AnyObject) {
        let newUser = PFUser()
        newUser.username = tfUsername.text
        newUser.password = tfPassword.text
        newUser.signUpInBackground { (succeeded,
            error) -> Void in
            
                if succeeded {
                    print("yay success")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                } else {
                    print(error.debugDescription)
                    //if error.code == 202 {
                      //  print("username is taken")
                    //}
                }
            
        }
    }
}
