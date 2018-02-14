//
//  UIColor+Random.swift
//  CollectionViewTalk
//
//  Created by Mauro Bolis on 07/02/2018.
//  Copyright © 2018 Mauro Bolis. All rights reserved.
//

import Foundation
import UIKit

fileprivate let colors: [UIColor] = [
  UIColor(red:26.0 / 255.0, green:188.0 / 255.0, blue:156.0 / 255.0, alpha:1.0),
  UIColor(red:46.0 / 255.0, green:204.0 / 255.0, blue:113.0 / 255.0, alpha:1.0),
  UIColor(red:52.0 / 255.0, green:152.0 / 255.0, blue:219.0 / 255.0, alpha:1.0),
  UIColor(red:155.0 / 255.0, green:89.0 / 255.0, blue:182.0 / 255.0, alpha:1.0),
  UIColor(red:52.0 / 255.0, green:73.0 / 255.0, blue:94.0 / 255.0, alpha:1.0),
  UIColor(red:22.0 / 255.0, green:160.0 / 255.0, blue:133.0 / 255.0, alpha:1.0),
  UIColor(red:39.0 / 255.0, green:174.0 / 255.0, blue:96.0 / 255.0, alpha:1.0),
  UIColor(red:41.0 / 255.0, green:128.0 / 255.0, blue:185.0 / 255.0, alpha:1.0),
  UIColor(red:142.0 / 255.0, green:68.0 / 255.0, blue:173.0 / 255.0, alpha:1.0),
  UIColor(red:44.0 / 255.0, green:62.0 / 255.0, blue:80.0 / 255.0, alpha:1.0),
  UIColor(red:241.0 / 255.0, green:196.0 / 255.0, blue:15.0 / 255.0, alpha:1.0),
  UIColor(red:230.0 / 255.0, green:126.0 / 255.0, blue:34.0 / 255.0, alpha:1.0),
  UIColor(red:231.0 / 255.0, green:76.0 / 255.0, blue:60.0 / 255.0, alpha:1.0),
  UIColor(red:236.0 / 255.0, green:240.0 / 255.0, blue:241.0 / 255.0, alpha:1.0),
  UIColor(red:149.0 / 255.0, green:165.0 / 255.0, blue:166.0 / 255.0, alpha:1.0),
  UIColor(red:243.0 / 255.0, green:156.0 / 255.0, blue:18.0 / 255.0, alpha:1.0),
  UIColor(red:211.0 / 255.0, green:84.0 / 255.0, blue:0.0 / 255.0, alpha:1.0),
  UIColor(red:192.0 / 255.0, green:57.0 / 255.0, blue:43.0 / 255.0, alpha:1.0),
  UIColor(red:189.0 / 255.0, green:195.0 / 255.0, blue:199.0 / 255.0, alpha:1.0),
  UIColor(red:127.0 / 255.0, green:140.0 / 255.0, blue:141.0 / 255.0, alpha:1.0)
]

extension UIColor {
  static func randomFlatColor() -> UIColor {
    let index = Int(arc4random_uniform(UInt32(colors.count)))
    return colors[index]
  }
}
