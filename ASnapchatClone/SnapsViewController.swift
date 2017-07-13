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
            let uuid = value?["uuid"] as? String ?? ""
            snap.key = snapshot.key
            snap.imageURL = imageURL
            snap.from = from
            snap.uuid = uuid
            print(snap.from)
            snap.descrip = descrip
            
            self.snaps.append(snap)
            self.tableView.reloadData()
        }
        
        Database.database().reference().child("Users").child(currentUser).child("snaps").observe(DataEventType.childRemoved) { (snapshot) in // Creates a read reference in the database.
            print(snapshot)
            var index = 0
            for snap in self.snaps {
                if snap.key == snapshot.key {
                    self.snaps.remove(at: index)
                }
                index += 1
                
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "viewSnapSegue", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSnapSegue"{
            let nextVC = segue.destination as! ViewSnapViewController
            nextVC.snap = sender as! Snap
        }
    }
    
    @IBAction func logoutTappedBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
