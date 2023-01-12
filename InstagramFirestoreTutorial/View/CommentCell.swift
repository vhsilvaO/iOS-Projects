//
//  CommentCell.swift
//  InstagramFirestoreTutorial
//
//  Created by vicoliveira on 05/12/22.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var viewModel: CommentViewModel? {
        didSet { configure() }
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let commentLabel = UILabel()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Components
    
    func setupViewProperties() {
        setupProfileImageViewConstraints()
        setupNumberOfLines()
        setupCommentLabelConstraints()
    }
    
    func setupProfileImageViewConstraints() {
       addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
    }
    
    func setupNumberOfLines() {
        commentLabel.numberOfLines = 0
    }
    
    func setupCommentLabelConstraints() {
        addSubview(commentLabel)
        commentLabel.centerY(inView: profileImageView,
                          leftAnchor: profileImageView.rightAnchor,
                          paddingLeft: 8)
        commentLabel.anchor(right: rightAnchor, paddingRight: 8)
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        commentLabel.attributedText = viewModel.commentLabelText()
    }
}
