//
//  AddViewController.swift
//  WarrantyGuard
//
//  Created by A A on 17/12/2021.
//

import UIKit

class AddViewController: UIViewController {
  
  @IBOutlet weak var productNameTextField: UITextField!
  @IBOutlet weak var purchasDateTextField: UITextField!
  @IBOutlet weak var warrantyPeriodTextField: UITextField!
  @IBOutlet weak var categoryTextField: UITextField!
  @IBOutlet weak var continueButton: UIButton!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    Utilities.configureButtons(button: continueButton)
    
  }
  
}


//extension AddViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//
//
//
//  func numberOfComponents(in pickerView: UIPickerView) -> Int {
//    return 1
//  }
//
//  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//    return
//  }
//
//}
