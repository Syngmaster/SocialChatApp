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
    @IBOutlet weak var likeImage: UIImageView!

    var post: Post!
    var likesReference: FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()

        let tap = UITapGestureRecognizer(target: self, action: #selector(likeAction))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        
        self.post = post
        likesReference = DataService.sharedInstance.REF_USER_CURRENT.child("likes").child(post.postID)
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
        
        likesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "empty-heart")
            } else {
                self.likeImage.image = UIImage(named: "filled-heart")
            }
            
        })
    }

    
    func likeAction(sender: UITapGestureRecognizer) {
        var likesReference = DataService.sharedInstance.REF_USER_CURRENT.child("likes")
        likesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesReference.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesReference.removeValue()
            }
            
        })
    }
    
}
