//
//  HomeViewController.swift
//  WarrantyGuard
//
//  Created by A A on 14/12/2021.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
 
  @IBOutlet weak var homeTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    homeTableView.delegate = self
    homeTableView.dataSource = self
    
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    Warranty.allWarranty.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "warranty", for: indexPath) as! HomeTableViewCell
    
//    let currentWarranty = Warranty.allWarranty[indexPath.row]
//
//    print(currentWarranty)
//
//    cell.setUpTheCell(image: currentWarranty.productImage!, name: currentWarranty.productName)
    
    return cell 
    
  }
  
  
}
