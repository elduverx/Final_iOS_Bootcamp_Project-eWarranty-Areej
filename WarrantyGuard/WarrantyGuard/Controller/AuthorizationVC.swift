//
//  ViewController.swift
//  WarrantyGuard
//
//  Created by A A on 12/12/2021.
//

import UIKit

class AuthorizationVC: UIViewController {
  
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var logInButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var pageControl: UIPageControl!
  
  var slides: [OnboardingSlide] = []
  var currentPage = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Utilities.configureButtons(button: signUpButton)
    Utilities.configureButtons(button: logInButton)
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    slides = [OnboardingSlide(title: "Say goodbye to missing warranties", description: "Warranty Guard help you to save all your warranties", image: UIImage(named: "imageOne")! ),
              OnboardingSlide(title: "All of your warranties in one place", description: "Access your warranty at anywhere, and anytime!", image: UIImage(named: "imageTwo")! ),
              OnboardingSlide(title: "Get notifaction before any warranty expires", description: "Everything becomes more reliable without any extra effort!", image: UIImage(named: "imageThree")! )
    ]
    
  }
  
  
}


extension AuthorizationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    slides.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
    cell.setUp(slides[indexPath.row])
    return cell
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }
  
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let width = scrollView.frame.width
    currentPage = Int(scrollView.contentOffset.x / width)
    pageControl.currentPage = currentPage
  }
  
}


