//
//  LoginViewController.swift
//  WarrantyGuard
//
//  Created by A A on 13/12/2021.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var errorLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    errorLabel.alpha = 0
    
    Utilities.configureButtons(button: loginButton)
    
    configureHideKeyboardWhenRootViewTapped()
    
  }
  
  
  // MARK:- Login
  @IBAction func loginTapped(_ sender: UIButton) {
    // TODO: Validate Text Fields
    
    // Create cleaned versions of the text field
    let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    // Signing in the user
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      
      if error != nil {
        // Couldn't sign in
        self.errorLabel.text = error!.localizedDescription
        self.errorLabel.alpha = 1
      }
      else {
        
        let mainViewController = self.storyboard?.instantiateViewController(identifier:"Home")
        self.view.window?.rootViewController = mainViewController
        self.view.window?.makeKeyAndVisible()
        
        
      }
    }
  }
  
}
