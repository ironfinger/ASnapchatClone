//
//  PictureViewController.swift
//  ASnapchatClone
//
//  Created by Thomas Houghton on 12/07/2017.
//  Copyright © 2017 Thomas Houghton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }

    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        nextBtn.isEnabled = false // We disable the button so the user doesn't upload more than one image.
        let imagesFolder = Storage.storage().reference().child("images") // This creates path so we can access the images folder in the Firebase server.
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)! // We are using a JPEG so we can lower the quality of the image to make the upload times faster and so we take up a smaller amount of storage in the server.
        imagesFolder.child("\(NSUUID().uuidString).png").putData(imageData, metadata: nil) { (metadata, error) in // This line uploads the image into the fold in the Firebase server.
            print("We tried to upload an image.")
            if error != nil {
                print("We have an error: \(error)")
            }else{
                print(metadata?.downloadURL()) // Provides a URL to the image uploaded.
                self.performSegue(withIdentifier: "selectUserSegue", sender: metadata?.downloadURL()!.absoluteString)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SelectUserViewController
        nextVC.imageURL = sender as! String
        nextVC.descrip = descriptionTextField.text!
    }
}
