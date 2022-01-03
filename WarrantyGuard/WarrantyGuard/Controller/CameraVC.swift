//
//  CameraViewController.swift
//  WarrantyGuard
//
//  Created by A A on 19/12/2021.
//

import UIKit
import Firebase
import FirebaseStorage
import Photos


class CameraVC : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var warranty:Warranty?
  
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var warrantyImageView: UIImageView!
  @IBOutlet weak var errorLabel: UILabel!
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    Utilities.configureButtons(button: nextButton)
    errorLabel.alpha = 0
    
  }
  
  
  @IBAction func cameraButtonTapped(_ sender: UIButton) {
    getPhoto(type: .camera)
  }
  
  
  @IBAction func importButtonTapped(_ sender: UIButton) {
    getPhoto(type: .photoLibrary)
  }
  
  
  @IBAction func nextButtonPressed(_ sender: Any) {
    
    if warrantyImageView.image != nil {
//
//      let db = Firestore.firestore()
//      var ref: DocumentReference? = nil
//
////      let warrantyImage = warrantyImageView.image ?? #imageLiteral(resourceName: "done")
//
//      guard let imageData = warrantyImageView.image?.jpegData(compressionQuality: 1) else { return }
//
//      let imageName = UUID().uuidString
////      let imageReference = Storage.storage().reference().child(MyKeys)
//
//      ref = db.collection("warrantys").addDocument(data: ["warrantyImage":imageData]) { (error) in
//
//        if error != nil {
//          // Show error message
//          print("Error saving user data")
//        }
//        else {
//          print("document added")
//        }
//      }
      
      performSegue(withIdentifier: "Next", sender: nil)
      
      
    } else {
      errorLabel.text = "Please enter your warranty picture"
      errorLabel.alpha = 1
    }
    
  }
  
  
  func getPhoto(type: UIImagePickerController.SourceType){
    let picker = UIImagePickerController()
    picker.sourceType = type
    picker.delegate = self
    present(picker, animated: true, completion: nil)
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    dismiss(animated: true, completion: nil)
    guard let image = info[.originalImage] as? UIImage else {
      print("image not found")
      return
    }
    
    warrantyImageView.image = image
    
    if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
      print(url)
      uploadToCloud(fileURL: url)
    }
  }
  
  //Upload images to firebase storage
  func uploadToCloud(fileURL : URL){
    let storge = Storage.storage()
    let data = Data()
    let storgeRef = storge.reference()
    let localFile = fileURL
    let photoRef = storgeRef.child("UploadPhotoOne")
    let uploadTask = photoRef.putFile(from: localFile, metadata: nil) {
      (metadata, err) in
      guard let metadata = metadata else {
        print(err?.localizedDescription)
        return
      }
      print("Photo Upload")
    }
  }
  
}
