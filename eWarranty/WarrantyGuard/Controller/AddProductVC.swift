//
//  AddViewController.swift
//  WarrantyGuard
//
//  Created by A A on 17/12/2021.
//

import UIKit
import Firebase
import UserNotifications

class AddProductVC: UIViewController {
  
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
  
  
  // MARK:- Notifactions
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
            print("the date before a week\(weekBefore!)")
            
            let reminderDate = Calendar.current.dateComponents([.year, .month, .day], from: weekBefore!)
            
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
  
  
  // MARK:- Create DatePicker
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
  
  
  // MARK:- Create PickerView
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
    
      categoryTextField.text = AppDelegate.categories[currentIndex].categoryName
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
        performSegue(withIdentifier: "ContinueToSecondVC", sender: ProductComponents(productName: productNameTextField.text!, purchaseDate: purchaseDateTextField.text!, expiryDate: expiryDateTextField.text!, category: categoryTextField.text!, warrantyImage: nil, productImage: nil, warrantyNots: nil))
      }
    
  }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! CameraVC
        destination.product = sender as? ProductComponents
    }
  

}


// MARK:- Extension
extension AddProductVC: UIPickerViewDelegate, UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return AppDelegate.categories.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    currentIndex = row
      return AppDelegate.categories[row].categoryName
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      categoryTextField.text = AppDelegate.categories[row].categoryName
  }
  
}

