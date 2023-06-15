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
    var loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
    var user: User!
    override func viewDidLoad() {
//        SDImageCache.shared.config.shouldCacheImagesInMemory = false
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setUpLoadingView()
        getCurrentUser()
    }
    
    deinit {
        print("DEBUG: DEINIT TabBarController")
    }
    
    func setUpLoadingView() {
        view.addSubview(loadingView)
        loadingView.style = .large
        loadingView.hidesWhenStopped = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    func getCurrentUser() {
        loadingView.startAnimating()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.getUser(uid: uid, completion: { [weak self] dataUser, err in
            self?.loadingView.stopAnimating()
            if err != nil {
                return
            }
            self?.user = User(uid: dataUser["uid"] as! String, dictionary: dataUser)
            self?.setupVCs()
        })
    }
    func setupVCs() {
        viewControllers = [
            createNavController(for: HomeViewController(),
                                title: NSLocalizedString("Home", comment: ""),
                                image: UIImage(named: "ic-home")!,
                                selectedImage: UIImage(named: "ic-home_selected")),
            createNavController(for: ExploreViewController(),
                                title: NSLocalizedString("Search", comment: ""),
                                image: UIImage(named: "ic-search")!,
                                selectedImage: UIImage(named: "ic-search_selected")),
            createNavController(for: PostViewController(),
                                title: NSLocalizedString("Post", comment: ""),
                                image: UIImage(named: "ic-create")!,
                                selectedImage: UIImage(named: "ic-create_selected")),
            createNavController(for: ReelsViewController(),
                                title: NSLocalizedString("Reel", comment: ""),
                                image: UIImage(named: "ic-reels")!,
                                selectedImage: UIImage(named: "ic-reels_selected")),
            createNavController(for: ProfileViewController(),
                                title: NSLocalizedString("Profile", comment: ""),
                                image: UIImage(named: "ic-profile")!,
                                selectedImage: UIImage(named: "ic-profile_selected"))
        ]
        self.tabBar.backgroundColor = .white
    }
    
    func createNavController(for rootViewController: UIViewController,
                             title: String,
                             image: UIImage, selectedImage: UIImage? = nil) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem = UITabBarItem(title: nil, image: image.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage)
        return navController
    }
}
