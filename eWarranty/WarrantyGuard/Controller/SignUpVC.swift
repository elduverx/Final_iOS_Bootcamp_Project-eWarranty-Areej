//
//  SignUpViewController.swift
//  WarrantyGuard
//
//  Created by A A on 13/12/2021.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpVC: UIViewController {
  
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var createAccountButton: UIButton!
  @IBOutlet weak var errorLabel: UILabel!
  
  
  override func viewDidLoad(){
    super.viewDidLoad()
    
    Utilities.configureButtons(button: createAccountButton)
    
    errorLabel.alpha = 0
    
    configureHideKeyboardWhenRootViewTapped()
    
  }
  
  
  // MARK:- Create Account
  @IBAction func createAccountTapped(_ sender: UIButton) {
    
    // Validate the fields
    let error = validateFields()
    
    if error != nil {
      
      // There's something wrong with the fields, show error message
      showError(error!)
      
    }
    else {
      
      // Create cleaned versions of the data
      let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      
      // Create the user
      Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
        
        // Check for errors
        if err != nil {
          
          // There was an error creating the user
          self.showError("Error creating user")
        }
        else {
          
          // User was created successfully, now store the first name and last name
          let db = Firestore.firestore()
          
          db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "uid": result!.user.uid ]) { (error) in
            
            if error != nil {
              // Show error message
              self.showError("Error saving user data")
            }
          }
          
          // Transition to the home screen
          self.transitionToHome()
        }
        
      }
    }
  }
  
  
  func showError(_ message: String){
    
    errorLabel.text = message
    errorLabel.alpha = 1
    
  }
  
  
  func transitionToHome(){
    
    let homeViewController = storyboard?.instantiateViewController(identifier:"Home")
    
    view.window?.rootViewController = homeViewController
    view.window?.makeKeyAndVisible()
    
  }
  
  
  // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
  func validateFields()-> String? {
    
    // Check that all fields are filled in
    if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
      
      return "Please fill in all fields"
      
    }
    
    // Check if the password is secure
    let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if isPasswordValid(cleanedPassword) == false {
      return "Please make sure your password is at least 8 characters, contains a special character and number "
    }
    return nil
  }
  
  
  func isPasswordValid(_ password : String) -> Bool {
    let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                   "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$" )
    return passwordTest.evaluate(with: password)
  }
  
}
