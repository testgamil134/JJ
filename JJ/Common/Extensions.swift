//
//  Extensions.swift
//  JJ
//
//  Created by Roman Spirichkin on 8/13/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit

extension UIImage {
  
  convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    self.init(cgImage: image.cgImage!)
  }
  
}

extension NSAttributedString {
  
  func calculateHeight(for width: CGFloat) -> CGFloat {
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    return ceil(boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).height)
  }
  
}