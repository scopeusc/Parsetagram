//
//  ViewController.swift
//  Parsetagram
//
//  Created by Jerry Tsui on 10/11/16.
//  Copyright © 2016 Jerry Tsui. All rights reserved.
//

import Parse
import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate{
    let btnFont = UIFont(name: "HelveticaNeue-UltraLight", size: 20)
    let vc = UIImagePickerController()
    var images : [PFObject] = []
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    @IBOutlet weak var tableView: UITableView!
    var selectedImage: UIImage?
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
        self.loadImages()
        
        vc.delegate = self;
        self.tableView.dataSource = self
        
        
        btnLogout.titleLabel!.font = self.btnFont
        btnSelectPhoto.titleLabel!.font = self.btnFont
        btnTakePhoto.titleLabel!.font = self.btnFont
        lblTitle.font = UIFont(name: "HelveticaNeue-UltraLight", size: 32)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
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
    
    func loadImages(){
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts, error) -> Void in
            if let posts = posts {
                self.images = posts
                print(self.images)
                self.loadingMoreView!.stopAnimating()
                self.tableView.reloadData()
            } else {
                // handle error
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath) as! PictureCell
        print(indexPath.row)
        //print(images)
        let post = images[indexPath.row]
        
        let user = post["author"] as! PFUser
        let author = user.username
        let caption = post["caption"] as! String
        let imagePFFile = post["media"] as! PFFile
        let likes = post["likesCount"] as! NSNumber
        
        imagePFFile.getDataInBackground(block: {
                (imageData, error) -> Void in
                if (error == nil) {
                    let image = UIImage(data:imageData!)
                    cell.userImage.image = image
                }
        })
        
        
        cell.lblCaption.text = caption
        cell.lblTimestamp.text = "Likes: \(likes)"
        cell.lblAuthor.text = author
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return images.count
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadImages()
        print("refreshing images")
        refreshControl.endRefreshing()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadImages()
                self.isMoreDataLoading = false;
            }
        }
    }
    
    class InfiniteScrollActivityView: UIView {
        var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        static let defaultHeight:CGFloat = 60.0
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupActivityIndicator()
        }
        
        override init(frame aRect: CGRect) {
            super.init(frame: aRect)
            setupActivityIndicator()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        }
        
        func setupActivityIndicator() {
            activityIndicatorView.activityIndicatorViewStyle = .gray
            activityIndicatorView.hidesWhenStopped = true
            self.addSubview(activityIndicatorView)
        }
        
        func stopAnimating() {
            self.activityIndicatorView.stopAnimating()
            self.isHidden = true
        }
        
        
        func startAnimating() {
            self.isHidden = false
            self.activityIndicatorView.startAnimating()
        }
    }
}

