//
//  UITabBarViewController.swift
//  Instegrem
//
//  Created by Bao Long on 19/05/2023.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
        self.selectedIndex = 4
    }
    
    func setupVCs() {
        viewControllers = [
            createNavController(for: HomeViewController(), title: NSLocalizedString("Home", comment: ""), image: UIImage(named: "ic-home")!),
            createNavController(for: HomeViewController(), title: NSLocalizedString("Search", comment: ""), image: UIImage(named: "ic-search")!),
            createNavController(for: HomeViewController(), title: NSLocalizedString("Post", comment: ""), image: UIImage(named: "ic-create")!),
            createNavController(for: HomeViewController(), title: NSLocalizedString("Reel", comment: ""), image: UIImage(named: "ic-reel")!),
            createNavController(for: ProfileViewController(), title: NSLocalizedString("Profile", comment: ""), image: UIImage(named: "ic-profile")!)
        ]
    }
    
    func createNavController(for rootViewController: UIViewController,
                             title: String,
                             image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
//        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
//        navController.tabBarItem.selectedImage
        navController.navigationBar.prefersLargeTitles = true
//        rootViewController.navigationItem.title = title
        return navController
    }
}
