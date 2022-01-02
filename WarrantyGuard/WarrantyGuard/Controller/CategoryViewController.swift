//
//  CategoryViewController.swift
//  WarrantyGuard
//
//  Created by A A on 15/12/2021.
//

import UIKit

class CategoryViewController : UIViewController , UITableViewDelegate ,UITableViewDataSource{
  
  @IBOutlet weak var tableView: UITableView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  
  @IBAction func addButtonTapped(_ sender: UIButton) {
    
    let alert = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
    alert.addTextField { categoryTF in
      categoryTF.placeholder = "Enter Category"
    }
    
    let action = UIAlertAction(title: "Add", style: .default) { (_) in
      guard let newCategory = alert.textFields?.first?.text else { return }
      print(newCategory)
      Category.categories.append(newCategory)
      self.tableView.reloadData()
    }
    
    alert.addAction(action)
    present(alert, animated: true)
    
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    Category.categories.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = Category.categories[indexPath.row]
    
    return cell
    
  }
  
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    Category.categories.remove(at: indexPath.row)
    
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "show_detail", sender: nil)
  }
  
  
}
