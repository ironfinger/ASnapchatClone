//
//  SelectUserViewController.swift
//  ASnapchatClone
//
//  Created by Thomas Houghton on 12/07/2017.
//  Copyright © 2017 Thomas Houghton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SelectUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var users:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        Database.database().reference().child("Users").observe(DataEventType.childAdded) { (snapshot) in // Creates a read reference in the database.
            print(snapshot)
            // Get user email:
            let user = User() // Creates a new user object.
            let userID = Auth.auth().currentUser?.uid // Fetch the user ID.
            let value = snapshot.value as? NSDictionary // Lets the compiler know that the user values are a NSDictionary.
            let userEmail = value?["email"] as? String ?? "" // Pulls an email as a string.
            user.email = userEmail // Asigns the email pulled from the database to a new object.
            user.uid = userID! // Asigns the userID to the new user object.
            print(" I think we have the user email: \(user.email)!")
            print("Hopefully we have the user uid: \(user.uid)!")
            self.users.append(user) // Assign the new user object to the users array.
            self.tableView.reloadData() // Reload to table view.
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
