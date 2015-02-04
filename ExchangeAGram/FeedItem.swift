//
//  FeedItem.swift
//  ExchangeAGram
//
//  Created by Kenneth Wilcox on 2/3/15.
//  Copyright (c) 2015 Kenneth Wilcox. All rights reserved.
//

import Foundation
import CoreData

@objc(FeedItem)
class FeedItem: NSManagedObject {

  @NSManaged var caption: String
  @NSManaged var image: NSData
  @NSManaged var thumbnail: NSData

}
