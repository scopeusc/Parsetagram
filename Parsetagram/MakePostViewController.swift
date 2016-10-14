//
//  MakePostViewController.swift
//  Parsetagram
//
//  Created by Jerry Tsui on 10/13/16.
//  Copyright © 2016 Jerry Tsui. All rights reserved.
//

import UIKit

class MakePostViewController: UIViewController {
    let font = UIFont(name: "HelveticaNeue-UltraLight", size: 20)
    var img : UIImage?
    @IBOutlet weak var lblCreatePost: UILabel!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var tfCaption: UITextField!
    @IBOutlet weak var selectedImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblCreatePost.font = self.font
        lblCaption.font = self.font
        tfCaption.font = self.font
        prepareImage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareImage(){
        self.selectedImage.image = self.img
        self.selectedImage.layer.cornerRadius = 10.0;
        self.selectedImage.clipsToBounds = true
    }
    
    @IBAction func onPost(_ sender: AnyObject) {
        
        if tfCaption.text == "" || tfCaption.text == nil {
            let alertVC = UIAlertController(
                title: "Blank Caption",
                message: "Please enter a caption",
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
        } else {
            let scaledImage = resize(image: img!, newSize: CGSize(width: 250, height: 250))
            Post.postUserImage(image: scaledImage, withCaption: tfCaption.text) {(succeeded, error) -> Void in
                    if succeeded {
                        print("successfully uploaded")
                        
                        
                    } else {
                        print("upload unsuccessful")
                    }
                }
        }
        
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x:0, y:0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
