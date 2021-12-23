//
//  ViewController.swift
//  WarrantyGuard
//
//  Created by A A on 12/12/2021.
//

import UIKit

class AuthorizationViewController: UIViewController {
  
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var logInButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Utilities.configureButtons(button: signUpButton)
    Utilities.configureButtons(button: logInButton)
  }
  
  
}

