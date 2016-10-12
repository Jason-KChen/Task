//
//  MainScreenViewController.swift
//  Task
//
//  Created by Kun Chen on 10/11/16.
//  Copyright © 2016 Kun Chen. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskConfigurationDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBar()
    }
    
    //add title, left button and right button for navigation bar
    func setupNavigationBar() {
        
        navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        tableView.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60)
        
        let navItems = UINavigationItem(title: "My Tasks")
        navItems.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddANewTaskPage)), animated: false)
        
        let infoBtn = UIButton(type: .infoDark)
        infoBtn.addTarget(self, action: #selector(goToAboutPage), for: .touchUpInside)
        navItems.leftBarButtonItem = UIBarButtonItem(customView: infoBtn)
        
        navigationBar.setItems([navItems], animated: false)
    }
    
    //perform segue to about page
    func goToAboutPage() {
        performSegue(withIdentifier: "goToAbout", sender: nil)
    }
    
    //perform segue to add a new task page
    func goToAddANewTaskPage() {
        performSegue(withIdentifier: "AddNewTask", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeued = tableView.dequeueReusableCell(withIdentifier: "Task", for: indexPath)
        
        if indexPath.row == 0 {
            dequeued.textLabel?.text = "Hello World"
        }
        if indexPath.row == 1 {
            dequeued.textLabel?.text = "Goodbye World"
        }
        return dequeued
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewTask" {
            if let nextVCb = segue.destination as? addNewTaskViewController {
                nextVCb.delegate = self
            }
        }
    }
    
    func userDidSetNewTask(input: String) {
        print(input)
    }
}
