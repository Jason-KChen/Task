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

class addNewTaskViewController: UIViewController {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var navigationbar: UINavigationItem!
    
    var delegate: TaskConfigurationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        if delegate != nil && inputTextField.text != nil && inputTextField.text != "" {
            if let data = inputTextField.text {
                print(inputTextField.text)
                delegate?.userDidSetNewTask(input: data)
                dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func CancelPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
