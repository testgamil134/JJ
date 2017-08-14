//
//  Constants.swift
//  JJ
//
//  Created by Roman Spirichkin on 8/11/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit

enum API {
  
  static let token = "591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"
  static let basePath = "https://api.producthunt.com"
  
}

enum Constants {
  
  static let refreshDelay = 5.0
  static var screenWidth: CGFloat = {
    return min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
  }()
  
}



