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
        customT.setValue(newTask.frequency, forKey: "taskFrequency")
        customT.setValue(newTask.type, forKey: "taskType")
        
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
    
    //function which enables the user to delete a task and all of its local notifications in the future
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let center = UNUserNotificationCenter.current()
            let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let taskToBeDeleted = userCustomTasks[indexPath.row]
            
            center.removePendingNotificationRequests(withIdentifiers: [taskToBeDeleted.taskName!])
            getContext().delete(taskToBeDeleted)
            appDel.saveContext()

            fetchDataFromCoreData()
            tableView.reloadData()
        }
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
            let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            getContext().delete(task)
            appDel.saveContext()
        }
    }
    
    //function that allows the user to view the details of a task on click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedTask = userCustomTasks[indexPath.row]
        showDetailsOfACustomTask(selectedTask: selectedTask)
        
    }
    
    //function that generates a alert view with basic information about a given custom task
    func showDetailsOfACustomTask(selectedTask: UserCustomTask) {
        
        let taskDetailsAlertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
        taskDetailsAlertView.title = selectedTask.taskName
        
        let dateParsingFlags = Set<Calendar.Component>([.year, .day, .month])
        let parsedDateComponent = Calendar.current.dateComponents(dateParsingFlags, from: selectedTask.taskDueDate! as Date)
        
        var taskDetails = "Info: Not Available\n"
        var taskDueDate = "Due Date:"
        var taskType = "Type: ERROR\n"
        var reminderFreq = "Reminders: ERROR\n"
        
        if let year = parsedDateComponent.year, let month = parsedDateComponent.month, let day = parsedDateComponent.day {
            taskDueDate = taskDueDate + " \(month).\(day).\(year)\n"
        } else {
            taskDueDate = taskDueDate + " ERROR\n"
        }
        
        if let moreInfo = selectedTask.taskDetails {
            taskDetails = "Info: \(moreInfo)\n"
        }
        
        if let type = selectedTask.taskType {
            taskType = "Type: \(type)\n"
        }
        
        if let freq = selectedTask.taskFrequency {
            reminderFreq = "Reminders: \(freq)\n"
        }
        
        taskDetailsAlertView.message = taskType + taskDetails + taskDueDate + reminderFreq
        taskDetailsAlertView.addAction(UIAlertAction(title: "👀", style: .default, handler: nil))
        
        show(taskDetailsAlertView, sender: nil)
    }
}
