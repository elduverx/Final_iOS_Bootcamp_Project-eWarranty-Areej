//
//  SearchViewController.swift
//  WarrantyGuard
//
//  Created by A A on 31/12/2021.
//

import UIKit

class SearchViewController: UIViewController , UISearchBarDelegate {

  var warranty:Warranty?
  
  
  @IBOutlet weak var warrantySearchBar: UISearchBar!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      warrantySearchBar.delegate = self
      
    }
    

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    if searchText == warranty?.productName {
      
    }
    
  }

}
