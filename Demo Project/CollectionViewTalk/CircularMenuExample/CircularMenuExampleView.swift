//
//  CircularMenuExampleView.swift
//  CollectionViewTalk
//
//  Created by Mauro Bolis on 07/02/2018.
//  Copyright © 2018 Mauro Bolis. All rights reserved.
//

import Foundation
import UIKit

final class CircularMenuExampleView: UIView {
  lazy var grid: UICollectionView = {
    let collection = UICollectionView(frame: .zero, collectionViewLayout: CircularMenuExampleCollectionLayout())
    collection.dataSource = self
    collection.delegate = self
    
    collection.register(CircularMenuExampleCell.self, forCellWithReuseIdentifier: "cell")
    
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

extension CircularMenuExampleView: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CircularMenuExampleCell
    cell.content = words[indexPath.row]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return words.count
  }
}

final class CircularMenuExampleCell: UICollectionViewCell {
  private static let labelHorizontalPadding: CGFloat = 20.0
  private static let labelVerticalPadding: CGFloat = 10.0
  
  lazy var titleLabel = UILabel()
  
  var content: String? {
    didSet {
      guard self.content != oldValue else {
        return
      }
      
      self.titleLabel.text = content
      self.setNeedsLayout()
    }
  }
  
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
    self.contentView.addSubview(self.titleLabel)
  }
  
  private func style() {
    self.backgroundColor = UIColor.randomFlatColor()
    
    self.layer.cornerRadius = CircularMenuExampleCollectionLayout.cellHeight / 2.0
    self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    
    self.titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
    self.titleLabel.textColor = UIColor(white: 0, alpha: 0.9)
    self.titleLabel.adjustsFontSizeToFitWidth = true
    self.titleLabel.minimumScaleFactor = 0.1
    self.titleLabel.lineBreakMode = .byTruncatingTail
    self.titleLabel.textAlignment = .right
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.titleLabel.frame = CGRect(
      x: CircularMenuExampleCell.labelHorizontalPadding,
      y: CircularMenuExampleCell.labelVerticalPadding,
      width: self.frame.size.width - 2 * CircularMenuExampleCell.labelHorizontalPadding,
      height: self.frame.size.height - 2 * CircularMenuExampleCell.labelVerticalPadding
    )
  }
  
  override func prepareForReuse() {
    self.content = nil
  }
}

