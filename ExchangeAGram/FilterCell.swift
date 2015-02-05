//
//  FilterCollectionViewCell.swift
//  ExchangeAGram
//
//  Created by Kenneth Wilcox on 2/3/15.
//  Copyright (c) 2015 Kenneth Wilcox. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
  
  var imageView: UIImageView!
  var captionLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
    contentView.addSubview(imageView)
    
    captionLabel = UILabel(frame: CGRect(x: 14, y: 121, width: 123, height: 21))
    captionLabel.textColor = UIColor.whiteColor()
    contentView.addSubview(captionLabel)
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
}
