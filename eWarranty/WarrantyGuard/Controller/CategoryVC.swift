//
//  CategoryViewController.swift
//  WarrantyGuard
//
//  Created by A A on 15/12/2021.
//

import UIKit
import Firebase

class CategoryVC : UIViewController , UITableViewDelegate ,UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  let db = Firestore.firestore().collection("Category")
  let categoryID = UUID().uuidString
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    AppDelegate.getCategories {
      self.tableView.reloadData()
    }
    
  }
  
  
  // Add New Category
  @IBAction func addButtonTapped(_ sender: UIButton) {
    
    let alert = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
    alert.addTextField { categoryTF in
      categoryTF.placeholder = "Enter Category"
    }
    
    let action = UIAlertAction(title: "Add", style: .default) { (_) in
      guard let newCategory = alert.textFields?.first?.text else { return }
      print(newCategory)
      
      self.db.document(self.categoryID).setData([
        "categoryID" : self.categoryID,
        "categoryName" : newCategory,
        "timestamp" : Date().timeIntervalSince1970
      ])
    }
    
    alert.addAction(action)
    present(alert, animated: true)
    
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return AppDelegate.categories.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = AppDelegate.categories[indexPath.row].categoryName
    
    return cell
    
  }
  
  
  // Remove Category
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    AppDelegate.categories.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
    db.document(categoryID).delete() { error in
      if let err = error {
        print("Error removing document: \(err)")
      } else {
        print("Document successfully removed!")
      }
    }
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let selectedCategory = AppDelegate.categories[indexPath.row].categoryName
    performSegue(withIdentifier: "show_detail", sender: selectedCategory)
    
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "show_detail" {
      let destination = segue.destination as! DetailVC
      destination.category = sender as! String
    }
    
  }
  
}
