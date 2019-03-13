//
//  Realm.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/02/16.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let sharedInstance: RealmManager = RealmManager()
    
    let realm: Realm
    
    private init() {
        let config = Realm.Configuration(schemaVersion: 4)
        Realm.Configuration.defaultConfiguration = config
        // Realm初期化，Realmファイルへのパスを標準出力
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed: initialize realm")
        }
    }
}
