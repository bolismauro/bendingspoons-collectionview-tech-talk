//
//  BasicExampleView.swift
//  CollectionViewTalk
//
//  Created by Mauro Bolis on 07/02/2018.
//  Copyright © 2018 Mauro Bolis. All rights reserved.
//

import Foundation
import UIKit

final class CustomAttributesExampleView: UIView {
  lazy var grid: UICollectionView = {
    let collection = UICollectionView(frame: .zero, collectionViewLayout: CustomAttributesExampleLayout())
    collection.dataSource = self
    collection.delegate = self
    
    collection.register(CustomAttributesExampleCell.self, forCellWithReuseIdentifier: "cell")
    
    collection.register(
      CustomAttributesExampleHeader.self,
      forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
      withReuseIdentifier: "header"
    )
    
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

extension CustomAttributesExampleView: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    
    guard kind == UICollectionElementKindSectionHeader else {
      fatalError("Cannot manage this kind")
    }
    
    return collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: "header",
      for: indexPath
    )
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1000
  }
}

final class CustomAttributesExampleCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.style()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.style()
  }
  
  private func style() {
    self.backgroundColor = UIColor.randomFlatColor()
  }
}

final class CustomAttributesExampleHeader: UICollectionReusableView {
  static let standardHeight: CGFloat = 200.0
  static let minimumHeight: CGFloat = 50.0

  lazy var titleLabel = UILabel()
  
  var scrollTransitionPercentage: CGFloat = 0.0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
  }
  
  private func setup() {
    self.addSubview(self.titleLabel)
    self.style()
  }
  
  private func style() {
    self.backgroundColor = UIColor.randomFlatColor()
    
    self.titleLabel.text = "This is a stretching header"
    self.titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    self.titleLabel.adjustsFontSizeToFitWidth = true
    self.titleLabel.minimumScaleFactor = 0.1
    self.titleLabel.lineBreakMode = .byTruncatingHead
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let size = self.titleLabel.sizeThatFits(CGSize(
      width: self.frame.size.width * 0.8,
      height: self.frame.size.width * 0.6
    ))
    
    let availableSpace = (self.frame.width - size.width) / 2.0 - 10
    let translation = self.scrollTransitionPercentage * availableSpace
    
    self.titleLabel.frame = CGRect(
      x: self.bounds.midX - size.width / 2.0 - translation,
      y: self.bounds.midY - size.height / 2.0,
      width: size.width,
      height: size.height
    )
  }
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    
    guard let attrs = layoutAttributes as? CustomAttributesExampleLayoutAttributes else {
      return
    }
    
    let yTravelDistance = CustomAttributesExampleHeader.standardHeight - CustomAttributesExampleHeader.minimumHeight
    
    // normalize between 0 and the max travel distance
    let deltaY = min(max(0, attrs.deltaY), yTravelDistance)
    
    // map to 0, 1 interval
    self.scrollTransitionPercentage = deltaY / yTravelDistance
    
    // require new layout
    self.setNeedsLayout()
  }
}

final class CustomAttributesExampleLayout: UICollectionViewFlowLayout {
  static private let headerCompressionResistanceFactor: CGFloat = 1.0

  override class var layoutAttributesClass: AnyClass {
    return CustomAttributesExampleLayoutAttributes.self
  }
  
  override init() {
    super.init()
    self.setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
  }
  
  private func setup() {
    self.headerReferenceSize = CGSize(width: 1, height: BasicExampleHeader.standardHeight)
    self.sectionInset = UIEdgeInsetsMake(25, 15, 15, 25)
    self.minimumLineSpacing = 5
    self.minimumInteritemSpacing = 5
    self.itemSize = CGSize(width: 50, height: 50)
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard
      var layoutAttributes = super.layoutAttributesForElements(in: rect),
      let collectionView = collectionView
      
      else {
        return nil
    }
    
    // check whether we have the header attributes
    let isHeaderAvailable = layoutAttributes.contains(where: {
      return $0.representedElementKind == UICollectionElementKindSectionHeader
    })
    
    // if not, add it
    if !isHeaderAvailable {
      let idxPath = IndexPath(row: 0, section: 0)
      if let attributes = super.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: idxPath) {
        layoutAttributes.append(attributes)
      }
    }
    
    guard let typedAttributes = layoutAttributes as? [CustomAttributesExampleLayoutAttributes] else {
      return layoutAttributes
    }
    
    // manage header attributes
    let offset = collectionView.contentOffset
    let isScrollingDown = offset.y < 0
    let deltaY = abs(offset.y)
    
    for attributes in typedAttributes {
      if attributes.representedElementKind == UICollectionElementKindSectionHeader {
        attributes.deltaY = offset.y

        var frame = attributes.frame
        
        if isScrollingDown {
          frame.size.height = max(0, headerReferenceSize.height + deltaY / CustomAttributesExampleLayout.headerCompressionResistanceFactor)
          frame.origin.y = frame.minY - deltaY
        
        } else {
          frame.size.height = max(BasicExampleHeader.minimumHeight, headerReferenceSize.height - deltaY)
          frame.origin.y = frame.minY + deltaY
        }
        
        attributes.frame = frame
      }
    }
    
    return layoutAttributes
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}

final class CustomAttributesExampleLayoutAttributes: UICollectionViewLayoutAttributes {
  /// The Delta Y value for the header
  var deltaY: CGFloat = 0.0
  
  override func copy(with zone: NSZone? = nil) -> Any {
    let copy = super.copy(with: zone) as! CustomAttributesExampleLayoutAttributes
    copy.deltaY = self.deltaY
    return copy
  }
  
  override func isEqual(_ object: Any?) -> Bool {
    guard let o = object as? CustomAttributesExampleLayoutAttributes else {
      return false
    }
    
    if o.deltaY != self.deltaY {
      return false
    }
    
    return super.isEqual(object)
  }
}
