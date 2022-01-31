//
//  DetailViewController.swift
//  WarrantyGuard
//
//  Created by A A on 21/12/2021.
//

import UIKit
import Firebase
import SDWebImage

class DetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var category = String()
  
  var products = [Product]()
  
  let db = Firestore.firestore().collection("Produts")
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    getProductForCategory()
    
    print(category)
    
  }
  
  
  // Hide the table view if there is no data
  func hideTableView(){
    
    if products.count == 0 {
      
      tableView.isHidden = true
      
      //Create Image View
      let noDataImage = UIImageView(frame: CGRect(x: 50,
                                                  y: 250,
                                                  width: self.view.frame.width - 100,
                                                  height: 200))
      noDataImage.image = UIImage(named: "noData")
      self.view.addSubview(noDataImage)
      
      //Create Label
      let noDataLabel = UILabel(frame: CGRect(x: noDataImage.frame.minX,
                                              y: noDataImage.frame.maxY + 20,
                                              width: noDataImage.frame.width,
                                              height: 30))
      noDataLabel.text = "No Data To Display"
      noDataLabel.textAlignment = .center
      noDataLabel.textColor = UIColor.ccPurple
      noDataLabel.font = UIFont.systemFont(ofSize: 20)
      self.view.addSubview(noDataLabel)
      
    }
  }
  
  
  //Calculate The Days Left
  func calculateDurationDate(purchaseDateString: String, expiryDateString :String, completion : @escaping (_ daysLeft: Int, _ totalDays: Int)->()) {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy"
    
    let nowDateString = dateFormatter.string(from: Date())
    let nowDate = dateFormatter.date(from: nowDateString)
    let purchaseDate = dateFormatter.date(from: purchaseDateString)
    let expiryDate = dateFormatter.date(from: expiryDateString)
    
    let daysLeft = Calendar.current.dateComponents([.day], from: nowDate!, to: expiryDate!)
    let totalDays = Calendar.current.dateComponents([.day], from: purchaseDate!, to: expiryDate!)
    
    if let leftDaysDuration = daysLeft.day, let totalDaysDuration = totalDays.day {
      completion(leftDaysDuration,totalDaysDuration)
    }
    
  }
  
  
  //Get Data From The Firebase
  func getProductForCategory() {
    guard let userID = Auth.auth().currentUser?.uid else {return}
    db.whereField("category", isEqualTo: category).addSnapshotListener { snapshot, error in
      if error == nil {
        if let value = snapshot?.documents {
          for i in value {
            let data = i.data()
            let product = Product(productName: data["productName"] as? String, purchaseDate: data["purchaseDate"] as? String, expiryDate: data["expiryDate"] as? String, category: data["category"] as? String, warrantyImage: data["warrantyImage"] as? String, productImage: data["productImage"] as? String, warrantyNots: data["warrantyNots"] as? String)
            print("product :\n", product)
            
            if let userId = data["userID"] as? String {
              if userId == userID {
                self.products.append(product)
              }
            }
            
          }
          self.tableView.reloadData()
        }
      }
      self.hideTableView()
    }
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! DetailTableViewCell
    
    let product = products[indexPath.row]
    cell.productName.text = product.productName
    //    name = product.productName
    
    if let purchase = product.purchaseDate, let expiry = product.expiryDate {
      calculateDurationDate(purchaseDateString: purchase, expiryDateString: expiry) { daysLeft, totalDays in
        
        print("Total Days : \(totalDays) , Days Left : \(daysLeft)")
        
        if daysLeft > 0 {
          cell.daysLeftLabel.text = "\(daysLeft) days left"
          
          let totalPercent = 1 / Double(totalDays)
          
          
          let remind  = Double(totalDays - daysLeft) * totalPercent
          print(remind)
          
          cell.progressView.progress = Float(remind)
        }
        else {
          cell.daysLeftLabel.text = "Expired"
          cell.progressView.progress = 1
        }
      }
    }
    
    if let productImageUrl = product.productImage {
      cell.productImageView.sd_setImage(with: URL(string: productImageUrl), placeholderImage: UIImage(systemName: "photo.on.rectangle.angled"))
    }
    
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
  
  
}
