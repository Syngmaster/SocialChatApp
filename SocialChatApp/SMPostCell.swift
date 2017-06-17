//
//  SMPostCell.swift
//  SocialChatApp
//
//  Created by Syngmaster on 15/06/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

import UIKit
import Firebase

class SMPostCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        self.captionText.text = post.caption
        self.likesLabel.text = "\(post.likes)"
        
        if image != nil {
            self.postImage.image = image
        } else {
            let reference = FIRStorage.storage().reference(forURL: post.imageURL)
            reference.data(withMaxSize: 2 * 1024 * 1024, completion: {(data, error) in
                
                if error != nil {
                    print("Syngmaster: Unable to download from Firebase Storage")
                } else {
                    print("Syngmaster: Image downloaded from Firebase Storage")
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            self.postImage.image = image
                            SMFeedViewController.imageCache.setObject(image, forKey: post.imageURL as NSString)
                        }
                    }
                }
                
            })
            
        }
        
    }

}
