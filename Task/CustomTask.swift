//
//  CustomTask.swift
//  Task
//
//  Created by Kun Chen on 10/16/16.
//  Copyright © 2016 Kun Chen. All rights reserved.
//

import Foundation

class CustomTask {
    
    private var _taskName: String!
    private var _taskDetails: String?
    private var _taskType: String!
    private var _reminderFrequency: String!
    private var _dueDateYear: Int!
    private var _dueDateMonth: Int!
    private var _dueDateDay: Int!
    
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
    }
}
