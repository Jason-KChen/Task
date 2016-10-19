//
//  TaskCell.swift
//  Task
//
//  Created by Kun Chen on 10/19/16.
//  Copyright © 2016 Kun Chen. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var taskTypeImage: UIImageView!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDetails: UILabel!
    @IBOutlet weak var remainingDaysLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        taskTypeImage.layer.cornerRadius = 10
        taskTypeImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func constructNewTaskCellContent(taskName: String, details: String?, taskType: String, taskDueDate: Date) {
        
        var additionalTaskInfo: String
        
        if details != nil {
            additionalTaskInfo = details!
        } else {
            additionalTaskInfo = "No More Info"
        }
        
        taskTitle.text = taskName
        taskDetails.text = additionalTaskInfo
        taskTypeImage.image = UIImage(named: taskType)
        
        let remainingDays = calculateRemainingDays(date: taskDueDate)
        
        if remainingDays == 0 {
            remainingDaysLabel.text = "<1 Days"
        } else {
            remainingDaysLabel.text = "\(remainingDays) Days"
        }
        
        if remainingDays < 5 {
            remainingDaysLabel.textColor = UIColor.red
        }
        
        remainingDaysLabel.adjustsFontSizeToFitWidth = true 
    }
    
    //calculate days remaining for a task given its due date object
    func calculateRemainingDays(date: Date) -> Int {
        
        let unitFlags = Set<Calendar.Component>([.day, .hour])
        var days = NSCalendar.current.dateComponents(unitFlags, from: Date(), to: date)
        
        if days.day! <= 0 {
            return 0
        } else {
            return days.day!
        }
    }
}
