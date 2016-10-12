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

    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfUsername: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

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
                } else {
                    print(error.debugDescription)
                    //if error.code == 202 {
                      //  print("username is taken")
                    //}
                }
            
        }
    }
}
