//
//  PostCell.swift
//  JJ
//
//  Created by Roman Spirichkin on 8/13/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit
import SnapKit

class PostCell: UITableViewCell {
  
  private var thumbnailImageView: UIImageView!
  private var nameLabel: UILabel!
  private var taglineLabel: UILabel!
  private var votesLabel: UILabel!
  
  var post: Post? {
    didSet {
      refresh()
    }
  }
		
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func refresh() {
    nameLabel.text = post?.name
    taglineLabel.text = post?.tagline
    let placeholder = UIImage(color: UIColor.lightGray)
    if let thumbnailPath = post?.thumbnailPath, let url = URL(string: thumbnailPath) {
      thumbnailImageView?.kf.setImage(with: url, placeholder: placeholder)
    } else {
      thumbnailImageView.image = placeholder
    }
    let votes = post?.votes ?? 0
    votesLabel.text = votes > 999 ? "999+" : "\(votes)"
    votesLabel.superview?.isHidden = votes == 0
  }
  
  private func setup() {
    let inset: CGFloat = 10
    let twiceInset = 2 * inset
    
    thumbnailImageView = UIImageView()
    thumbnailImageView.clipsToBounds = true
    thumbnailImageView.layer.borderWidth = 1
    thumbnailImageView.layer.masksToBounds = true
    thumbnailImageView.contentMode = .scaleAspectFill
    contentView.addSubview(thumbnailImageView)
    thumbnailImageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(inset)
      $0.left.equalToSuperview().inset(twiceInset)
      $0.bottom.equalToSuperview().inset(inset)
      $0.height.equalTo(thumbnailImageView.snp.width)
    }
    
    nameLabel = UILabel()
    nameLabel.numberOfLines = 0
    nameLabel.setContentHuggingPriority(1000, for: .vertical)
    nameLabel.setContentCompressionResistancePriority(1000, for: .vertical)
    taglineLabel = UILabel()
    taglineLabel.numberOfLines = 0
    taglineLabel.textColor = .lightGray
    taglineLabel.font = UIFont.systemFont(ofSize: 14)
    let textStackView = UIStackView(arrangedSubviews: [nameLabel, taglineLabel])
    textStackView.axis = .vertical
    textStackView.spacing = inset / 2
    
    let votesAmbientView = UIView()
    votesLabel = UILabel()
    votesLabel.textColor = .red
    votesLabel.textAlignment = .right
    votesLabel.font = UIFont.boldSystemFont(ofSize: 12)
    votesLabel.setContentCompressionResistancePriority(1000, for: .horizontal)
    votesLabel.setContentHuggingPriority(1000, for: .horizontal)
    votesAmbientView.addSubview(votesLabel)
    votesLabel.snp.makeConstraints {
      $0.right.equalToSuperview()
      $0.left.equalToSuperview()
    }
    let upvoteImageView = UIImageView(image: #imageLiteral(resourceName: "vote"))
    upvoteImageView.contentMode = .scaleAspectFit
    votesAmbientView.addSubview(upvoteImageView)
    upvoteImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.bottom.equalTo(votesLabel.snp.top)
      $0.height.equalTo(3 * inset)
      $0.width.equalTo(twiceInset)
    }
    
    let mainStackView = UIStackView(arrangedSubviews: [textStackView, votesAmbientView])
    contentView.addSubview(mainStackView)
    mainStackView.spacing = inset
    mainStackView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.height.lessThanOrEqualTo(thumbnailImageView.snp.height)
      $0.left.equalTo(thumbnailImageView.snp.right).offset(twiceInset)
      $0.right.equalToSuperview().inset(twiceInset)
    }
    
    let separatorView = UIView()
    separatorView.backgroundColor = UIColor.lightGray
    contentView.addSubview(separatorView)
    separatorView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.bottom.equalToSuperview()
      $0.width.equalTo(mainStackView.snp.width)
      $0.centerX.equalTo(mainStackView.snp.centerX)
    }
  }
  
}
