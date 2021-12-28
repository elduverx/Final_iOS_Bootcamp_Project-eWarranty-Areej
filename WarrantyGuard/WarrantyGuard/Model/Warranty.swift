//
//  Warranty.swift
//  WarrantyGuard
//
//  Created by A A on 19/12/2021.
//

import UIKit

struct Warranty {
  
//  static var warranty:Warranty?
  
  static var allWarranty = [Warranty]()
  
  var productName: String
  var purchasDate: String
  var expiryDate: String
  var category:String
  var warrantyImage: UIImageView?
  var productImage: UIImageView?
  var notes: String?
  
}
