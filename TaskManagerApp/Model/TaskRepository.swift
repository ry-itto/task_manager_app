//
//  TaskRepository.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/02/16.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RealmSwift

class TaskRepository {
    
    static let sharedInstance: TaskRepository = TaskRepository()
    
    let realm: Realm = RealmManager.sharedInstance.realm
    
    private init() { }
    
    // タスクを登録します。
    func createTask(title: String?, category: String?, content: String?, dueDate: Date?, checked: Bool?) {
        
        let numberOfTasks: Int = realm.objects(Task.self).count
        let task: Task = Task()
        task.id = numberOfTasks + 1
        task.title = title ?? ""
        task.category = category ?? ""
        task.content = content ?? ""
        task.dueDate = dueDate ?? Date()
        task.checked = checked ?? false
        
        do {
            try realm.write {
                realm.add(task)
            }
        } catch {
            fatalError("Failed: タスクDB登録処理に失敗")
        }
        
        createLocalNotificationAndGoogleEvent(task: task)
    }
    
    // タスクを更新します
    func updateTask(task: Task, title: String?, category: String?, content: String?, dueDate: Date?, checked: Bool?) {
        do {
            try realm.write {
                task.title = title ?? ""
                task.category = category ?? ""
                task.content = content ?? ""
                task.dueDate = dueDate ?? Date()
                task.checked = false
            }
        } catch {
            fatalError("Failed: タスクDB更新処理に失敗")
        }
        
        createLocalNotificationAndGoogleEvent(task: task)
    }
    
    func deleteTask(task: Task) {
        do {
            try realm.write {
                realm.delete(task)
            }
        } catch {
            fatalError("Failed: タスク削除処理に失敗")
        }
    }
    
    func findTask(primaryKey: Int) -> Task? {
        return realm.object(ofType: Task.self, forPrimaryKey: primaryKey)
    }
    
    func findAllTask() -> [Task] {
        return Array(realm.objects(Task.self))
    }
    
    // ローカル通知とGoogleカレンダーのイベントを登録します
    private func createLocalNotificationAndGoogleEvent(task: Task) {
        // ローカル通知登録
        TaskNotification.setNotification(task)
        
        if GoogleAPIClient.sharedInstance.isRegisterToCalendar {
            // Google Calendarにタスクに基づくイベント登録
            GoogleAPIClient.sharedInstance.addEventToGoogleCalendar(summary: task.title, description: task.content, targetDate: task.dueDate)
        }
    }
}