final class CircularMenuExampleCollectionLayout: UICollectionViewLayout {
  static let cellWidthPercentage: CGFloat = 0.8
  static let cellHeight: CGFloat = 50.0
  static let cellSpacing: CGFloat = 10.0

  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override var collectionViewContentSize: CGSize {
    guard
      let collection = self.collectionView,
      let dataSource = collection.dataSource
      
    else {
      return .zero
    }
    
    let numCells = CGFloat(dataSource.collectionView(collection, numberOfItemsInSection: 0))
    
    let height =
      (numCells * CircularMenuExampleCollectionLayout.cellHeight) +
      (numCells - 1) * CircularMenuExampleCollectionLayout.cellSpacing
    
    
    return CGSize(width: collection.frame.width, height: height)
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard
      let collectionView = collectionView,
      let datasource = collectionView.dataSource
      
      else {
        return nil
    }
    
    let maxItemAmount = datasource.collectionView(collectionView, numberOfItemsInSection: 0)
    let initialY = max(rect.origin.y, 0.0)
    let space = rect.origin.y >= 0 ? rect.size.height : (rect.size.height + rect.origin.y)
    
    if space < 0 {
      return []
    }
    
    let cellSpace = CircularMenuExampleCollectionLayout.cellHeight + CircularMenuExampleCollectionLayout.cellSpacing
    let initialCellIdx = Int(floor(initialY / cellSpace))
    let visibleCellsAmount = Int(ceil(space / cellSpace))
    let lastVisibleCellIdx = min(maxItemAmount, initialCellIdx + visibleCellsAmount)
    
    let collectionViewYCenter = collectionView.contentOffset.y + collectionView.bounds.height / 2.0
    let collectionViewYScrollSpace = collectionView.bounds.height / 2.0
    let cellWidth = collectionView.bounds.width * CircularMenuExampleCollectionLayout.cellWidthPercentage
    
    var attributes: [UICollectionViewLayoutAttributes] = []
    
    for i in initialCellIdx..<lastVisibleCellIdx {
      let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
      
      cellAttributes.frame = CGRect(
        x: 0.0,
        y: CGFloat(i) * (cellSpace),
        width: cellWidth,
        height: CircularMenuExampleCollectionLayout.cellHeight
      )

      let distanceFromCenter = abs(cellAttributes.frame.origin.y - collectionViewYCenter)
      let transformPercentage = distanceFromCenter / collectionViewYScrollSpace
      
      let transform = CGAffineTransform(translationX: -cellWidth * transformPercentage, y: 0)
      
      cellAttributes.transform = transform

      attributes.append(cellAttributes)
    }
    
    return attributes
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}

private let words: [String] = [
  "Lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit", "Donec", "non", "mi", "at", "diam", "ullamcorper", "malesuada", "Aenean", "porttitor", "ipsum", "nisi", "ac", "maximus", "ipsum", "egestas", "nec", "Integer", "molestie", "elementum", "arcu", "at", "vulputate", "tortor", "sodales", "ac", "In", "vitae", "nisi", "vitae", "nibh", "ultricies", "commodo", "Aenean", "egestas", "dolor", "arcu", "a", "vehicula", "erat", "placerat", "id", "Phasellus", "a", "tristique", "lectus", "Sed", "mauris", "orci", "pharetra", "quis", "commodo", "in", "gravida", "quis", "leo", "Duis", "eget", "volutpat", "est", "sed", "pulvinar", "lacus", "Maecenas", "turpis", "ipsum", "sagittis", "eget", "neque", "vitae", "iaculis", "scelerisque", "leo", "Aliquam", "eget", "tempus", "turpis", "Nunc", "placerat", "eu", "ligula", "vel", "venenatis", "Morbi", "leo", "lorem", "mollis", "et", "turpis", "et", "viverra", "auctor", "ligula", "Cras", "facilisis", "luctus", "turpis", "vel", "pretium", "Curabitur", "scelerisque", "risus", "erat", "quis", "tempor", "lectus", "hendrerit", "nec", "Nam", "aliquam", "nisl", "luctus", "efficitur", "egestas", "libero", "lacus", "auctor", "lectus", "non", "scelerisque", "turpis", "mi", "vel", "lacus", "Sed", "sed", "mi", "lorem", "Interdum", "et", "malesuada", "fames", "ac", "ante", "ipsum", "primis", "in", "faucibus", "Phasellus", "imperdiet", "mauris", "turpis", "at", "pharetra", "tellus", "egestas", "eget", "Pellentesque", "tempus", "est", "quis", "enim", "sollicitudin", "quis", "iaculis", "turpis", "interdum", "Donec", "sollicitudin", "hendrerit", "orci", "sit", "amet", "varius", "orci", "sodales", "congue", "Praesent", "maximus", "eros", "erat", "vitae", "ultrices", "justo", "ultricies", "quis", "Etiam", "nibh", "nisi", "gravida", "eu", "nunc", "et", "imperdiet", "hendrerit", "justo", "Phasellus", "finibus", "metus", "nec", "quam", "elementum", "lobortis", "Aliquam", "tempor", "velit", "eget", "dictum", "pulvinar", "Orci", "varius", "natoque", "penatibus", "et", "magnis", "dis", "parturient", "montes", "nascetur", "ridiculus", "mus", "Sed", "lacus", "magna", "fermentum", "ut", "massa", "et", "condimentum", "fermentum", "justo", "Vestibulum", "sed", "malesuada", "libero", "Vestibulum", "ut", "interdum", "mauris", "vel", "dapibus", "felis", "Donec", "at", "sem", "et", "erat", "vehicula", "elementum", "ac", "eu", "nulla", "Aenean", "sed", "turpis", "ipsum", "Aliquam", "ex", "mi", "fermentum", "id", "molestie", "a", "eleifend", "vestibulum", "lacus", "In", "in", "feugiat", "arcu", "ac", "pharetra", "eros", "Integer", "dolor", "ligula", "sodales", "at", "tristique", "vitae", "vulputate", "vitae", "ipsum", "Quisque", "eu", "congue", "lacus", "Curabitur", "rhoncus", "ac", "nisl", "ut", "pulvinar", "Integer", "tristique", "sagittis", "aliquet", "Maecenas", "maximus", "sollicitudin", "justo", "eget", "porttitor", "nisl", "blandit", "eget", "Nulla", "dictum", "erat", "metus", "lacinia", "condimentum", "est", "mollis", "nec", "Sed", "rhoncus", "placerat", "placerat", "Nulla", "tempus", "purus", "tempus", "porttitor", "porttitor", "Fusce", "tempor", "nulla", "in", "porta", "euismod", "Sed", "suscipit", "ultricies", "mollis", "Phasellus", "tortor", "arcu", "porta", "vel", "lacinia", "vitae", "efficitur", "a", "diam", "Donec", "sed", "maximus", "lacus", "Vivamus", "sit", "amet", "gravida", "massa", "Vestibulum", "eget", "interdum", "orci", "Proin", "porta", "nisl", "quis", "pretium", "commodo", "augue", "dolor", "accumsan", "ex", "nec", "imperdiet", "mi", "orci", "ac", "orci", "Nulla", "libero", "erat", "vehicula", "vitae", "orci", "vel", "molestie", "dapibus", "erat", "Nam", "a", "ipsum", "risus", "Aliquam", "eu", "felis", "laoreet", "urna", "euismod", "tempor", "ut", "euismod", "diam", "Morbi", "elementum", "congue", "consectetur", "Nullam", "ut", "condimentum", "dolor", "Phasellus", "nisi", "magna", "lobortis", "sit", "amet", "leo", "vitae", "fermentum", "semper", "nisi", "Vivamus", "ornare", "mi", "ut", "ornare", "facilisis", "Vestibulum", "vel", "porta", "sapien", "Praesent", "gravida", "vestibulum", "ligula", "Donec", "dignissim", "leo", "felis", "in", "scelerisque", "nisi", "laoreet", "a", "In", "tortor", "orci", "feugiat", "in", "sem", "eu", "convallis", "ultrices", "tortor", "Donec", "auctor", "condimentum", "elit", "Ut", "scelerisque", "a", "nisi", "et", "aliquet", "Proin", "magna", "nisi", "venenatis", "vel", "bibendum", "vel", "faucibus", "nec", "leo", "Praesent", "sit", "amet", "laoreet", "urna", "in", "dapibus", "enim", "Integer", "egestas", "libero", "eget", "lacus", "vehicula", "pharetra", "Quisque", "rutrum", "tristique", "tortor", "nec", "suscipit", "Vestibulum", "euismod", "elementum", "pellentesque", "Vestibulum", "a", "nisl", "sed", "nunc", "tristique", "imperdiet", "Vivamus", "at", "leo", "neque", "Curabitur", "elementum", "ultrices", "ipsum", "Ut", "non", "hendrerit", "mauris", "nec", "aliquam", "orci", "Quisque", "imperdiet", "fermentum", "lorem", "vel", "ornare", "neque", "cursus", "sit", "amet", "Duis", "fermentum", "metus", "in", "porttitor", "sollicitudin", "purus", "justo", "pharetra", "sapien", "nec", "consequat", "felis", "ligula", "vitae", "sem", "Maecenas", "molestie", "ornare", "tristique", "Vestibulum", "eu", "augue", "consectetur", "semper", "sem", "id", "feugiat", "ligula", "Interdum", "et", "malesuada", "fames", "ac", "ante", "ipsum", "primis", "in", "faucibus", "Nunc", "nec", "auctor", "eros", "nec", "porta", "est", "Nam", "nec", "venenatis", "erat", "Suspendisse", "faucibus", "massa", "nec", "diam", "mattis", "ac", "tincidunt", "arcu", "malesuada", "Integer", "urna", "erat", "euismod", "sit", "amet", "risus", "ut", "lobortis", "porta", "ipsum", "Morbi", "imperdiet", "sodales", "felis", "Ut", "ut", "eleifend", "sem", "vitae", "varius", "nisi", "Donec", "diam", "leo", "vulputate", "quis", "elit", "vitae", "viverra", "rutrum", "quam", "Morbi", "nec", "volutpat", "nisi", "Nullam", "non", "tortor", "sit", "amet", "dui", "egestas", "sodales", "Aliquam", "sit", "amet", "tortor", "sem", "Pellentesque", "lacinia", "sed", "nibh", "quis", "mollis", "Pellentesque", "sagittis", "lorem", "nec", "nibh", "hendrerit", "iaculis", "Morbi", "ante", "leo", "suscipit", "sit", "amet", "nisi", "ut", "maximus", "fermentum", "mauris", "Duis", "a", "accumsan", "odio", "Morbi", "maximus", "varius", "ligula", "in", "fermentum", "Phasellus", "sit", "amet", "viverra", "sem", "Nulla", "convallis", "est", "quis", "odio", "vehicula", "sit", "amet", "finibus", "tortor", "ultrices", "Praesent", "sit", "amet", "elit", "dignissim", "ornare", "dui", "vel", "placerat", "purus", "Pellentesque", "habitant", "morbi", "tristique", "senectus", "et", "netus", "et", "malesuada", "fames", "ac", "turpis", "egestas", "Maecenas", "id", "dapibus", "massa", "Sed", "ultrices", "laoreet", "justo", "quis", "semper", "leo", "laoreet", "ac", "Duis", "et", "purus", "imperdiet", "congue", "justo", "eu", "iaculis", "augue", "Morbi", "laoreet", "quis", "urna", "in", "vulputate", "Suspendisse", "vel", "nibh", "convallis", "accumsan", "neque", "ac", "vulputate", "mi", "Duis", "imperdiet", "neque", "sed", "quam", "dictum", "ut", "ornare", "quam", "sodales", "Nullam", "vel", "tortor", "at", "ante", "consectetur", "vulputate", "Sed", "dignissim", "finibus", "nisi", "vitae", "pharetra", "leo", "ornare", "eget", "Curabitur", "viverra", "augue", "vitae", "efficitur", "dapibus", "lacus", "mauris", "egestas", "elit", "quis", "rutrum", "est", "magna", "vitae", "tortor", "Mauris", "feugiat", "vestibulum", "tortor", "eget", "venenatis", "velit", "laoreet", "eu", "Proin", "venenatis", "massa", "vel", "purus", "tempus", "non", "molestie", "ante", "egestas", "Integer", "et", "sollicitudin", "mauris", "blandit", "cursus", "odio", "Cras", "consectetur", "dignissim", "ex", "at", "lacinia", "Curabitur", "non", "porttitor", "felis", "non", "placerat", "augue", "Donec", "vel", "tellus", "eleifend", "tincidunt", "mauris", "sed", "commodo", "dui", "Proin", "ante", "odio", "egestas", "sed", "convallis", "et", "consectetur", "et", "leo", "Vestibulum", "nec", "efficitur", "diam", "Maecenas", "viverra", "ut", "lectus", "non", "elementum", "Fusce", "faucibus", "luctus", "tempor", "Suspendisse", "dapibus", "ipsum", "dui", "in", "tempor", "lacus", "feugiat", "eget", "Phasellus", "at", "dolor", "a", "nibh", "pretium", "lobortis", "Nulla", "facilisi", "Fusce", "sit", "amet", "mauris", "justo", "Sed", "sit", "amet", "maximus", "tellus", "Nunc", "a", "turpis", "nec", "sem", "rhoncus", "blandit", "et", "et", "risus", "Morbi", "id", "magna", "metus", "Maecenas", "id", "ante", "ornare", "convallis", "magna", "sit", "amet", "egestas", "dolor", "Donec", "mattis", "lectus", "at", "dapibus", "malesuada", "Aliquam", "arcu", "odio", "vestibulum", "at", "libero", "sit", "amet", "vulputate", "ultricies", "libero", "Praesent", "posuere", "accumsan", "enim", "vel", "venenatis", "turpis", "vestibulum", "vel", "Aenean", "neque", "magna", "tempus", "id", "tincidunt", "nec", "porta", "non", "nisi", "Sed", "eu", "sodales", "lorem", "Morbi", "ullamcorper", "eu", "urna", "ac", "venenatis", "Mauris", "facilisis", "turpis", "in", "mauris", "bibendum", "mollis", "Sed", "dapibus", "ullamcorper", "finibus", "Quisque", "mollis", "ligula", "vel", "sollicitudin", "rhoncus", "In", "et", "est", "mi", "Morbi", "vestibulum", "magna", "eu", "lobortis", "ultrices", "augue", "odio", "sagittis", "erat", "id", "tincidunt", "massa", "neque", "vel", "lorem", "Suspendisse", "lectus", "velit", "blandit", "in", "rutrum", "non", "ornare"
]
