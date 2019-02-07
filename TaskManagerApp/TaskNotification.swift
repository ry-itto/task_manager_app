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
    
    static func setNotification(_ task: Task) {
        
        let dateComponents: DateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: task.dueDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "指定日です。"
        content.subtitle = "\(task.title)"
        content.body = "\(task.content)"
        content.sound = UNNotificationSound.default
        
        let request: UNNotificationRequest = UNNotificationRequest(identifier: "onDayOfTask", content: content, trigger: trigger)
        
        let notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request, withCompletionHandler: { (error) in
            print("set notification")
        })
    }
}


