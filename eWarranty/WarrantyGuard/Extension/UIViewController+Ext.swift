//
//  UIViewController+Ext.swift
//  WarrantyGuard
//
//  Created by A A on 26/12/2021.
//

import UIKit

extension UIViewController {
  
  func configureHideKeyboardWhenRootViewTapped(){
    let tap = UITapGestureRecognizer(
      target: self,
      action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
}
