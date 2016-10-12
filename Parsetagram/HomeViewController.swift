//
//  ViewController.swift
//  Parsetagram
//
//  Created by Jerry Tsui on 10/11/16.
//  Copyright © 2016 Jerry Tsui. All rights reserved.
//

import Parse
import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var btnLogout: UIButton!
    
    @IBAction func onLogout(_ sender: AnyObject) {
        PFUser.logOutInBackground { (error) in
            // PFUser.currentUser() will now be nil
            print("logging out!")
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.camera
            self.present(vc, animated: true, completion: nil)
        } else {
            print("there's no camera fuck")
        }
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onTakePicture(_ sender: AnyObject) {
      
    }
    
    private func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
}

