//
//  DetailViewController.swift
//  WarrantyGuard
//
//  Created by A A on 21/12/2021.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    Warranty.allWarranty.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! DetailTableViewCell
    let warrantyData = Warranty.allWarranty[indexPath.row]
    cell.setUpCell(image: warrantyData.productImage!, name: warrantyData.productName)
    
    return cell
    
  }
  
}
