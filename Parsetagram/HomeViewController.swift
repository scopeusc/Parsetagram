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
    let btnFont = UIFont(name: "HelveticaNeue-UltraLight", size: 20)
    let vc = UIImagePickerController()
    
    var selectedImage: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSelectPhoto: UIButton!
    @IBOutlet weak var btnTakePhoto: UIButton!
    @IBAction func onLogout(_ sender: AnyObject) {
        PFUser.logOutInBackground { (error) in
            // PFUser.currentUser() will now be nil
            print("logging out!")
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        vc.delegate = self;
        btnLogout.titleLabel!.font = self.btnFont
        btnSelectPhoto.titleLabel!.font = self.btnFont
        btnTakePhoto.titleLabel!.font = self.btnFont
        lblTitle.font = UIFont(name: "HelveticaNeue-UltraLight", size: 32)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTakePicture(_ sender: AnyObject) {
        print("Opening photo library")
        vc.allowsEditing = false
        vc.sourceType = .photoLibrary
        vc.modalPresentationStyle = .popover
        vc.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        //present(vc, animated: true, completion: nil)
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    @IBAction func takePhoto(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.camera
            self.present(vc, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
   
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            self.selectedImage = pickedImage
        }
        dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "postSegue", sender: self)
       
    }
   
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue")
       
       
        if segue.identifier == "postSegue" {
            let destination = segue.destination as! MakePostViewController
            print(self.selectedImage)
            destination.img = self.selectedImage
            print("setting image")
        }
    }
    
   
}

