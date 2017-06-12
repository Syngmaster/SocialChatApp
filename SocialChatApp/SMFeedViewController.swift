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

class SMFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Feeds"
        
    }

    @IBAction func signOutAction(_ sender: UIButton) {
        
        KeychainWrapper.standard.removeObject(forKey: "uid")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "backToSignIn", sender: nil)
        
    }
}
