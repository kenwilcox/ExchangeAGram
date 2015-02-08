//
//  FeedViewController.swift
//  ExchangeAGram
//
//  Created by Kenneth Wilcox on 1/31/15.
//  Copyright (c) 2015 Kenneth Wilcox. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData

class FeedViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  var feedArray:[AnyObject] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func viewDidAppear(animated: Bool) {
    let request = NSFetchRequest(entityName: "FeedItem")
    let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    let context = appDelegate.managedObjectContext!
    feedArray = context.executeFetchRequest(request, error: nil)!
    collectionView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func profileTapped(sender: UIBarButtonItem) {
    self.performSegueWithIdentifier("profileSegue", sender: nil)
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
    return feedArray.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    var cell:FeedCell = collectionView.dequeueReusableCellWithReuseIdentifier("feedCell", forIndexPath: indexPath) as FeedCell
    
    let feedItem = feedArray[indexPath.row] as FeedItem
    cell.imageView.image = UIImage(data: feedItem.image)
    cell.captionLabel.text = feedItem.caption
    
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension FeedViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let thisItem = feedArray[indexPath.row] as FeedItem
    
    var filterVC = FilterViewController()
    filterVC.thisFeedItem = thisItem
    
    self.navigationController?.pushViewController(filterVC, animated: false)
  }
}

// MARK: - UIImagePickerControllerDelegate
extension FeedViewController: UIImagePickerControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let image = info[UIImagePickerControllerOriginalImage] as UIImage
    let imageData = UIImageJPEGRepresentation(image, 1.0)
    
    // really make a thumbnail
    let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(300.0/image.size.width, 300.0/image.size.height))
    let hasAlpha = false
    let scale: CGFloat = 0.0 // automatically use scale factor of the main screen
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
    image.drawInRect(CGRect(origin: CGPointZero, size: size))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    let thumbnailData = UIImageJPEGRepresentation(scaledImage, 0.5)
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    let entityDescription = NSEntityDescription.entityForName("FeedItem", inManagedObjectContext: managedObjectContext!)
    
    let feedItem = FeedItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
    feedItem.image = imageData
    feedItem.thumbnail = thumbnailData
    feedItem.caption = "test caption"
    
    (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    
    feedArray.append(feedItem)
    
    self.dismissViewControllerAnimated(true, completion: nil)
    
    self.collectionView.reloadData()
  }
  
}

// MARK: - UINavigationControllerDelegate
extension FeedViewController: UINavigationControllerDelegate {
  
}
