//
//  SelectUserViewController.swift
//  ASnapchatClone
//
//  Created by Thomas Houghton on 12/07/2017.
//  Copyright © 2017 Thomas Houghton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SelectUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var users:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        Database.database().reference().child("Users").observe(DataEventType.childAdded) { (snapshot) in
            print(snapshot)
            // Get user email:
            let user = User()
            let value = snapshot.value as? NSDictionary
            let userEmail = value?["email"] as? String ?? ""
            user.email = userEmail
            print(" I think we have the user email: \(user.email)!")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        cell.textLabel?.text = user.email
        return cell
    }
}
