//
//  CameraViewController.swift
//  WarrantyGuard
//
//  Created by A A on 19/12/2021.
//

import UIKit

class CameraViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var imageView: UIImageView!
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
    imageView.image = image
  }
  
  
  @IBAction func nextButtonPressed(_ sender: UIButton) {
    
    if imageView.image != nil {
      transitionToNext()
    } else {
      errorLabel.text = "Please enter your warranty picture"
      errorLabel.alpha = 1
    }
      
  }
  
  
  func transitionToNext() {
    
    let nextViewController = storyboard?.instantiateViewController(identifier: "Next")
    
    view.window?.rootViewController = nextViewController
    view.window?.makeKeyAndVisible()
    
  }
  
}
