//
//  MainTabController.swift
//  InstagramFirestoreTutorial
//
//  Created by vicoliveira on 16/10/22.
//

import UIKit
import Firebase
import YPImagePicker

class MainTabController: UITabBarController {
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(withUser: user)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkIfUserIsLoggedIn()
        setupBackGroundColor()
        fetchUser()
    }
    
    //MARK: - API
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let viewController = LoginViewController()
                viewController.delegate = self
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    // MARK: - Helpers
    func setupBackGroundColor() {
        view.backgroundColor = .white
    }
    
    func configureViewControllers(withUser user: User) {
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(
            unselectedImage: UIImage(imageLiteralResourceName: "home_unselected"),
            selectedImage: UIImage(imageLiteralResourceName: "home_selected"),
            rootViewController: FeedViewController(collectionViewLayout: layout))
        
        let search = templateNavigationController(
            unselectedImage: UIImage(imageLiteralResourceName: "search_unselected"),
            selectedImage: UIImage(imageLiteralResourceName: "search_selected"),
            rootViewController: SearchViewController())
        
        let imageSelector = templateNavigationController(
            unselectedImage: UIImage(imageLiteralResourceName: "plus_unselected"),
            selectedImage: UIImage(imageLiteralResourceName: "plus_unselected"),
            rootViewController: ImageSelectorViewController())
        
        let notification = templateNavigationController(
            unselectedImage: UIImage(imageLiteralResourceName: "like_unselected"),
            selectedImage: UIImage(imageLiteralResourceName: "like_selected"),
            rootViewController: NotificationViewController())
        
        let profileController = ProfileViewController(user: user)
        let profile = templateNavigationController(
            unselectedImage: UIImage(imageLiteralResourceName: "profile_unselected"),
            selectedImage: UIImage(imageLiteralResourceName: "profile_selected"),
            rootViewController: profileController)
        
        viewControllers = [ feed, search, imageSelector, notification, profile ]
        
        tabBar.tintColor = .black
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.image = selectedImage
        navigationController.navigationBar.tintColor = .black
        
        return navigationController
    }
    
    func setTabBarDelegate() {
        self.delegate = self
    }
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                let controller = UploadPostViewController()
                controller.selectedImage = selectedImage
                controller.delegate = self
                controller.currentUser = self.user
                
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                
                self.present(navigationController, animated: false, completion: nil)
            }
        }
    }
}

// MARK: - AuthenticationDelegate

extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            
            didFinishPickingMedia(picker)
        }
        
        return true
    }
}

// MARK: - UploadPostViewControllerDelegate

extension MainTabController: UploadPostViewControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostViewController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
        
        guard let feedNav = viewControllers?.first as? UINavigationController else { return }
        guard let feed = feedNav.viewControllers.first as? FeedViewController else { return }
        feed.handleRefresh()
    }
}
