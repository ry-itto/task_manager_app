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
    @IBOutlet var calendarSwitch: UISwitch?
    
    let service = GoogleAPIClient.sharedInstance.calendarService
    
    // Calendarの読み書き込み許可をリクエストするスコープ
    private let scopes = [kGTLRAuthScopeCalendar]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        // Google認証の際にアクセスを許可してもらうスコープを設定
        GIDSignIn.sharedInstance()?.scopes = scopes
    }
    
    // ログインしたGoogleアカウントをサインアウトする
    @IBAction func signOutButtonDidTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        self.signInButton?.isHidden = false
    }
    
    // カレンダーに登録するかのスイッチが押された時のイベント
    @IBAction func calendarSwitchDidToggled(_ sender: UISwitch) {
        GoogleAPIClient.sharedInstance.isRegisterToCalendar = sender.isOn
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
