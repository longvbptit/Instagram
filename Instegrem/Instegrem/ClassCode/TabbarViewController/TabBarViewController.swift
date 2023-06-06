//
//  UITabBarViewController.swift
//  Instegrem
//
//  Created by Bao Long on 19/05/2023.
//

import Foundation
import UIKit
import SDWebImage
import FirebaseAuth
class TabBarController: UITabBarController {
    
    var user: User!
    override func viewDidLoad() {
//        SDImageCache.shared.config.shouldCacheImagesInMemory = false
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        getCurrentUser()
//        self.selectedIndex = 4
    }
    
    deinit {
        print("DEBUG: DEINIT TabBarController")
    }
    func getCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.getUser(uid: uid, completion: { [weak self] dataUser, err in
            if err != nil {
                return
            }
            self?.user = User(uid: dataUser["uid"] as! String, dictionary: dataUser)
            self?.setupVCs()
        })
    }
    func setupVCs() {
        viewControllers = [
            createNavController(for: HomeViewController(), title: NSLocalizedString("Home", comment: ""), image: UIImage(named: "ic-home")!),
            createNavController(for: HomeViewController(), title: NSLocalizedString("Search", comment: ""), image: UIImage(named: "ic-search")!),
            createNavController(for: PostViewController(), title: NSLocalizedString("Post", comment: ""), image: UIImage(named: "ic-create")!),
            createNavController(for: HomeViewController(), title: NSLocalizedString("Reel", comment: ""), image: UIImage(named: "ic-reel")!),
            createNavController(for: ProfileViewController(), title: NSLocalizedString("Profile", comment: ""), image: UIImage(named: "ic-profile")!)
        ]
        self.tabBar.backgroundColor = .white
    }
    
    func createNavController(for rootViewController: UIViewController,
                             title: String,
                             image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.interactivePopGestureRecognizer?.delegate = self
        navController.tabBarItem.image = image
        return navController
    }
}

extension TabBarController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
