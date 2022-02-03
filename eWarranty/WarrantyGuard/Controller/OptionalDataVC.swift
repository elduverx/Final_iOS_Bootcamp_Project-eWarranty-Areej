//
//  OptionalDataViewController.swift
//  WarrantyGuard
//
//  Created by A A on 27/12/2021.
//

import UIKit
import Firebase
import FirebaseStorage

class OptionalDataVC : UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
  var product : ProductComponents?
  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var notesTV: UITextView!
  @IBOutlet weak var nextButton: UIButton!
  
  let db = Firestore.firestore().collection("Produts")
  
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
  
  
  // MARK:-  Save all product data in firebase
  @IBAction func nextButtonPressed(_ sender: UIButton) {
    
    if let finalProduct = product {
      print("finalProduct : ", finalProduct)
      guard let warantyImageData = finalProduct.warrantyImage?.jpegData(compressionQuality: 0.25) else {return}
      let storageWarrantyRef = Storage.storage().reference().child("Warranty").child(UUID().uuidString)
      storageWarrantyRef.putData(warantyImageData, metadata: nil) { metadata, error in
        if error == nil {
          storageWarrantyRef.downloadURL { url, error in
            if error == nil {
              let warantyUrl = url?.absoluteString
              
              if self.productImageView.image == nil {
                // save to firestore without product image
                self.uploadProduct(uploadedProduct: finalProduct, warrantyUrl: warantyUrl!, productUrl: "")
              } else {
                
                // save to firestore with product image
                guard let productImageData = self.productImageView.image?.jpegData(compressionQuality: 0.25) else {return}
                let storagProducteRef = Storage.storage().reference().child("Product").child(UUID().uuidString)
                storagProducteRef.putData(productImageData, metadata: nil) { metadata, error in
                  if error == nil {
                    storagProducteRef.downloadURL { url, error in
                      if error == nil {
                        let productUrl = url?.absoluteString
                        self.uploadProduct(uploadedProduct: finalProduct, warrantyUrl: warantyUrl!, productUrl: productUrl!)
                        // save data to firestore
                      }
                    }
                  }
                }
              }
            }
          }
        } else {
          print(error?.localizedDescription)
        }
      }
    }
  }
  
  
  func uploadProduct(uploadedProduct : ProductComponents, warrantyUrl : String, productUrl : String) {
    let productData : [String : Any] = ["productName" : uploadedProduct.productName,
                                        "purchaseDate" : uploadedProduct.purchaseDate,
                                        "expiryDate" : uploadedProduct.expiryDate,
                                        "category" : uploadedProduct.category,
                                        "warrantyNots" : notesTV.text,
                                        "warrantyImage" : warrantyUrl,
                                        "productImage" : productUrl,
                                        "userID" : Auth.auth().currentUser?.uid
    ]
    db.document(UUID().uuidString).setData(productData) { error in
      if error == nil {
        print("productAdded")
        DispatchQueue.main.async {
          self.performSegue(withIdentifier: "productAdded", sender: nil)
        }
        
      }
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
    productImageView.image = image
  }
  
}
