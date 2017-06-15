//
//  SMPostCell.swift
//  SocialChatApp
//
//  Created by Syngmaster on 15/06/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

import UIKit

class SMPostCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
