//
//  OptionalDataViewController.swift
//  WarrantyGuard
//
//  Created by A A on 27/12/2021.
//

import UIKit
import Firebase

class OptionalDataVC : UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
  var warranty:Warranty?
  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var notesTextView: UITextView!
  @IBOutlet weak var nextButton: UIButton!
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    Utilities.configureButtons(button: nextButton)
    configureHideKeyboardWhenRootViewTapped()
    
  }
  
  
  @IBAction func photoButton(_ sender: UIButton) {
    getPhoto(type: .photoLibrary)
  }
  
  
  @IBAction func cameraButton(_ sender: UIButton) {
    getPhoto(type: .camera)
  }
  
  
  @IBAction func nextButtonPressed(_ sender: UIButton) {
    
//    let db = Firestore.firestore()
//    var ref: DocumentReference? = nil
//
//    let productImage = productImageView.image
//    let notes = notesTextView.text
//
//    ref = db.collection("warrantys").addDocument(data: ["productImage":productImage, "notes": notes]) { (error) in
//
//      if error != nil {
//        // Show error message
//        print("Error saving user data")
//      }
//      else {
//        print("document added")
//      }
//    }
    
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
    productImageView.image = image
  }
  
}
