//
//  ProfileViewController.swift
//  InstagramFirestoreTutorial
//
//  Created by vicoliveira on 16/10/22.
//

import UIKit

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileViewController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var user: User
    private var posts = [Post]()
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureCollectionView()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchPosts()
    }
    
    //MARK: - API
    
    func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    func fetchPosts() {
        PostService.fetchPost(forUser: user.uid) { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }

    //MARK: - Helpers
    
    func configureCollectionView() {
        setupCollectionViewTitle()
        setupBackgroundColor()
        setupCollectionViewRegister()
    }
    
    func setupBackgroundColor() {
        collectionView.backgroundColor = .white
    }
    
    func setupCollectionViewTitle() {
        navigationItem.title = user.userName
    }
    
    func setupCollectionViewRegister() {
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: headerIdentifier)
    }
}

//MARK: - UICollectionViewDataSource

extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.delegate = self
        header.viewModel = ProfileHeaderViewModel(user: user)
        
        return header
    }
}

//MARK: - UICollectionViewDelegate

extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.post = posts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widght = (view.frame.width / 2) / 2
        
        return CGSize(width: widght, height: widght)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

//MARK: - ProfileHeaderDelegate

extension ProfileViewController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        guard let tab = self.tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else { return }
        
        if user.isCurrentUser {
            print("DEBUG: Show Edit profile here...")
        } else if user.isFollowed {
            UserService.unfollow(uid: user.uid) { error in
                self.user.isFollowed = false
                self.collectionView.reloadData()
                
                PostService.updateUserFeedAfterFollowing(user: user, didFollow: false)
            }
        } else {
            UserService.follow(uid: user.uid) { error in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                
                NotificationService.uploadNotification(toUid: user.uid,
                                                 fromUser: currentUser,
                                                 type: .follow)
                
                PostService.updateUserFeedAfterFollowing(user: user, didFollow: true)
            }
        }
    }
}
