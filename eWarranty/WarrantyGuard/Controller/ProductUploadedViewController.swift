//
//  ProductUploadedViewController.swift
//  WarrantyGuard
//
//  Created by A A on 01/06/1443 AH.
//

import UIKit

class ProductUploadedViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
      vc?.modalPresentationStyle = .fullScreen
      self.present(vc!, animated: true, completion: nil)
    }
    
  }
  
}
