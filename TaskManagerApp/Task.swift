//
//  Task.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/01/11.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var dueDate: Date = Date()
    @objc dynamic var checked: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
