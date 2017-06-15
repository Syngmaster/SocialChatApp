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
import SwiftKeychainWrapper

class SMSignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: SMCustomTextField!
    @IBOutlet weak var passwordTextField: SMCustomTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                if let user = user {
                    let userData = ["provider" : credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
    

    @IBAction func signInAction(_ sender: UIButton) {
        
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("Syngmaster: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider" : user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("Syngmaster: Unable to authenticate with Firebase using email - \(error)")
                        } else {
                            print("Syngmaster: Successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider" : user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.sharedInstance.createFirebaseDBUser(uid: id, userData: userData)
        
        let result = KeychainWrapper.standard.set(id, forKey: "uid")
        print("Data saved - \(result)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

