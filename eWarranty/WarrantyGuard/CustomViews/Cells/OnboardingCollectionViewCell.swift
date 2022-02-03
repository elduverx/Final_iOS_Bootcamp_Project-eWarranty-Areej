//
//  OnboardingCollectionViewCell.swift
//  WarrantyGuard
//
//  Created by A A on 31/12/2021.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
  
  static let identifier = String(describing: OnboardingCollectionViewCell.self)
  
  @IBOutlet weak var sildeTitleLabel: UILabel!
  @IBOutlet weak var sildeDescriptionLabel: UILabel!
  @IBOutlet weak var sildeImageView: UIImageView!
  
  func setUp(_ slide:OnboardingSlide){
    sildeImageView.image = slide.image
    sildeTitleLabel.text = slide.title
    sildeDescriptionLabel.text = slide.description
  }
  
}
