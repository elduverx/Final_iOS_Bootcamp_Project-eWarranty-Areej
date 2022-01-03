//
//  DetailTableViewCell.swift
//  WarrantyGuard
//
//  Created by A A on 28/12/2021.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productName: UILabel!
  @IBOutlet weak var daysLeftLabel: UILabel!
  @IBOutlet weak var progressView: UIProgressView!
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  
  func setUpCell(image: UIImage, name:String, expiryDate:String){
    productImageView.image = image
    productName.text = name
    daysLeftLabel.text = "Expires on \(expiryDate)"
  }
  
}


