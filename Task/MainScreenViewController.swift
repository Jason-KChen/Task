//
//  MainScreenViewController.swift
//  Task
//
//  Created by Kun Chen on 10/11/16.
//  Copyright © 2016 Kun Chen. All rights reserved.
//

import UIKit
import CoreData

class MainScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskConfigurationDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBarBtns()
    }
    
    //add title, left button and right button for navigation bar
    func setupNavigationBarBtns() {
        
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeued = tableView.dequeueReusableCell(withIdentifier: "Task")
        
        if indexPath.row == 0 {
            dequeued!.textLabel?.text = "Hello World"
        }
        if indexPath.row == 1 {
            dequeued!.textLabel?.text = "Goodbye World"
        }
        return dequeued!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewTask" {
            if let nextVC = segue.destination as? addNewTaskViewController {
                nextVC.delegate = self
            }
        }
    }
    
    func getContext() -> NSManagedObject {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func userDidSetNewTask() {

        print("Hello")
    }
}
