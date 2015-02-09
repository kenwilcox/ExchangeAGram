//
//  ProfileViewController.swift
//  ExchangeAGram
//
//  Created by Kenneth Wilcox on 2/6/15.
//  Copyright (c) 2015 Kenneth Wilcox. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var fbLoginView: FBLoginView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.fbLoginView.delegate = self
    self.fbLoginView.readPermissions = ["public_profile", "publish_actions"]
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func mapViewButtonTapped(sender: UIButton) {
    
  }
}

extension ProfileViewController: FBLoginViewDelegate {
  
  func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
    profileImageView.hidden = false
    nameLabel.hidden = false
  }
  
  func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
    println("loginViewFetchUserInfo: \(user)")
    
    nameLabel.text = user.name
    
//    let userImageURL = "https://graph.facebook.com/\(user.objectID)/picture?type=small"
//    let url = NSURL(string: userImageURL)
//    let imageData = NSData(contentsOfURL: url!)
//    let image = UIImage(data: imageData!)
//    profileImageView.image = image
    
    profileImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://graph.facebook.com/\(user.objectID)/picture?type=normal")!)!)
  }
  
  func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
    profileImageView.hidden = true
    nameLabel.hidden = true
  }
  
  func loginView(loginView: FBLoginView!, handleError error: NSError!) {
    println("Error: \(error.localizedDescription)")
  }
  
}