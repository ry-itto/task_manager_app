//
//  Category.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/01/25.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
