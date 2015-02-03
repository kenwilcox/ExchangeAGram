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
    self.view.addSubview(collectionView)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

// MARK: - UICollectioniewDataSource
extension FilterViewController: UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    return UICollectionViewCell()
  }
}

// MARK: - UICollectionViewDelegate
extension FilterViewController: UICollectionViewDelegate {
  
}
