//
//  AllCategoriesManager.swift
//  JJ
//
//  Created by Roman Spirichkin on 8/13/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Alamofire

// MARK: - CategoryManager

final class AllCategoriesManager {
  
  private var completion: ([Category]) -> Void
  
  private var loadRequest: DataRequest?
  
  required init(completion: @escaping ([Category]) -> Void ) {
    self.completion = completion
    self.load()
  }
  
  private func load() {
    let parameters = ["access_token" : API.token]
    let URLString = API.basePath + "/v1/categories/"
    guard let url = URL(string: URLString) else { return }
    self.loadRequest = Alamofire.request(url, parameters: parameters).responseJSON {
      debugPrint($0.request ?? "date response request error")
      guard let json = $0.result.value as? Dictionary<String, Any> else {
        self.didFailedLoad()
        return
      }
      let categories: [Category]
      defer {
        self.loadRequest = nil
        self.completion(categories)
      }
      if let results = json["categories"] as? [Dictionary<String, Any>] {
        categories = results.flatMap { Category(json: $0) }
      } else {
        categories = []
      }
    }
  }
  
  private func didFailedLoad() {
    debugPrint("AllCategoriesManager.loadAfterFailed")
    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.refreshDelay) { [weak self] in
      guard let `self` = self else { return }
      self.loadRequest?.cancel()
      self.loadRequest = nil
      self.load()
    }
  }
  
}
