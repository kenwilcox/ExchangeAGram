//
//  FeedViewController.swift
//  ExchangeAGram
//
//  Created by Kenneth Wilcox on 1/31/15.
//  Copyright (c) 2015 Kenneth Wilcox. All rights reserved.
//

import UIKit
import MobileCoreServices

class FeedViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func snapBarButtonItemTapped(sender: UIBarButtonItem) {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      var cameraController = UIImagePickerController()
      cameraController.delegate = self
      cameraController.sourceType = UIImagePickerControllerSourceType.Camera
      
      let mediaTypes:[AnyObject] = [kUTTypeImage]
      cameraController.mediaTypes = mediaTypes
      cameraController.allowsEditing = false
      
      self.presentViewController(cameraController, animated: true, completion: nil)
    }
    else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
      var photoLibraryController = UIImagePickerController()
      photoLibraryController.delegate = self
      photoLibraryController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
      
      let mediaTypes:[AnyObject] = [kUTTypeImage]
      photoLibraryController.mediaTypes = mediaTypes
      photoLibraryController.allowsEditing = false
      
      self.presentViewController(photoLibraryController, animated: true, completion: nil)
    }
    else {
      var alertView = UIAlertController(title: "Alert", message: "Your device does not support the camera or photo Library", preferredStyle: UIAlertControllerStyle.Alert)
      alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alertView, animated: true, completion: nil)
    }
  }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}

// MARK: - UICollectionViewDataSource
extension FeedViewController: UICollectionViewDataSource {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCellWithReuseIdentifier("feedCell", forIndexPath: indexPath) as FeedCell
  }
}

// MARK: - UICollectionViewDelegate
extension FeedViewController: UICollectionViewDelegate {
  
}

// MARK: - UIImagePickerControllerDelegate
extension FeedViewController: UIImagePickerControllerDelegate {
  
}

// MARK: - UINavigationControllerDelegate
extension FeedViewController: UINavigationControllerDelegate {
  
}
