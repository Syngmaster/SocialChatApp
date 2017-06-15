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

class SMFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Feeds"
        tableView.delegate = self
        tableView.dataSource = self
        
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return posts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        print("\(post.caption)")
        
        return tableView.dequeueReusableCell(withIdentifier: "Cell") as! SMPostCell
    }
    
}
