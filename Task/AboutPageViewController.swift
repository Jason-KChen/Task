//
//  AboutPageViewController.swift
//  Task
//
//  Created by Kun Chen on 10/12/16.
//  Copyright © 2016 Kun Chen. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AboutPageViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //return to the main task page
    @IBAction func BackToMainView(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //returns the context of the app for fetching data
    func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
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
    
    //configure some cell to perform some actions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            print("[Task] GitHub selected")
            UIApplication.shared.open(URL(string: "https://github.com/KunFZ/Task")!, options: [:], completionHandler: nil)
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            print("[Task] Clear Data selected")
            resetUserCustomTaskInCoreData()
            removeAllPendingNotifications()
            print("[Task] Clear Core Data and removing all pending notifications done")
        }
        
        if indexPath.section == 3 && indexPath.row == 0 {
            print("[Task] Icons selected")
            presentAttributionAlertView()
        }
        
    }
    
    //remove all pending notifications scheduled in the phone
    func removeAllPendingNotifications() {
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    //present a alert view to attribute the authors of the icons
    func presentAttributionAlertView() {
        
        let message: String = "[Question Mark]\nIcon made by Daniel Bruce from www.flaticon.com\n[Dancer]\nIcon made by Freepik from www.flaticon.com\n[Briefcase]\nIcon made by Google from www.flaticon.com\n[Open Book]\nIcon made by Freepik from www.flaticon.com"
        
        let attributionAV = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        attributionAV.addAction(UIAlertAction(title: "Hmm", style: .default, handler: nil))
        
        present(attributionAV, animated: true, completion: nil)
    }
}
