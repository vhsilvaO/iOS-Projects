//
//  NotificationViewController.swift
//  InstagramFirestoreTutorial
//
//  Created by vicoliveira on 16/10/22.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationViewController: UITableViewController {
    
    //MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet { tableView.reloadData() }
    }
    
    private let refresher = UIRefreshControl()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTableView()
    }
    
    //MARK: - API
    
    func fetchNotifications() {
        NotificationService.fetchNotifications { notifications in
            self.notifications = notifications
            self.checkIfUserIsFollowed()
        }
    }
    
    func checkIfUserIsFollowed() {
        notifications.forEach { notification in
            guard notification.type == . follow else { return }
            
            UserService.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                    self.notifications[index].userIsFollowed = isFollowed
                }
            }
        }
    }
    
    //MARK: - Components
    
    func configureTableView() {
        setupBackgroundColor()
        setupNavigationTitle()
        registerTableViewCell()
        setupTableViewRowHeight()
        setupTableViewSeparatorStyle()
        setupRefresher()
    }
    
    func setupBackgroundColor() {
        view.backgroundColor = .white
    }
    
    func setupNavigationTitle() {
        navigationItem.title = "Notifications"
    }
    
    func registerTableViewCell() {
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func setupTableViewRowHeight() {
        tableView.rowHeight = 80
    }
    
    func setupTableViewSeparatorStyle() {
        tableView.separatorStyle = .none
    }
    
    //MARK: - Helpers
    
    func setupRefresher() {
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    //MARK: - Actions
    
    @objc func handleRefresh() {
        notifications.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
    }
}

//MARK: - UITableViewDataSource

extension NotificationViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NotificationViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoader(true)
        
        UserService.fetchUser(withUid: notifications[indexPath.row].uid) { user in
            self.showLoader(false)
            
            let controller = ProfileViewController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK: - NotificationCellDelegate

extension NotificationViewController: NotificationCellDelegate {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        showLoader(true)
        
        UserService.follow(uid: uid) { _ in
            self.showLoader(false)
            
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToFUnfollow uid: String) {
        showLoader(true)
        
        UserService.unfollow(uid: uid) { _ in
            self.showLoader(false)
            
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String) {
        showLoader(true)
        
        PostService.fetchingPost(withPostId: postId) { post in
            self.showLoader(false)
            
            let controller = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.post = post
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
