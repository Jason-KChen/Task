//
//  MainScreenViewController.swift
//  Task
//
//  Created by Kun Chen on 10/11/16.
//  Copyright © 2016 Kun Chen. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    //add title, left button and right button for navigation bar
    func setupNavigationBar() {
        navigationItem.title = "My Tasks"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        
        let infoBtn = UIButton(type: .infoLight)
        infoBtn.addTarget(self, action: #selector(goToAboutPage), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: infoBtn)
    }
    
    //perform segue to about page
    func goToAboutPage() {
        performSegue(withIdentifier: "goToAbout", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeued = tableView.dequeueReusableCell(withIdentifier: "Task", for: indexPath)
        return dequeued
    }
}
