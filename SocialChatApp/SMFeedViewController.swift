//
//  SMFeedViewController.swift
//  SocialChatApp
//
//  Created by Syngmaster on 12/06/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class SMFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: SMCustomCircleImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Feeds"
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.sharedInstance.REF_POSTS.observe(.value, with: {(snapshot) in
            
            self.posts = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP:\(snap)")
                    if let postDict = snap.value as? Dictionary <String, Any> {
                        let key = snap.key
                        let post = Post(postID: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
    }

    @IBAction func signOutAction(_ sender: UIButton) {
        
        KeychainWrapper.standard.removeObject(forKey: "uid")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "backToSignIn", sender: nil)
        
    }
    
    @IBAction func addImageAction(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func postAction(_ sender: SMCustomButton) {
        guard let caption = captionTextField.text, caption != "" else {
            print("Syngmaster: Caption must be entered")
            return
        }
        
        guard let image = addImage.image, imageSelected == true else {
            print("Syngmaster: An image must be selected")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            
            let imageUID = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.sharedInstance.REF_POST_IMAGES.child(imageUID).put(imageData, metadata: metadata) { (metadata, error) in
                
                if error != nil {
                    print("Syngmaster: Unable to upload image to FIRStorage")
                } else {
                    print("Syngmaster: Image successfully uploaded")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                }
            }
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image
            imageSelected = true
        } else {
            print("Invalid photo is chosen!")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return posts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]

        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SMPostCell {
            
            
            if let image = SMFeedViewController.imageCache.object(forKey: post.imageURL as NSString) {
                cell.configureCell(post: post, image: image)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
            

        } else {
            return SMPostCell()
        }

    }
    
}
