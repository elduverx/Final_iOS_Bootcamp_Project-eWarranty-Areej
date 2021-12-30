//
//  CameraViewController.swift
//  WarrantyGuard
//
//  Created by A A on 19/12/2021.
//

import UIKit

class CameraViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var productName = ""
  var purchaseDate = ""
  var expiryDate = ""
  var category = ""
  
  
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
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if warrantyImageView.image != nil {
      let theWarrantyImage = warrantyImageView.image
      
      let destinationVC = segue.destination as! OptionalDataViewController
      
      destinationVC.productName = self.productName
      destinationVC.purchaseDate = self.purchaseDate
      destinationVC.expiryDate = self.expiryDate
      destinationVC.category = self.category
      
      destinationVC.theWarrantyImage = theWarrantyImage
      
      
    } else {
      errorLabel.text = "Please enter your warranty picture"
      errorLabel.alpha = 1
    }
    
  }
  
  
}
