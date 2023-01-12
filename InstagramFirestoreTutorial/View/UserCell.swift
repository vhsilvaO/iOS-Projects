//
//  UserCell.swift
//  InstagramFirestoreTutorial
//
//  Created by vicoliveira on 11/11/22.
//

import UIKit

class UserCell: UITableViewCell {
    // MARK: - Properties
    
    var viewModel: UserCellViewModel? {
        didSet { configure() }
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(imageLiteralResourceName: "vortigern1")
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "vortigern"
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Oberon Vortigern"
        label.textColor = .lightGray
        return label
    }()
    
    private var stackView = UIStackView()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Components
    
    func configureComponents() {
        setupImageComponent()
        configureStackView()
    }
    
    func configureStackView() {
        setupStackLabel()
        setupStackView()
    }
    
    func setupImageComponent() {
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 48 / 2
        
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
    }
    
    func setupStackLabel() {
        stackView = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        
        addSubview(stackView)
        stackView.centerY(inView: profileImageView,
                        leftAnchor: profileImageView.rightAnchor,
                        paddingLeft: 8)
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        usernameLabel.text = viewModel.username
        fullnameLabel.text = viewModel.fullname
    }
}
