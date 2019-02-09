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
import GoogleAPIClientForREST

class GoogleSettingViewController: UIViewController {
    
    @IBOutlet var signInButton: GIDSignInButton?
    @IBOutlet var calendarToggleSwitch: UISwitch?
    
    let service = GoogleAPIClient.sharedInstance.calendarService
    private let scopes = [kGTLRAuthScopeCalendar]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.scopes = scopes
    }
    
    @IBAction func signOutButtonDidTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        self.signInButton?.isHidden = false
    }
}

extension GoogleSettingViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if let error = error {
            print("error:: \(error.localizedDescription)")
            return
        } else {
            self.signInButton?.isHidden = true
            service.authorizer = user.authentication.fetcherAuthorizer()
        }
    }
}
