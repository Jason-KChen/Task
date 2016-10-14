//
//  AboutPageViewController.swift
//  Task
//
//  Created by Kun Chen on 10/12/16.
//  Copyright © 2016 Kun Chen. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController {

    @IBOutlet weak var testButton: UIButton!
    var longPressRecognizer: UILongPressGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressDetected))
        testButton.addGestureRecognizer(longPressRecognizer!)
    }
    
    @IBAction func BackBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func longPressDetected(sender: UILongPressGestureRecognizer?) {
        print("long press recognizer")
    }

}
