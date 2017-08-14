//
//  Post.swift
//  JJ
//
//  Created by Roman Spirichkin on 8/13/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation
import Kingfisher

final class Post {
  
  private(set) var id: Int
  private(set) var name: String?
  private(set) var tagline: String?
  private(set) var votes: Int?
  private(set) var redirectPath: String?
  private(set) var screenshotPath: String?
  private(set) var thumbnailPath: String?
  
  required init?(json: [String: Any]) {
    guard let id = json["id"] as? Int else { return nil }
    self.id = id
    name = json["name"] as? String
    tagline = json["tagline"] as? String
    votes = json["votes_count"] as? Int
    redirectPath = json["redirect_url"] as? String
    screenshotPath = (json["screenshot_url"] as? [String: Any])?["850px"] as? String
    thumbnailPath = (json["thumbnail"] as? [String: Any])?["image_url"] as? String
  }
  
}
