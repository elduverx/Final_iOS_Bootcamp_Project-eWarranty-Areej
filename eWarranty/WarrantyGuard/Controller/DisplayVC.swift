//
//  DisplayVC.swift
//  WarrantyGuard
//
//  Created by A A on 05/01/2022.
//

import UIKit
import SDWebImage
import Firebase

class DisplayVC : UIViewController {
  
  var product : Product?
  
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var purchaseDateLabel: UILabel!
  @IBOutlet weak var expiryDateLabel: UILabel!
  @IBOutlet weak var warrantyImageView: UIImageView!
  @IBOutlet weak var notesView: UIView!
  @IBOutlet weak var notesTV: UITextView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    notesView.isHidden = true
    
    displayProduct()
    
  }
  
  
  func displayProduct(){
    
    productNameLabel.text = product?.productName
    purchaseDateLabel.text = product?.purchaseDate
    expiryDateLabel.text = product?.expiryDate
    
    warrantyImageView.sd_setImage(with: URL(string: (product?.warrantyImage)!), placeholderImage: UIImage(systemName: "photo.on.rectangle.angled"))
    
    //Check if there is notes
    if product?.warrantyNots != "" {
      notesView.isHidden = false
      notesTV.text = product?.warrantyNots
    }
    
  }
  
}
