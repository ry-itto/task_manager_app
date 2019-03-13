//
//  Notification.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/02/05.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import UserNotifications

class TaskNotification {
    
    private init() {}
    
    // ユーザに通知の許可をリクエストするメソッド
    static func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
            if error != nil {
                return
            }
            
            if granted {
                print("通知許可")
            } else {
                print("通知拒否")
            }
        })
    }
    
    // ローカル通知をセットするメソッド(タスク期日になったら通知)
    static func setNotification(_ task: Task) {
        
        let dateComponents: DateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: task.dueDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//        let trigger = TaskNotification.triggerForTest()
        
        let content = UNMutableNotificationContent()
        content.title = "指定日です。"
        content.subtitle = "\(task.title)"
        content.body = "\(task.content)"
        content.sound = UNNotificationSound.default
        
        let request: UNNotificationRequest = UNNotificationRequest(identifier: "\(task.title)", content: content, trigger: trigger)
        
        let notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request, withCompletionHandler: { (error) in
            if let error = error {
              fatalError("\(error)")
            }
            print("set notification")
        })
    }
    
    // 通知をセットした10秒後に発火するトリガーを作成します。
    private static func triggerForTest() -> UNTimeIntervalNotificationTrigger {
        // trigger
        let seconds = 10
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(seconds),
                                                                repeats: false)
        
        return trigger
    }
}


