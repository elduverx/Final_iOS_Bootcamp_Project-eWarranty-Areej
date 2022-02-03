//
//  ProfileVC.swift
//  WarrantyGuard
//
//  Created by A A on 06/01/2022.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
  
  let db = Firestore.firestore()
  
  @IBOutlet weak var firstNameTextView: UITextView!  
  @IBOutlet weak var lastNameTextView: UITextView!
  
  @IBOutlet weak var logOutButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Utilities.configureButtons(button: logOutButton)
    
    db.collection("users").whereField("uid", isEqualTo:Auth.auth().currentUser!.uid)
      .addSnapshotListener { (querySnapshot, error) in
        if let error = error {
          print("Error while fetching profile\(error)")
        } else {
          if let snapshotDocuments = querySnapshot?.documents {
            for doc in snapshotDocuments {
              let data = doc.data()
              let firstName = data["firstname"] as! String
              let lastName = data["lastname"] as! String
              self.firstNameTextView.text = firstName
              self.lastNameTextView.text = lastName
              
              print(firstName)
            }
          }
        }
      }
  }
  
  
  // MARK:- Logout
  @IBAction func logoutButtonPressed(_ sender: UIButton) {
    
    do {
      try Auth.auth().signOut()
      transitionToMain()
    } catch let signOutError as NSError {
      print("Error signing out: %&", signOutError)
    }
    
  }
  
  
  func transitionToMain(){
    
    let mainViewController = storyboard?.instantiateViewController(identifier:"AuthorizationVC")
    
    view.window?.rootViewController = mainViewController
    view.window?.makeKeyAndVisible()
    
  }
  
}
