//
//  GoogleSettingViewController.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/02/09.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class GoogleSettingViewController: UIViewController {
    
    @IBOutlet var signInButton: GIDSignInButton?
    @IBOutlet var calendarToggleSwitch: UISwitch?
    @IBOutlet var output: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    @IBAction func signOutButtonDidTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
    }
}

extension GoogleSettingViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if let error = error {
            print("error:: \(error.localizedDescription)")
            return
        } else {
            self.signInButton?.isHidden = true
            self.output?.text = "\(user)"
        }
        
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        print("\(userId)")
        print("\(idToken)")
        print("\(fullName)")
        print("\(givenName)")
        print("\(familyName)")
        print("\(email)")
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("error:: \(error.localizedDescription)")
                return
            }
            self.output?.text = "\(authResult)"
        }
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        if let error = error {
            print("error:: \(error.localizedDescription)")
            return
        }
        self.output?.text = "user"
    }
}
