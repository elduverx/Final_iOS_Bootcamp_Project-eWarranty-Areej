//
//  SearchViewController.swift
//  WarrantyGuard
//
//  Created by A A on 31/12/2021.
//

import UIKit
import Firebase

class SearchVC: UIViewController , UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchImageView: UIImageView!
  
  let db = Firestore.firestore().collection("Produts")
  var products = [Product]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchBar.delegate = self
    searchBar.autocapitalizationType = .none
    
    tableView.delegate = self
    tableView.dataSource = self
    
    configureHideKeyboardWhenRootViewTapped()
    
  }
  
  
  func getProducts() {
    guard let userID = Auth.auth().currentUser?.uid else {return}
    guard let searchText = searchBar.text else {return}
    db.getDocuments { snapshot, error in
      self.products.removeAll()
      if error == nil {
        if let value = snapshot?.documents {
          for i in value {
            
            let data = i.data()
            let name = data["productName"] as? String
            
            if name!.lowercased().contains(searchText.lowercased()) {
              let product = Product(productName: data["productName"] as? String, purchaseDate: data["purchaseDate"] as? String, expiryDate: data["expiryDate"] as? String, category: data["category"] as? String, warrantyImage: data["warrantyImage"] as? String, productImage: data["productImage"] as? String, warrantyNots: data["warrantyNots"] as? String)
              print("product :\n", product)
              
              if let userId = data["userID"] as? String {
                if userId == userID {
                  self.products.append(product)
                }
              }
              
            }
          }
          self.tableView.reloadData()
        }
      }
    }
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchCell
    cell.productNameLabel.text = products[indexPath.row].productName
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedProduct = products[indexPath.row]
    performSegue(withIdentifier: "display", sender: selectedProduct)
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "display" {
      let destination = segue.destination as! DisplayVC
      destination.product = sender as? Product
    }
  }
  
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if let searchImg = searchImageView {
      searchImageView.removeFromSuperview()
    }
    products.removeAll()
    getProducts()
  }
  
}
