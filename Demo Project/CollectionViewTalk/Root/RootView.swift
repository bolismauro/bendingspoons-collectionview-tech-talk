//
//  RootView.swift
//  CollectionViewTalk
//
//  Created by Mauro Bolis on 07/02/2018.
//  Copyright © 2018 Mauro Bolis. All rights reserved.
//

import Foundation
import UIKit

final class RootView: UIView {
  lazy var tableView: UITableView = UITableView(frame: .zero, style: .plain)
  
  var userDidTapAtIndex: ((Int) -> Void)? = nil
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
  }
  
  private func setup() {
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.tableFooterView = nil
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    self.addSubview(self.tableView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.tableView.frame = self.bounds
  }
}

extension RootView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return RootViewController.viewControllers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.accessoryType = .disclosureIndicator
    cell.textLabel?.text = RootViewController.viewControllers[indexPath.row].title
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    self.userDidTapAtIndex?(indexPath.row)
  }
}
