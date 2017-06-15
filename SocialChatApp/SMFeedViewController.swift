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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Feeds"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }

    @IBAction func signOutAction(_ sender: UIButton) {
        
        KeychainWrapper.standard.removeObject(forKey: "uid")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "backToSignIn", sender: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell.init(style: <#T##UITableViewCellStyle#>, reuseIdentifier: <#T##String?#>)
        
    }
    
}
