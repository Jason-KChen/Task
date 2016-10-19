//
//  addNewTaskViewController.swift
//  Task
//
//  Created by Kun Chen on 10/11/16.
//  Copyright © 2016 Kun Chen. All rights reserved.
//

import UIKit
import UserNotifications

protocol TaskConfigurationDelegate {
    func userDidSetNewTask(newCustomTask: CustomTask)
}

class addNewTaskViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDetailsLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var pickADateLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var additionalDetails: UITextView!
    @IBOutlet weak var taskTypeBtn: newTaskPageButtons!
    @IBOutlet weak var reminderFrequencyBtn: newTaskPageButtons!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: TaskConfigurationDelegate?
    var longPressRecognizerForTaskType: UILongPressGestureRecognizer!
    var longPressRecognizerForReminderFrequency: UILongPressGestureRecognizer!
    var tapRecognizerForSubmitBtn: UITapGestureRecognizer!
    var actionSheetForTaskType: UIAlertController?
    var actionSheetForReminderFrequency: UIAlertController?
    
    var newTaskName: String?
    var newTaskDescription: String?
    var newTaskDueDate: [Int]?
    var newTaskType: String?
    var newTaskReminderFrequency: String?
    var defaultDate: String?
    var errorCodeArray: [Int] = []
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        inputTextField.delegate = self
        additionalDetails.delegate = self
        modifySomeUISettings()
        applyGestureRecognizers()
        configureDatePicker()
    }

    //Dismiss current viewController when Cancel Navigation Bar Button is pressed
    @IBAction func CancelPressed(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //Dismiss textField keyboard when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        inputTextField.resignFirstResponder()
        return false
    }
    
    //Replace existing text in textView with empty upon editing
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView.text == "Optional" {
            additionalDetails.text = ""
        }
        
        return true
    }
    
    //Dismiss textView keyboard when return is pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            if let taskDescription = textView.text {
                newTaskDescription = taskDescription
            }
            textView.endEditing(true)
            return false
        }
        return true
    }
    
    //Minor UI setting changes
    func modifySomeUISettings() {
        
        datePicker.backgroundColor = UIColor(red: 127 / 250, green: 127 / 250, blue: 127 / 250, alpha: 0.33)
        
        //modified return key on input text field and additional Details
        inputTextField.returnKeyType = .done
        additionalDetails.returnKeyType = .done
        
        //make sure text in label and buttons are fit to the width
        inputTextField.adjustsFontSizeToFitWidth = true
        reminderFrequencyBtn.titleLabel?.minimumScaleFactor = 0.75
        taskTypeBtn.titleLabel?.minimumScaleFactor = 0.75
        submitBtn.titleLabel?.minimumScaleFactor = 0.75
    }
    
    //set up gesture recognizers
    func applyGestureRecognizers() {
        
        longPressRecognizerForTaskType = UILongPressGestureRecognizer(target: self, action: #selector(taskTypeBtnGestureHandler(sender:)))
        longPressRecognizerForReminderFrequency = UILongPressGestureRecognizer(target: self, action: #selector(reminderFrequencyBtnGestureHandler(sender:)))
        tapRecognizerForSubmitBtn = UITapGestureRecognizer(target: self, action: #selector(submitBtnGestureHandler(sender:)))
        taskTypeBtn.addGestureRecognizer(longPressRecognizerForTaskType)
        reminderFrequencyBtn.addGestureRecognizer(longPressRecognizerForReminderFrequency)
        submitBtn.addGestureRecognizer(tapRecognizerForSubmitBtn)
    }
    
    //Gesture Handler for task type btn
    func taskTypeBtnGestureHandler(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            actionSheetForTaskType = UIAlertController(title: nil, message: "Select the type", preferredStyle: .actionSheet)
            actionSheetForTaskType?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheetForTaskType?.addAction(UIAlertAction(title: "Work", style: .default, handler: taskTypeActionSheetHandler(alertAction: )))
            actionSheetForTaskType?.addAction(UIAlertAction(title: "Life", style: .default, handler: taskTypeActionSheetHandler(alertAction: )))
            actionSheetForTaskType?.addAction(UIAlertAction(title: "School", style: .default, handler: taskTypeActionSheetHandler(alertAction: )))
            actionSheetForTaskType?.addAction(UIAlertAction(title: "Whatever", style: .default, handler: taskTypeActionSheetHandler(alertAction: )))
            
            present(actionSheetForTaskType!, animated: true, completion: nil)
        }
    }
    
    //Task Type Action Sheet Selection Handler
    func taskTypeActionSheetHandler(alertAction: UIAlertAction) {
        
        if let selectedOption = alertAction.title {
            newTaskType = selectedOption
            taskTypeBtn.setTitle(selectedOption, for: .normal)
        }
    }
    
    //Gesture Handler for reminder frequency button
    func reminderFrequencyBtnGestureHandler(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            actionSheetForReminderFrequency = UIAlertController(title: nil, message: "Choose a frequency", preferredStyle: .actionSheet)
            actionSheetForReminderFrequency?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheetForReminderFrequency?.addAction(UIAlertAction(title: "Everyday", style: .default, handler: reminderFrequencyActionSheetHandler(alertAction: )))
            actionSheetForReminderFrequency?.addAction(UIAlertAction(title: "Every Three Days", style: .default, handler: reminderFrequencyActionSheetHandler(alertAction: )))
            actionSheetForReminderFrequency?.addAction(UIAlertAction(title: "Every Week", style: .default, handler: reminderFrequencyActionSheetHandler(alertAction: )))
            actionSheetForReminderFrequency?.addAction(UIAlertAction(title: "No Reminder", style: .default, handler: reminderFrequencyActionSheetHandler(alertAction: )))
            
            present(actionSheetForReminderFrequency!, animated: true, completion: nil)
        }
    }
    
    //Reminder Frequency action sheet selection handler
    func reminderFrequencyActionSheetHandler(alertAction: UIAlertAction) {
        
        if let selectedFrequency = alertAction.title {
            newTaskReminderFrequency = selectedFrequency
            reminderFrequencyBtn.setTitle(selectedFrequency, for: .normal)
        }
    }
    
    //Gesture Handler for submit button
    func submitBtnGestureHandler(sender: UITapGestureRecognizer) {
        
        if(validateNewTaskInputs()) {
            checkLocalNotificationSetting()
        }
    }
    
    //validate all input for the new task
    func validateNewTaskInputs() -> Bool {
        
        //verify the name of the new task
        if let taskName = inputTextField.text {
            if taskName.characters.count > 0 {
                newTaskName = taskName
            } else {
                errorCodeArray.append(1)
            }
        } else {
            errorCodeArray.append(1)
        }
        
        //verify additional details regarding the task
        if let taskDetails = newTaskDescription {
            if taskDetails.characters.count > 0 {
                newTaskDescription = taskDetails
            }
        }
        
        //check if the type of the new task is set
        if newTaskType == nil {
            errorCodeArray.append(2)
        }
        
        //check if frequency is set
        if newTaskReminderFrequency == nil {
            errorCodeArray.append(3)
        }
        
        //verify selectedDate
        if newTaskDueDate == nil {
            errorCodeArray.append(4)
        }
        
        if errorCodeArray.count == 0 {
            return true
        } else {
            dialogBoxForInvalidInput()
            return false
        }
    }
    
    //initial date picker configuration
    func configureDatePicker() {
        
        datePicker.datePickerMode = .date
        datePicker.setDate(Date(timeIntervalSinceNow: 10), animated: false)
        datePicker.minimumDate = NSDate(timeIntervalSinceNow: 86400) as Date
        datePicker.maximumDate = NSDate(timeIntervalSinceNow: 31556926 * 3) as Date
        datePicker.addTarget(self, action: #selector(parseDate), for: .valueChanged)
        
        //provide a default time for new task
        defaultDate = datePicker.date.description
        parseDate()
    }
    
    //Parse the date selected by the user
    func parseDate() {
        
        let unparsedDate: String!
        if defaultDate != nil {
            unparsedDate = defaultDate
            defaultDate = nil
        } else {
            unparsedDate = datePicker.date.description
        }

        let range1 = unparsedDate.index(unparsedDate.startIndex, offsetBy: 0)...unparsedDate.index(unparsedDate.startIndex, offsetBy: 3)
        let range2 = unparsedDate.index(unparsedDate.startIndex, offsetBy: 5)...unparsedDate.index(unparsedDate.startIndex, offsetBy: 6)
        let range3 = unparsedDate.index(unparsedDate.startIndex, offsetBy: 8)...unparsedDate.index(unparsedDate.startIndex, offsetBy: 9)
            
        if let parsedYear = Int(unparsedDate[range1]), let parsedMonth = Int(unparsedDate[range2]), let parsedDay = Int(unparsedDate[range3]) {
            newTaskDueDate = [parsedYear, parsedMonth, parsedDay]
        } else {
            newTaskDueDate = nil
        }
    }
    
    //Dialog box for invalidate input
    func dialogBoxForInvalidInput() {
        
        if errorCodeArray.count != 0 {
            var errorMessage = ""
            for code in errorCodeArray {
                errorMessage = errorMessage + ErrorCodeDictionary.getErrorMessageByErrorCode(errorCode: code)
            }
            let dialogBox = UIAlertController(title: "😱 Error 😱", message: errorMessage, preferredStyle: .alert)
            dialogBox.addAction(UIAlertAction(title: "Let me check again 😒", style: UIAlertActionStyle.default, handler: nil))
            
            present(dialogBox, animated: true, completion: {
                self.errorCodeArray.removeAll()
            })
        }
    }
    
    //Check if local notification is enabled, if not set, prompt user, if declined, return false
    func checkLocalNotificationSetting() {
        
        let userSetting = UNUserNotificationCenter.current()
        
        userSetting.getNotificationSettings { (UNNotificationSettings) in
            if UNNotificationSettings.authorizationStatus == .notDetermined {
                userSetting.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (status, Error) in
                    if !status {
                        self.localNotificationNoPermissionAlert()
                    } else {
                        self.consolidateNewInfoTask()
                    }
                })
            }
            
            if UNNotificationSettings.authorizationStatus == .denied {
                self.localNotificationNoPermissionAlert()
            }
            
            if UNNotificationSettings.authorizationStatus == .authorized {
                self.consolidateNewInfoTask()
            }
        }
    }
    
    //present a dialog to user that local notification doesn't have permission
    func localNotificationNoPermissionAlert() {
        let noPermission = UIAlertController(title: "Something is wrong", message: "Well, can't remind you if I don't have the permission 😤", preferredStyle: .alert)
        noPermission.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(noPermission, animated: true, completion: nil)
    }
    
    //store the task info into an object and schedule the local notification
    func consolidateNewInfoTask() {
        
        let newTask = CustomTask(newTaskName: newTaskName!, newTaskDetails: newTaskDescription, newTaskType: newTaskType!, newTaskReminderFrequency: newTaskReminderFrequency!, newTaskDueDate: newTaskDueDate!)
        
        if newTask.frequency != "No Reminder" {
            newTask.scheduleLocalNotifications()
        } else {
            print("[Task] User chose to have no reminders")
        }
        
        //reminders are set, return to main screen
        delegate?.userDidSetNewTask(newCustomTask: newTask)
        dismiss(animated: true, completion: nil)
    }
}
