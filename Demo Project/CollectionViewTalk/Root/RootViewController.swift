//
//  ViewController.swift
//  CollectionViewTalk
//
//  Created by Mauro Bolis on 07/02/2018.
//  Copyright © 2018 Mauro Bolis. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
  override func loadView() {
    self.view = RootView()
  }
  
  var typedView: RootView {
    return self.view as! RootView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Examples"
    self.setupInteractions()
  }
  
  private func setupInteractions() {
    self.typedView.userDidTapAtIndex = { [weak self] (idx: Int) in
      let vcType = RootViewController.viewControllers[idx].vc
      let vc = vcType.init()
      self?.navigationController?.pushViewController(vc, animated: true)
    }
  }
}

extension RootViewController {
  static let viewControllers: [(title: String, vc: UIViewController.Type)] = [
    ("Basic", BasicExampleViewController.self),
    ("Custom Attributes", CustomAttributesExampleViewController.self),
    ("Circular Menu", CircularMenuExampleViewController.self),
    ("Auto Sizing", AutoSizingExampleViewController.self),
    ("UIKit Dynamics", UIKitDynamicsExampleViewController.self),
  ]
}

