//
//  CustomTask.swift
//  Task
//
//  Created by Kun Chen on 10/16/16.
//  Copyright © 2016 Kun Chen. All rights reserved.
//

import Foundation
import UserNotifications

class CustomTask {
    
    private var _taskName: String!
    private var _taskDetails: String?
    private var _taskType: String!
    private var _reminderFrequency: String!
    private var _dueDateYear: Int!
    private var _dueDateMonth: Int!
    private var _dueDateDay: Int!
    private var _notificationIdentifiers: [String] = []
    private var _frequencyConstant: Int!
    private var _dueDate: Date!
    
    var name: String {
        get {
            return _taskName
        }
    }
    
    var details: String? {
        get {
            if let info = _taskDetails {
                return info
            }
            return nil
        }
    }
    
    var type: String {
        get {
            return _taskType
        }
    }
    
    var frequency: String {
        get {
            return _reminderFrequency
        }
    }
    
    var arrayOfIdentifiers: [String] {
        get {
            return _notificationIdentifiers
        }
    }
    
    var dueDate: Date {
        get {
            return _dueDate
        }
    }
    
    init(newTaskName:String, newTaskDetails:String?, newTaskType: String, newTaskReminderFrequency: String, newTaskDueDate: [Int]) {
        
        _taskName = newTaskName
        _taskType = newTaskType
        _reminderFrequency = newTaskReminderFrequency
        _dueDateYear = newTaskDueDate[0]
        _dueDateMonth = newTaskDueDate[1]
        _dueDateDay = newTaskDueDate[2]
        
        if let additionalDetails = newTaskDetails {
            _taskDetails = additionalDetails
        }
        
        switch newTaskReminderFrequency {
            case "Everyday":
                _frequencyConstant = 1
                break
            case "Every Three Days":
                _frequencyConstant = 3
                break
            case "Every Week":
                _frequencyConstant = 7
                break
            default:
                _frequencyConstant = 0
                break
        }
        
        var dueDateComponent = DateComponents()
        dueDateComponent.year = _dueDateYear
        dueDateComponent.month = _dueDateMonth
        dueDateComponent.day = _dueDateDay
        
        _dueDate = Calendar.current.date(from: dueDateComponent)
    }
    
    func scheduleLocalNotifications() {
        
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Task Reminder ⏰"
        
        if let taskName = _taskName, let year = _dueDateYear, let month = _dueDateMonth, let day = _dueDateDay {
            content.body = "\(taskName) on \(month).\(day).\(year)"
        } else {
            content.body = ""
        }
        
        content.categoryIdentifier = "Task Reminder"
        content.sound = UNNotificationSound.default()
        
        var calendarTrigger: UNCalendarNotificationTrigger
        var request: UNNotificationRequest
        var dayDiff = calculateRemainingDays()
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour])
        var date = Date()
        var dateComponent = NSCalendar.current.dateComponents(unitFlags, from: date)
        date = Calendar.current.date(bySetting: .hour, value: 5, of: date)!
        
        while dayDiff >= _frequencyConstant {
            date = Calendar.current.date(byAdding: .day, value: _frequencyConstant, to: date)!
            dateComponent = Calendar.current.dateComponents(unitFlags, from: date)
            calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
            request = UNNotificationRequest(identifier: _taskName, content: content, trigger: calendarTrigger)
            center.add(request)
            print("[Task] Adding a local notification on \(dateComponent.month!).\(dateComponent.day!).\(dateComponent.year!) at \(dateComponent.hour!)")
            dayDiff = dayDiff - _frequencyConstant
        }
        
        dateComponent.year = _dueDateYear
        dateComponent.day = _dueDateDay
        dateComponent.month = _dueDateMonth
        dateComponent.hour = 5
        calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        request = UNNotificationRequest(identifier: _taskName, content: content, trigger: calendarTrigger)
        center.add(request)
        print("[Task] Adding a local notification on \(dateComponent.month!).\(dateComponent.day!).\(dateComponent.year!) at \(dateComponent.hour!)")
        
        print("[Task] Finish adding local notifications")
            
        //remove remaining notifications once task is deleted
        //give each notification an unique id
        //double check this method for corner cases
    }
    
    //returns the differences in days between current date and task due date
    func calculateRemainingDays() -> Int {
        
        var targetDayDC = DateComponents()
        targetDayDC.year = _dueDateYear
        targetDayDC.month = _dueDateMonth
        targetDayDC.day = _dueDateDay
        
        let targetDate = NSCalendar.current.date(from: targetDayDC)
        let unitFlags = Set<Calendar.Component>([.day, .hour])
        var days = NSCalendar.current.dateComponents(unitFlags, from: Date(), to: targetDate!)
        
        return days.day!
    }
}
