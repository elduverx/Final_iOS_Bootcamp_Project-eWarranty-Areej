//
//  AddViewController.swift
//  WarrantyGuard
//
//  Created by A A on 17/12/2021.
//

import UIKit
import Firebase
import UserNotifications

class AddViewController: UIViewController {
  
  @IBOutlet weak var productNameTextField: UITextField!
  @IBOutlet weak var purchaseDateTextField: UITextField!
  @IBOutlet weak var expiryDateTextField: UITextField!
  @IBOutlet weak var categoryTextField: UITextField!
  @IBOutlet weak var continueButton: UIButton!
  @IBOutlet weak var errorLabel: UILabel!
  
  
  var currentIndex = 0
  let pickerView = UIPickerView()
  let purchasDatePicker = UIDatePicker()
  let expiryDatePicker = UIDatePicker()
  let notificationCenter = UNUserNotificationCenter.current()
  
  var warranty:Warranty?
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    createDatePicker()
    createPickerView()
    
    Utilities.configureButtons(button: continueButton)
    configureHideKeyboardWhenRootViewTapped()
    
    pickerView.delegate = self
    pickerView.dataSource = self
    
    errorLabel.alpha = 0
    
    notificationCenter.requestAuthorization(options: [.alert, .sound]) { (permissionGranted, error) in
      if (!permissionGranted){
        print("Permission Denied")
      }
    }
    
  }
  
  
  @IBAction func switchDidChanged(_ sender: UISwitch) {
    
    if sender.isOn {
      
      notificationCenter.getNotificationSettings { (settings) in
        
        DispatchQueue.main.async {
          if (settings.authorizationStatus == .authorized)
          {
            let content = UNMutableNotificationContent()
            content.title = "The warranty about to expire"
            content.body = "Your warranty will expire in a week"
            
            let weekBefore = Calendar.current.date(byAdding: .day, value: -7 , to: self.expiryDatePicker.date)
            
            let reminderDate = Calendar.current.dateComponents([.year, .month, .day], from: weekBefore ?? Date())
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: reminderDate, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            self.notificationCenter.add(request) { error in
              if error != nil {
                
                print("Error" + error.debugDescription)
                return
                
              }
            }
            let ac = UIAlertController(title: "Notification Scheduled", message: "You will receive a notification one week before the warranty expiry date" , preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in}))
            self.present(ac, animated: true)
          }
          else {
            
            let ac = UIAlertController(title: "Enable Notifications", message: "To use this feature you must enable notifications in settings" , preferredStyle: .alert)
            
            let gotToSettings = UIAlertAction(title: "settings", style: .default){ _ in
              guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
              else
              {
                return
              }
              
              if (UIApplication.shared.canOpenURL(settingsURL)){
                UIApplication.shared.open(settingsURL) {(_) in }
              }
            }
            
            ac.addAction(gotToSettings)
            ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in}))
            self.present(ac, animated: true)
            
          }
        }
        
      }
      
    }
    
  }
  
  
  func createDatePicker(){
    
    //Toolbar
    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    
    //Bar buttom
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
    toolBar.setItems([doneButton], animated: true)
    
    //Assign toolbar
    purchaseDateTextField.inputAccessoryView = toolBar
    expiryDateTextField.inputAccessoryView = toolBar
    
    //Assign datePicker to the TextField
    purchaseDateTextField.inputView = purchasDatePicker
    expiryDateTextField.inputView = expiryDatePicker
    
    //DatePicker Mode
    purchasDatePicker.datePickerMode = .date
    purchasDatePicker.preferredDatePickerStyle = .wheels
    expiryDatePicker.datePickerMode = .date
    expiryDatePicker.preferredDatePickerStyle = .wheels
    
  }
  
  
  @objc func donePressed(){
    
    //Formatter
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    
    purchaseDateTextField.text = formatter.string(from: purchasDatePicker.date)
    self.view.endEditing(true)
    expiryDateTextField.text = formatter.string(from: expiryDatePicker.date)
    self.view.endEditing(true)
    
  }
  
  
  func createPickerView(){
    
    //Toolbar
    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    
    //Bar buttom
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(closePickerView))
    toolBar.setItems([doneButton], animated: true)
    
    categoryTextField.inputAccessoryView = toolBar
    categoryTextField.inputView = pickerView
    
  }
  
  
  @objc func closePickerView(){
    
    categoryTextField.text = Category.categories[currentIndex]
    view.endEditing(true)
    
  }
  
  
  func showError(_ message: String){
    
    errorLabel.text = message
    errorLabel.alpha = 1
    
  }
  
  
  func validateFields()-> String? {
    
    // Check that all fields are filled in
    if productNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        purchaseDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        expiryDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        categoryTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
      
      return "Please fill in all fields"
      
    }
    return nil
  }

  
  @IBAction func continueButtonPressed(_ sender: Any) {
    
    let error = validateFields()
    
    if error != nil {
      
      // There's something wrong with the fields, show error message
      showError(error!)
      
    } else {
      
      let db = Firestore.firestore()
      var ref: DocumentReference? = nil
      
      let productName = productNameTextField.text
      let purchasDate = purchaseDateTextField.text
      let expiryDate = expiryDateTextField.text
      let category = categoryTextField.text
      
      ref = db.collection("warrantys").addDocument(data: ["productName":productName, "lastname":purchasDate, "expiryDate": expiryDate, "category": category ]) { (error) in
        
        if error != nil {
          // Show error message
          self.showError("Error saving user data")
        }
        else {
          print("document added")
        }
      }
      
      performSegue(withIdentifier: "Continue", sender: nil)
      
    }
    
  }
  

}


extension AddViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return Category.categories.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    currentIndex = row
    return Category.categories[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    categoryTextField.text = Category.categories[row]
  }
  
}


