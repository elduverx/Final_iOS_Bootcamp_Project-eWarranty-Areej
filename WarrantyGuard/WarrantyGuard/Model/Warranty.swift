//
//  Warranty.swift
//  WarrantyGuard
//
//  Created by A A on 19/12/2021.
//

import UIKit

struct Warranty {
  
  static var allWarranty = [Warranty]()
  
  var productName: String
  var purchasDate: String
  var expiryDate: String
  var category:String
  var warrantyImage: UIImage
  var productImage: UIImage?
  var notes: String?
  
}
