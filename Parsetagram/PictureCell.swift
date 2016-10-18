//
//  PictureCell.swift
//  Parsetagram
//
//  Created by Jerry Tsui on 10/13/16.
//  Copyright © 2016 Jerry Tsui. All rights reserved.
//

import UIKit

class PictureCell: UITableViewCell {
    
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var lblTimestamp: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblAuthor.font = UIFont(name: "HelveticaNeue-UltraLight", size: 20)
        lblCaption.font = UIFont(name: "HelveticaNeue-UltraLight", size: 20)
        lblTimestamp.font = UIFont(name: "HelveticaNeue-UltraLight", size: 14)
        userImage.layer.cornerRadius = 8
        userImage.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
