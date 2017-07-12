//
//  ViewController.swift
//  ASnapchatClone
//
//  Created by Thomas Houghton on 12/07/2017.
//  Copyright © 2017 Thomas Houghton. All rights reserved.
//

import UIKit
import Firebase // Import Firebase
import FirebaseAuth // Import Firebase Authorization.
import FirebaseDatabase // Import Firebase Database

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBAction func loginTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in // This is an attempt at signing in.
            print("We tried to sign in.")
            if error != nil {
                print("We have an error: \(error)")
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in // This creates a user.
                    print("We tried to create a user!")
                    if error != nil {
                        print("We have an error \(error)")
                    }else {
                        print("User has been created.")
                        let users = Database.database().reference().child("Users").child(user!.uid).child("email").setValue(user!.email!)
                        self.performSegue(withIdentifier: "signInSegue", sender: nil)
                    }
                })
                
            }else{
                print("Sign in successful")
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
        }
    }
}

