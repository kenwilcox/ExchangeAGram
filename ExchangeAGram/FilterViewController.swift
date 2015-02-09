//
//  FilterViewController.swift
//  ExchangeAGram
//
//  Created by Kenneth Wilcox on 2/2/15.
//  Copyright (c) 2015 Kenneth Wilcox. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
  
  var thisFeedItem: FeedItem!
  var collectionView: UICollectionView!
  let kIntensity = 0.7
  var context: CIContext = CIContext(options: nil)
  var filters: [CIFilter] = []
  let placeHolderImage = UIImage(named: "Placeholder")
  let tmp = NSTemporaryDirectory()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    layout.itemSize = CGSize(width: 150.0, height: 150.0)
    
    collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    
    collectionView.backgroundColor = UIColor.whiteColor()
    collectionView.registerClass(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
    
    self.view.addSubview(collectionView)
    filters = photoFilters()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func photoFilters() -> [CIFilter] {
    let blur = CIFilter(name: "CIGaussianBlur")
    let instant = CIFilter(name: "CIPhotoEffectInstant")
    let noir = CIFilter(name: "CIPhotoEffectNoir")
    let transfer = CIFilter(name: "CIPhotoEffectTransfer")
    let unsharpen = CIFilter(name: "CIUnsharpMask")
    let monochrome = CIFilter(name: "CIColorMonochrome")
    
    let colorControls = CIFilter(name: "CIColorControls")
    colorControls.setValue(0.5, forKey: kCIInputSaturationKey)
    
    let sepia = CIFilter(name: "CISepiaTone")
    sepia.setValue(kIntensity, forKey: kCIInputIntensityKey)
    
    let colorClamp = CIFilter(name: "CIColorClamp")
    colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "inputMaxComponents")
    colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
    
    let composite = CIFilter(name: "CIHardLightBlendMode")
    composite.setValue(sepia.outputImage, forKey: kCIInputImageKey)
    
    let vignette = CIFilter(name: "CIVignette")
    vignette.setValue(composite.outputImage, forKey: kCIInputImageKey)
    vignette.setValue(kIntensity * 2, forKey: kCIInputIntensityKey)
    vignette.setValue(kIntensity * 30, forKey: kCIInputRadiusKey)
    
    return [blur, instant, noir, transfer, unsharpen, monochrome, colorControls, sepia, colorClamp, composite, vignette]
  }
  
  func filteredImageFromImage(imageData: NSData, filter: CIFilter) -> UIImage {
    var unfilteredImage = CIImage(data: imageData)
    filter.setValue(unfilteredImage, forKey: kCIInputImageKey)
    let filteredImage: CIImage = filter.outputImage
    
    let extent = filteredImage.extent()
    let cgImage: CGImageRef = context.createCGImage(filteredImage, fromRect: extent)
    let finalImage = UIImage(CGImage: cgImage)
    
    return finalImage!
  }
  
  // MARK: - Alert Views
  func createUIAlertController(indexPath:NSIndexPath) {
    let alert = UIAlertController(title: "Photo Options", message: "Please choose an option", preferredStyle: .Alert)
    
    alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "Add Caption!"
      textField.secureTextEntry = false
    }
    var text:String
    let textField = alert.textFields![0] as UITextField
    if textField.text != nil {
      text = textField.text
    }
    let photoAction = UIAlertAction(title: "Post Photo to Facebook with Caption", style: .Destructive) { (UIAlertAction) -> Void in
      self.saveFilterToCoreData(indexPath)
    }
    alert.addAction(photoAction)
    
    let saveFilterAction = UIAlertAction(title: "Save Filter without posting on Facebook", style: .Default) { (UIAlertAction) -> Void in
      self.saveFilterToCoreData(indexPath)
    }
    alert.addAction(saveFilterAction)
    
    let cancelAction = UIAlertAction(title: "Select another Filter", style: .Cancel) { (UIAlertAction) -> Void in
      //
    }
    alert.addAction(cancelAction)
    
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func saveFilterToCoreData(indexPath:NSIndexPath) {
    let filterImage = self.filteredImageFromImage(self.thisFeedItem.image, filter: self.filters[indexPath.row])
    
    let imageData = UIImageJPEGRepresentation(filterImage, 1.0)
    self.thisFeedItem.image = imageData
    
    // really make a thumbnail
    let size = CGSizeApplyAffineTransform(filterImage.size, CGAffineTransformMakeScale(300.0/filterImage.size.width, 300.0/filterImage.size.height))
    let hasAlpha = false
    let scale: CGFloat = 0.0 // automatically use scale factor of the main screen
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
    filterImage.drawInRect(CGRect(origin: CGPointZero, size: size))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    let thumbnailData = UIImageJPEGRepresentation(scaledImage, 0.5)
    self.thisFeedItem.thumbnail = thumbnailData
    
    (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func shareToFacebook(indexPath: NSIndexPath) {
    let filterImage = self.filteredImageFromImage(self.thisFeedItem.image, filter: self.filters[indexPath.row])
    let photos:NSArray = [filterImage]
    let params = FBPhotoParams()
    params.photos = photos
    
    FBDialogs.presentShareDialogWithPhotoParams(params, clientState: nil) { (call, result, error) -> Void in
      if (result? != nil) {
        println(result)
      } else {
        println(error)
      }
    }
  }
  
  // MARK: - Caching
  func cacheImage(imageNumber: Int) {
    let fileName = "\(imageNumber)"
    let uniquePath = tmp.stringByAppendingPathComponent(fileName)
    if !NSFileManager.defaultManager().fileExistsAtPath(uniquePath) {
      let data = self.thisFeedItem.thumbnail
      let filter = self.filters[imageNumber]
      let image = filteredImageFromImage(data, filter: filter)
      UIImageJPEGRepresentation(image, 1.0).writeToFile(uniquePath, atomically: true)
    }
  }
  
  func getCachedImage (imageNumber: Int) -> UIImage {
    let fileName = "\(imageNumber)"
    let uniquePath = tmp.stringByAppendingPathComponent(fileName)
    var image:UIImage
    
    if NSFileManager.defaultManager().fileExistsAtPath(uniquePath) {
      image = UIImage(contentsOfFile: uniquePath)!
    } else {
      self.cacheImage(imageNumber)
      image = UIImage(contentsOfFile: uniquePath)!
    }
    return image
  }
}

// MARK: - UICollectioniewDataSource
extension FilterViewController: UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filters.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterCell", forIndexPath: indexPath) as FilterCell
    
    cell.imageView.image = placeHolderImage
    cell.captionLabel.text = "\(indexPath.row)"
    
    let filterQueue:dispatch_queue_t = dispatch_queue_create("filter queue", nil)
    dispatch_async(filterQueue, { () -> Void in
      let filterImage = self.getCachedImage(indexPath.row)
      
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        cell.imageView.image = filterImage
      })
      
    })
    
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension FilterViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    createUIAlertController(indexPath)
  }
}
