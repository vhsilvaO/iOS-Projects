//
//  NotificationCell.swift
//  InstagramFirestoreTutorial
//
//  Created by vicoliveira on 12/12/22.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String)
    func cell(_ cell: NotificationCell, wantsToFUnfollow uid: String)
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String)
}

class NotificationCell: UITableViewCell {
    
    //MARK: - Properties
    
    var viewModel: NotificationViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var postImageView: UIImageView  = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        
        let tap = UIGestureRecognizer(target: self, action: #selector(handlePostTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
        return imageView
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSelectionStyle()
        setupComponentsUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Components
    
    func setupSelectionStyle() {
        selectionStyle = .none
    }
    
    func setupComponentsUI() {
        setupProfileImageViewConstraints()
        setupPostImageViewConstraints()
        setupFollowButtonConstraints()
        setupInfoLabelConstraints()
    }
    
    func setupProfileImageViewConstraints() {
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
    }
    
    func setupPostImageViewConstraints() {
        contentView.addSubview(postImageView)
        postImageView.centerY(inView: self)
        postImageView.anchor(right: rightAnchor, paddingRight: 12, width: 40, height: 40)
    }
    
    func setupFollowButtonConstraints() {
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor, paddingRight: 12, width: 88, height: 32)
    }
    
    func setupInfoLabelConstraints() {
        contentView.addSubview(infoLabel)
        infoLabel.centerY(inView: profileImageView,
                        leftAnchor: profileImageView.rightAnchor,
                        paddingLeft: 8)
        infoLabel.anchor(right: followButton.leftAnchor, paddingRight: 4)
    }
    
    //MARK: - Actions
    
    @objc func handleFollowTapped() {
        guard let viewModel = viewModel else { return }
        
        if viewModel.notification.userIsFollowed {
            delegate?.cell(self, wantsToFUnfollow: viewModel.notification.uid)
        } else {
            delegate?.cell(self, wantsToFollow: viewModel.notification.uid)
        }
    }
    
    @objc func handlePostTapped() {
        guard let postId = viewModel?.notification.postId else { return }
        delegate?.cell(self, wantsToViewPost: postId)
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }

        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        postImageView.sd_setImage(with: viewModel.postImageUrl)
        infoLabel.attributedText = viewModel.notificationMessage
        followButton.isHidden = !viewModel.shouldHidePostImage
        postImageView.isHidden = viewModel.shouldHidePostImage
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.backgroundColor = viewModel.followButtonBackgroundColor
        followButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
    }
}
