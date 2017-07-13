//
//  SnapsViewController.swift
//  ASnapchatClone
//
//  Created by Thomas Houghton on 12/07/2017.
//  Copyright © 2017 Thomas Houghton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SnapsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var snaps : [Snap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        let currentUser = Auth.auth().currentUser!.uid
        Database.database().reference().child("Users").child(currentUser).child("snaps").observe(DataEventType.childAdded) { (snapshot) in // Creates a read reference in the database.
            print(snapshot)
            let snap = Snap()
            let value = snapshot.value as? NSDictionary
            let imageURL = value?["imageURL"] as? String ?? ""
            let from = value?["from"] as? String ?? ""
            let descrip = value?["description"] as? String ?? ""
            snap.imageURL = imageURL
            snap.from = from
            print(snap.from)
            snap.descrip = descrip
            
            self.snaps.append(snap)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("The amount of snaps: \(snaps.count)")
        return snaps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let snap = snaps[indexPath.row]
        cell.textLabel?.text = snap.from
        return cell
    }
    
    @IBAction func logoutTappedBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
