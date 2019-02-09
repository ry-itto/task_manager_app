//
//  GoogleAPIClient.swift
//  TaskManagerApp
//
//  Created by 伊藤凌也 on 2019/02/10.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

class GoogleAPIClient {
    
    static let sharedInstance: GoogleAPIClient = GoogleAPIClient()
    
    private init() {}
    
    let calendarService = GTLRCalendarService()
    var isRegisterToCalendar: Bool = true
    
    // 新規イベントをGoogle Calendarに作成する
    func addEventToGoogleCalendar(summary : String, description :String, targetDate : Date) {
        let calendarEvent = GTLRCalendar_Event()
        calendarEvent.summary = summary
        calendarEvent.descriptionProperty = description
        
        calendarEvent.start = dateToEventDateTime(date: targetDate)
        calendarEvent.end = dateToEventDateTime(date: targetDate)
        
        let insertQuery = GTLRCalendarQuery_EventsInsert.query(withObject: calendarEvent, calendarId: "primary")
        
        calendarService.executeQuery(insertQuery) { (ticket, object, error) in
            if let error = error {
                print("error at line#\(#line)")
                print("\(error.localizedDescription)")
            }
        }
    }
    
    // 日付型を専用の型に変換
    private func dateToEventDateTime(date: Date) -> GTLRCalendar_EventDateTime {
        let dateTime = GTLRDateTime(date: date)
        let eventDateTime = GTLRCalendar_EventDateTime()
        eventDateTime.dateTime = dateTime
        return eventDateTime
    }
}
