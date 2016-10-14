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
    
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
