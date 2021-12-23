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
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    Utilities.configureButtons(button: nextButton)
    
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
  
}
