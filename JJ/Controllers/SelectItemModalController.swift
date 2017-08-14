//
//  SelectItemModalController.swift
//  JJ
//
//  Created by Roman Spirichkin on 8/13/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit

class SelectItemModalController: UITableViewController {
  
  fileprivate let items: [String]
  fileprivate let completion: (Int) -> Void
  fileprivate var selectedIndex: Int?
  
  required init(titles: [String], selectedIndex: Int?, completion: @escaping (Int) -> Void) {
    self.items = titles
    self.completion = completion
    self.selectedIndex = selectedIndex
    super.init(style: .plain)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension SelectItemModalController {
  
  // MARK: - UITableViewDataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    if let selectedIndex = selectedIndex, selectedIndex == indexPath.row {
      cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    } else {
      cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    cell.textLabel?.text = items[indexPath.row]
    return cell
  }
  
}

extension SelectItemModalController {
  
  // MARK: - UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    completion(indexPath.row)
    navigationController?.popViewController(animated: true)
  }
  
}
