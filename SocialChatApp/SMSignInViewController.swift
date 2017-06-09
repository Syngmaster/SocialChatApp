//
//  SMSignInViewController.swift
//  SocialChatApp
//
//  Created by Syngmaster on 08/06/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class SMSignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookSignInAction(_ sender: UIButton) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self){(result, error) in
            if error != nil {
                print("Syngmaster: Unable to authenticate with Facebook")
            } else if result?.isCancelled == true {
                print("Syngmaster: User cancelled Facebook authentication")
            } else {
                print("Syngmaster: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        
        }
        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Syngmaster: Unable to authenticate with Firebase - \(error)")
            } else {
                print("Syngmaster: Successfully authenticated with Firebase")
            }
        })
        
        
    }

}

