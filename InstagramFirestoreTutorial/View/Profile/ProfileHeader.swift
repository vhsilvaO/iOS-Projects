//
//  ProfileHeader.swift
//  InstagramFirestoreTutorial
//
//  Created by vicoliveira on 24/10/22.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: AnyObject {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User)
}

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    var viewModel: ProfileHeaderViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    let topDivider = UIView()
    let bottomDivider = UIView()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleEdtiProfileFollowTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var stackView = UIStackView()
    private var buttonStackView = UIStackView()
    
    let gridButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(imageLiteralResourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(imageLiteralResourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(imageLiteralResourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ComponentsUI
    
    func setupUI() {
        setupProfileImage()
        setupStackView()
        setupNameLabel()
        setupButton()
        setupStackViewButton()
    }
    
    func setupProfileImage() {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 80 / 2
    }
    
    func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
    }
    
    func setupButton() {
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(
            top: nameLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 16,
            paddingLeft: 24,
            paddingRight: 24)
    }
    
    func setupStackView() {
        setupStackViewLabels()
        configureStackView()
    }
    
    func setupStackViewButton() {
        setupDividerColor()
        setupStackButtons()
        configureStackViewButton()
    }
    
    func setupStackViewLabels() {
        stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        stackView.distribution = .fillEqually
    }
    
    func configureStackView() {
        addSubview(stackView)
        stackView.centerY(inView: profileImageView)
        stackView.anchor(left: profileImageView.rightAnchor, right: rightAnchor ,paddingLeft: 12, paddingRight: 12, height: 50)
    }
    
    func setupDividerColor() {
        topDivider.backgroundColor = .lightGray
        bottomDivider.backgroundColor = .lightGray
    }
    
    func setupStackButtons() {
        buttonStackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        buttonStackView.distribution = .fillEqually
    }
    
    func configureStackViewButton() {
        addSubview(topDivider)
        addSubview(bottomDivider)
        addSubview(buttonStackView)
        
        buttonStackView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        topDivider.anchor(top: buttonStackView.topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        bottomDivider.anchor(top: buttonStackView.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
    }
    
    //MARK: - Actions
    @objc func handleEdtiProfileFollowTapped() {
        guard let viewModel = viewModel else { return }
        delegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
    
    //MARK: - Helpers
    func configure() {
        guard let viewModel = viewModel else { return }

        nameLabel.text = viewModel.fullname
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        editProfileFollowButton.setTitle(viewModel.followButtonText, for: .normal)
        editProfileFollowButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        editProfileFollowButton.backgroundColor = viewModel.followButtonTextColor
        
        postLabel.attributedText = viewModel.numberOfPosts
        followersLabel.attributedText = viewModel.numberOfFollowers
        followingLabel.attributedText = viewModel.numberOfFollowing
    }
}

