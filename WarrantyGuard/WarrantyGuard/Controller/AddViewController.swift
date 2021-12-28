//
//  AddViewController.swift
//  WarrantyGuard
//
//  Created by A A on 17/12/2021.
//

import UIKit

class AddViewController: UIViewController {
  
  @IBOutlet weak var productNameTextField: UITextField!
  @IBOutlet weak var purchaseDateTextField: UITextField!
  @IBOutlet weak var expiryDateTextField: UITextField!
  @IBOutlet weak var categoryTextField: UITextField!
  @IBOutlet weak var continueButton: UIButton!
  @IBOutlet weak var errorLabel: UILabel!
  
  var productName:String = ""
  var purchaseDate:String = ""
  var expiryDate:String = ""
  var categoryName:String = ""
  
  
  
  var currentIndex = 0
  let pickerView = UIPickerView()
  let purchasDatePicker = UIDatePicker()
  let expiryDatePicker = UIDatePicker()
 
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    createDatePicker()
    createPickerView()
    
    Utilities.configureButtons(button: continueButton)
    configureHideKeyboardWhenRootViewTapped()
    
    pickerView.delegate = self
    pickerView.dataSource = self
    
    errorLabel.alpha = 0
    
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
  
//
//    func createDatePicker(textField:UITextField){
//
//      //Toolbar
//      let toolBar = UIToolbar()
//      toolBar.sizeToFit()
//
//      //Bar buttom
//      let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
//      toolBar.setItems([doneButton], animated: true)
//
//      //Assign toolbar
//      textField.inputAccessoryView = toolBar
//
//      //Assign datePicker to the TextField
//      textField.inputView = datePicker
//
//      //DatePicker Mode
//      datePicker.datePickerMode = .date
//      datePicker.preferredDatePickerStyle = .wheels
//
//    }
  
  
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
  
  
  @IBAction func continueButtonPressed(_ sender: UIButton) {
    
    let error = validateFields()
    
    if error != nil {
      
      // There's something wrong with the fields, show error message
      showError(error!)
      
    }
    else {
      
      productName = productNameTextField.text!
      purchaseDate = purchaseDateTextField.text!
      expiryDate = expiryDateTextField.text!
      categoryName = categoryTextField.text!
      
      
      transitionToNext()
      
    }
    
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
  
  
  func transitionToNext() {
    
    performSegue(withIdentifier: "Continue", sender: nil)
    
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


