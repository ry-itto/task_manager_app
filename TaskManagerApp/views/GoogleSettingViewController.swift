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
    
    @IBOutlet var calendarToggleSwitch: UISwitch?

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    @IBAction func signOutButtonDidTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
    }
}

extension GoogleSettingViewController: GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("error:: \(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("error:: \(error.localizedDescription)")
                return
            }
            // User is signed in
            // ...
        }
    }
}
