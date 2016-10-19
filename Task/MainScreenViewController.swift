//
//  MainScreenViewController.swift
//  Task
//
//  Created by Kun Chen on 10/11/16.
//  Copyright © 2016 Kun Chen. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class MainScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskConfigurationDelegate {
    
    var userCustomTasks: [UserCustomTask] = []
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBarBtns()
        //debugAndReseting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        fetchDataFromCoreData()
        tableView.reloadData()
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
        return userCustomTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentTask = userCustomTasks[indexPath.row]
        
        if let dequeued = tableView.dequeueReusableCell(withIdentifier: "Task") as? TaskCell {
            
            if let taskDetails = currentTask.taskDetails {
                dequeued.constructNewTaskCellContent(taskName: currentTask.taskName!, details: taskDetails, taskType: currentTask.taskType!, taskDueDate: currentTask.taskDueDate! as Date)
            } else {
                dequeued.constructNewTaskCellContent(taskName: currentTask.taskName!, details: nil, taskType: currentTask.taskType!, taskDueDate: currentTask.taskDueDate! as Date)
            }
            
            return dequeued
        } else {
            return TaskCell()
        }
    }
    
    //segue transition function for conforming the next view to the protocol
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewTask" {
            if let nextVC = segue.destination as? addNewTaskViewController {
                nextVC.delegate = self
            }
        }
    }
    
    //returns the context of the app for fetching data
    func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //implementing protocol function
    func userDidSetNewTask(newCustomTask newTask: CustomTask) {
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "UserCustomTask", in: context)
        let customT = NSManagedObject(entity: entity!, insertInto: context)
        
        customT.setValue(newTask.name, forKey: "taskName")
        customT.setValue(newTask.type, forKey: "taskType")
        customT.setValue(newTask.dueDate, forKey: "taskDueDate")
        
        if let detailInfo = newTask.details {
            customT.setValue(detailInfo, forKey: "taskDetails")
        }
        
        do {
            try context.save()
            print("[Task] \(newTask.name) is saved")
        } catch {
            print(error)
        }
    }
    
    //fetch the data from core data and and assign the list to userCustomTasks
    func fetchDataFromCoreData() {
        
        let fetchRequest: NSFetchRequest<UserCustomTask> = UserCustomTask.fetchRequest()
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "taskDueDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            userCustomTasks = try getContext().fetch(fetchRequest)
            print("[Task] CoreData has \(userCustomTasks.count) elements")
        } catch {
            print(error)
        }
    }
    
    //function for starting, reset data in core data, remove all pending notification
    func debugAndReseting() {
        
        removeAllPendingNotifications()
        resetUserCustomTaskInCoreData()
    }
    
    //remove all pending notifications scheduled in the phone
    func removeAllPendingNotifications() {
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    //reset coredata information under UserCustomTask
    func resetUserCustomTaskInCoreData() {
        
        let fetchRequest: NSFetchRequest<UserCustomTask> = UserCustomTask.fetchRequest()
        var arrayForDeletion: [UserCustomTask] = []
        do {
            arrayForDeletion = try getContext().fetch(fetchRequest)
        } catch {
            print("[Task] Try to set array for deletion failed \(error)")
        }
        
        for task in arrayForDeletion {
            getContext().delete(task)
        }
    }
}
