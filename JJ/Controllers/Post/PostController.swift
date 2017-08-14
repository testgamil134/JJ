//
//  PostController.swift
//  JJ
//
//  Created by Roman Spirichkin on 8/13/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit
import SnapKit
import SafariServices

final class PostController: UIViewController {
  
  private let post: Post
  
  required init(post: Post) {
    self.post = post
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = NSLocalizedString("Post", comment: "")
    let getItTitle = NSLocalizedString("Get it", comment: "")
    let getItItem = UIBarButtonItem(title: getItTitle, style: .done, target: self, action: #selector(didTapGetIt))
    navigationItem.rightBarButtonItem = getItItem
    view.backgroundColor = .white
    setupScrollView()
  }
  
  @objc private func didTapGetIt() {
    guard let redirectPath = post.redirectPath, let url = URL(string: redirectPath) else { return }
    let safariController = SFSafariViewController(url: url)
    present(safariController, animated: true)
  }
  
  private func setupScrollView() {
    let inset: CGFloat = 20
    var scrollViewHeight: CGFloat = 0
    let scrollView = UIScrollView(frame: view.frame)
    view.addSubview(scrollView)
    scrollView.sizeToFit()
    scrollView.isScrollEnabled = true
    scrollView.snp.makeConstraints {
      $0.height.equalToSuperview()
      $0.center.equalToSuperview()
      $0.width.equalToSuperview()
    }
    
    let screenshotImageView = UIImageView()
    screenshotImageView.clipsToBounds = true
    screenshotImageView.layer.masksToBounds = true
    screenshotImageView.contentMode = .scaleAspectFill
    scrollView.addSubview(screenshotImageView)
    screenshotImageView.snp.makeConstraints {
      $0.height.equalTo(Constants.screenWidth)
      $0.width.equalTo(Constants.screenWidth)
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview()
    }
    let placeholder = UIImage(color: UIColor.lightGray)
    if let screenshotPath = post.screenshotPath, let url = URL(string: screenshotPath) {
      screenshotImageView.kf.setImage(with: url, placeholder: placeholder)
    } else {
      screenshotImageView.image = placeholder
    }
    scrollViewHeight += Constants.screenWidth + inset
    
    let textView = UITextView()
    textView.isEditable = false
    textView.isSelectable = true
    textView.scrollsToTop = false
    textView.isScrollEnabled = false
    textView.textContainerInset = .zero
    textView.attributedText = textDescription
    scrollView.addSubview(textView)
    textView.snp.makeConstraints {
      $0.width.equalTo(Constants.screenWidth - 2 * inset)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(screenshotImageView.snp.bottom).offset(inset)
    }
    scrollViewHeight += textView.attributedText.calculateHeight(for: Constants.screenWidth) + inset
    
    scrollView.contentSize = CGSize(width: Constants.screenWidth, height: scrollViewHeight)
  }
  
  private var textDescription: NSAttributedString {
    let fullText = NSMutableAttributedString()
    if let name = post.name {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      let attributes = [
        NSFontAttributeName : UIFont.boldSystemFont(ofSize: 20),
        NSParagraphStyleAttributeName : paragraphStyle
      ]
      let attributedName = NSAttributedString(string: name, attributes: attributes)
      fullText.append(attributedName)
    }
    if let tagline = post.tagline {
      let attributes = [NSFontAttributeName : UIFont.systemFont(ofSize: 16)]
      let attributedTagline = NSAttributedString(string: "\n\n" + tagline, attributes: attributes)
      fullText.append(attributedTagline)
    }
    if let votes = post.votes, votes > 0 {
      let attributesBlack = [NSFontAttributeName : UIFont.systemFont(ofSize: 16)]
      fullText.append(NSAttributedString(string: "\n( ", attributes: attributesBlack))
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .left
      let attributes = [
        NSFontAttributeName : UIFont.systemFont(ofSize: 16),
        NSParagraphStyleAttributeName : paragraphStyle,
        NSForegroundColorAttributeName : UIColor.red
      ]
      let attributedVoted = NSMutableAttributedString(string: "\(votes)", attributes: attributes)
      let image = #imageLiteral(resourceName: "vote")
      let imageAttachment = NSTextAttachment()
      imageAttachment.image = image
      let width = image.size.width / image.size.height * 16
      imageAttachment.bounds = CGRect(x: 0, y: -2, width: width, height: 16)
      attributedVoted.append(NSAttributedString(attachment: imageAttachment))
      fullText.append(attributedVoted)
      fullText.append(NSAttributedString(string: ")", attributes: attributesBlack))
    }
    return fullText
  }
  
}
