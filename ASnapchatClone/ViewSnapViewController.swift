//
//  ViewSnapViewController.swift
//  ASnapchatClone
//
//  Created by Thomas Houghton on 13/07/2017.
//  Copyright © 2017 Thomas Houghton. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ViewSnapViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label.text = snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imageURL))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Goodbye.")
        let currentUser = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(currentUser!).child("snaps").child(snap.key).removeValue()
        Storage.storage().reference().child("\(snap.uuid).jpg").delete { (error) in
            print("We deleted a pic")
        }
    }
}

