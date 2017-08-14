//
//  Category.swift
//  JJ
//
//  Created by Roman Spirichkin on 8/11/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation

final class Category {
  
  private(set) var id: Int
  private(set) var slug: String
  private(set) var name: String?
  
  required init?(json: [String: Any]) {
    guard
      let id = json["id"] as? Int,
      let slug = json["slug"] as? String
      else { return nil }
    self.id = id
    self.slug = slug
    name = json["name"] as? String
  }
  
}


