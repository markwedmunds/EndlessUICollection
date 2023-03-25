//
//  PostCell.swift
//  EndlessList
//
//  Created by Mark Edmunds on 25/03/2023.
//

import UIKit

class PostCell: UICollectionViewCell {
  static let reuseIdentifier = "PostCell"
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = UIFont.boldSystemFont(ofSize: 20)
    return label
  }()
  
  private lazy var bodyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 16)
    return label
  }()
  
  private lazy var skeletonView: SkeletonView = {
    let view = SkeletonView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isHidden = true
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .systemGray
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(bodyLabel)
    addSubview(skeletonView)
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      
      bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
      bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      
      skeletonView.topAnchor.constraint(equalTo: topAnchor),
      skeletonView.leadingAnchor.constraint(equalTo: leadingAnchor),
      skeletonView.trailingAnchor.constraint(equalTo: trailingAnchor),
      skeletonView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func showSkeleton() {
    skeletonView.isHidden = false
    skeletonView.bringSubviewToFront(contentView)
    skeletonView.animateGradient()
  }
  
  func hideSkeleton() {
    skeletonView.isHidden = true
    skeletonView.stopAnimation()
  }
  
  func configure(with post: Post) {
    titleLabel.text = post.title
    bodyLabel.text = post.body
  }
}
