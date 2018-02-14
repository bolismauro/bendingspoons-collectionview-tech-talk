//
//  CircularMenuExampleViewController.swift
//  CollectionViewTalk
//
//  Created by Mauro Bolis on 07/02/2018.
//  Copyright © 2018 Mauro Bolis. All rights reserved.
//

import Foundation
import UIKit

class CircularMenuExampleViewController: UIViewController {
  override func loadView() {
    self.view = CircularMenuExampleView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Circular Menu"
  }
}
