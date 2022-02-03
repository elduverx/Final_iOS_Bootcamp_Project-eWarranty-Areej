//
//  AppDelegate.swift
//  WarrantyGuard
//
//  Created by A A on 12/12/2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  static var categories = [Category]() // ["Electronics","Phones","Sport","Toys"]
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    FirebaseApp.configure()
    
    UITabBar.appearance().tintColor = UIColor.ccPurple
    UINavigationBar.appearance().tintColor = UIColor.ccPurple
    
    AppDelegate.getCategories {}
    
    return true
  }
  
  static func getCategories(completion : @escaping ()->()) {
    
    Firestore.firestore().collection("Category").order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
      AppDelegate.categories.removeAll()
      if error == nil {
        if let value = snapshot?.documents {
          for i in value {
            let data = i.data()
            let categoryID = data["categoryID"] as? String
            let categoryName = data["categoryName"] as? String
            AppDelegate.categories.append(Category(categoryId: categoryID, categoryName: categoryName))
          }
          completion()
        }
      }
    }
  }
  
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  
  
}

