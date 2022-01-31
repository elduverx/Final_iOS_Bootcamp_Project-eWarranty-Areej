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
  
  var product : ProductComponents?
  
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var warrantyImageView: UIImageView!
  @IBOutlet weak var errorLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Utilities.configureButtons(button: nextButton)
    
    errorLabel.alpha = 0
    
  }
  
  
  //Camera
  @IBAction func cameraButtonTapped(_ sender: UIButton) {
    getPhoto(type: .camera)
  }
  
  
  //Photo Library
  @IBAction func importButtonTapped(_ sender: UIButton) {
    getPhoto(type: .photoLibrary)
  }
  
  
  @IBAction func nextButtonPressed(_ sender: Any) {
    
    if warrantyImageView.image != nil {
  
      let product = ProductComponents(productName: product?.productName, purchaseDate: product?.purchaseDate, expiryDate: product?.expiryDate, category: product?.category, warrantyImage: warrantyImageView.image, productImage: nil, warrantyNots: nil)
      
      performSegue(withIdentifier: "Next", sender: product)
      
      
    } else {
      errorLabel.text = "Please enter your warranty picture"
      errorLabel.alpha = 1
    }
    
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let finalDestination = segue.destination as! OptionalDataVC
    finalDestination.product = sender as? ProductComponents
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
  
}
