//
//  CategoryController.swift
//  JJ
//
//  Created by Roman Spirichkin on 8/11/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit

final class CategoryController: UITableViewController {
  
  private let navBarTitleButton = UIButton(type: .custom)
  fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  
  private var categories = [CategoryManager]()
  private var currentIndex: Int? {
    didSet {
      guard currentIndex != nil else { return }
      navBarTitleButton.setTitle(currentCategoryManager?.name, for: .normal)
      activityIndicatorView.startAnimating()
      currentCategoryManager?.load()
    }
  }
  
  fileprivate var currentCategoryManager: CategoryManager? {
    guard let currentIndex = currentIndex else { return nil }
    return categories[currentIndex]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
   _ = AllCategoriesManager() {
      self.categories = $0.map { CategoryManager(category: $0, delegate: self) }
      self.didLoadCategories()
    }
  }
  
  @IBAction func didPullToRefresh(_ sender: Any) {
    currentCategoryManager?.load(isRefresh: true)
  }
  
  @objc private func didTapNavBar() {
    let titles = categories.map { $0.name ?? "" }
    let vc = SelectItemModalController(titles: titles, selectedIndex: currentIndex) {
      guard self.currentIndex != $0 else { return }
      self.currentIndex = $0
      self.tableView.reloadData()
    }
    navigationController?.pushViewController(vc, animated: true)
  }
  
  private func didLoadCategories() {
    if categories.count > 0 {
      currentIndex = 0
    }
    activityIndicatorView.activityIndicatorViewStyle = .gray
    tableView.backgroundColor = .white
    tableView.refreshControl?.isEnabled = true
  }
  
  private func setupViews() {
    let navBarHeight = navigationController?.navigationBar.frame.height ?? 0
    navBarTitleButton.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth/2, height: navBarHeight)
    navBarTitleButton.addTarget(self, action: #selector(didTapNavBar), for: .touchUpInside)
    navBarTitleButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
    navBarTitleButton.setTitleColor(.red, for: .normal)
    navBarTitleButton.setTitle("", for: .normal)
    navigationItem.titleView = navBarTitleButton
    navBarTitleButton.sizeToFit()
    
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView()
    tableView.backgroundColor = .lightGray
    tableView.refreshControl?.isEnabled = false
    tableView.register(PostCell.self, forCellReuseIdentifier: "post")
    
    tableView.backgroundView = activityIndicatorView
    activityIndicatorView.hidesWhenStopped = true
    activityIndicatorView.startAnimating()
  }
  
}

// MARK: - UITableViewDataSource

extension CategoryController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentCategoryManager?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as? PostCell
      else { return UITableViewCell() }
    cell.post = currentCategoryManager?[indexPath.row]
    return cell
  }
  
}

// MARK: - UITableViewDelegate

extension CategoryController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let post = currentCategoryManager?[indexPath.row] else { return }
    let postController = PostController(post: post)
    navigationController?.pushViewController(postController, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
}

// MARK: - CategoryManagerDelegate

extension CategoryController: CategoryManagerDelegate {
  
  func didLoaded(categoryManager: CategoryManager) {
    guard currentCategoryManager === categoryManager else { return }
    activityIndicatorView.stopAnimating()
    tableView.reloadData()
  }
  
  func didRefreshed(categoryManager: CategoryManager) {
    guard currentCategoryManager === categoryManager else { return }
    tableView.reloadData()
    activityIndicatorView.stopAnimating()
    refreshControl?.endRefreshing()
  }
  
}
