//
//  CategoryRepository.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/02/16.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryRepository {
    
    static let sharedInstance: CategoryRepository = CategoryRepository()
    
    let realm: Realm = RealmManager.sharedInstance.realm
    
    private init() { }
    
    // カテゴリーを作成します
    func createCategory(name: String) {
        let category: Category = Category()
        let numberOfCategory: Int = realm.objects(Category.self).count
        category.id = numberOfCategory + 1
        category.name = name
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            fatalError("Failed: カテゴリーのDB登録処理に失敗")
        }
    }
}
