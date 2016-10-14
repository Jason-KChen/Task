//
//  addNewTaskViewController.swift
//  Task
//
//  Created by Kun Chen on 10/11/16.
//  Copyright © 2016 Kun Chen. All rights reserved.
//

import UIKit

protocol TaskConfigurationDelegate {
    func userDidSetNewTask(input: String)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.delegate = self
        additionalDetails.delegate = self
        modifySomeUISettings()
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        if delegate != nil && inputTextField.text != nil && inputTextField.text != "" {
            if let data = inputTextField.text {
                delegate?.userDidSetNewTask(input: data)
                dismiss(animated: true, completion: nil)
            }
        }
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
    //@IBAction func selectTaskTypeHolded
    
    
}
