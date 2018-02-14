//
//  UIKitDynamicsView.swift
//  CollectionViewTalk
//
//  Created by Mauro Bolis on 07/02/2018.
//  Copyright © 2018 Mauro Bolis. All rights reserved.
//

import Foundation
import UIKit

final class UIKitDynamicsExampleView: UIView {
  lazy var grid: UICollectionView = {
    let collection = UICollectionView(frame: .zero, collectionViewLayout: UIKitDynamicsExampleLayout())
    collection.dataSource = self
    collection.delegate = self
    
    collection.register(UIKitDynamicsExampleCell.self, forCellWithReuseIdentifier: "cell")
    
    return collection
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
  }
  
  private func setup() {
    self.addSubview(self.grid)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.grid.frame = UIEdgeInsetsInsetRect(self.bounds, self.safeAreaInsets)
  }
}

extension UIKitDynamicsExampleView: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 100
  }
}

final class UIKitDynamicsExampleCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
    self.style()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
    self.style()
  }
  
  private func setup() {
  }
  
  private func style() {
    self.backgroundColor = UIColor.randomFlatColor()
  }
}

final class UIKitDynamicsExampleLayout: UICollectionViewFlowLayout {
  var dynamicAnimator: UIDynamicAnimator!
  
  override init() {
    super.init()
    self.setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
  }
  
  private func setup() {
    self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    self.sectionInset = UIEdgeInsetsMake(25, 15, 15, 25)
    self.minimumLineSpacing = 5
    self.minimumInteritemSpacing = 5
    self.estimatedItemSize = CGSize(width: 50, height: 50)
  }
  
  override func prepare() {
    super.prepare()

    guard
      self.dynamicAnimator.behaviors.isEmpty,
      let items: [UIDynamicItem] = super.layoutAttributesForElements(in: CGRect(origin: .zero, size: self.collectionViewContentSize))
      
    else {
      return
    }
    
    for item in items {
      let behaviour = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
      behaviour.length = 0.0
      behaviour.damping = 0.8
      behaviour.frequency = 1.0
      
      self.dynamicAnimator.addBehavior(behaviour)
    }
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return self.dynamicAnimator.items(in: rect) as? [UICollectionViewLayoutAttributes]
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return self.dynamicAnimator.layoutAttributesForCell(at: indexPath)
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    guard
      let collection = self.collectionView,
      let behaviours = self.dynamicAnimator.behaviors as? [UIAttachmentBehavior]
    
    else {
      return false
    }
    
    let delta = newBounds.origin.y - collection.bounds.origin.y
    let touchLocation = collection.panGestureRecognizer.location(in: collection)
    
    for behaviour in behaviours {
      let yDistanceFromTouch = fabs(touchLocation.y - behaviour.anchorPoint.y)
      let xDistanceFromTouch = fabs(touchLocation.x - behaviour.anchorPoint.x)
      let scrollResistence = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0
      
      guard let attributes = behaviour.items.first as? UICollectionViewLayoutAttributes else {
        continue
      }
      
      var center = attributes.center
      
      if delta < 0 {
        center.y += max(delta, delta * scrollResistence)
      
      } else {
        center.y += min(delta, delta * scrollResistence)
      }
      
      attributes.center = center
      
      self.dynamicAnimator.updateItem(usingCurrentState: attributes)
    }
    
    return false
  }
}
