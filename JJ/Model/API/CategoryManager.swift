//
//  CategoryManager.swift
//  JJ
//
//  Created by Roman Spirichkin on 8/11/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation
import Alamofire


// MARK: - CategoryManagerDelegate

protocol CategoryManagerDelegate: class {
  
  func didLoaded(categoryManager: CategoryManager)
  
  func didRefreshed(categoryManager: CategoryManager)
  
}

// MARK: - CategoryManager

final class CategoryManager {
  
  private let category: Category
  private weak var delegate: CategoryManagerDelegate?
  
  private var posts = [Post]()

  private var loadRequest: DataRequest?
  private var isEmpty = true {
    didSet {
      if isEmpty {
        posts.removeAll()
      }
    }
  }
  private var isRefresh = false {
    didSet {
      if isRefresh {
        loadRequest?.cancel()
        loadRequest = nil
      }
    }
  }
  
  required init(category: Category, delegate: CategoryManagerDelegate?) {
    self.category = category
    self.delegate = delegate
  }
  
  var name: String? {
    return category.name
  }
  
  var count: Int {
    return posts.count
  }
  
  subscript (index: Int) -> Post {
    return posts[index]
  }
  
  func load(isRefresh willRefresh: Bool = false) {
    if willRefresh {
      isRefresh = true
      isEmpty = true
    }
    guard isEmpty else {
      delegate?.didLoaded(categoryManager: self)
      return
    }
    let parameters = ["access_token" : API.token]
    let URLString = API.basePath + "/v1/categories/" + category.slug + "/posts"
    guard let url = URL(string: URLString) else { return }
    self.loadRequest = Alamofire.request(url, parameters: parameters).responseJSON {
      debugPrint($0.request ?? "error request")
      guard let json = $0.result.value as? Dictionary<String, Any> else {
          self.loadAfterFailed(isRefresh: willRefresh)
          return
      }
      defer {
        self.isEmpty = false
        self.loadRequest = nil
      }
      let results = json["posts"] as? [Dictionary<String, Any>]
      let newPosts = results?.flatMap { Post(json: $0) } ?? []
      if willRefresh {
        self.posts = newPosts
        self.isRefresh = false
        self.delegate?.didRefreshed(categoryManager: self)
      } else {
        self.posts += newPosts
        self.delegate?.didLoaded(categoryManager: self)
      }
    }
  }
  
  private func loadAfterFailed(isRefresh: Bool) {
    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.refreshDelay) { [weak self] in
      guard let `self` = self else { return }
      self.loadRequest?.cancel()
      self.loadRequest = nil
      self.load(isRefresh: isRefresh)
      debugPrint("didTryAftrerFailed")
    }
  }
  
}
