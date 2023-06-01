//
//  ProfileAddAccountViewController.swift
//  Instegrem
//
//  Created by Bao Long on 27/05/2023.
//

import UIKit
import FirebaseAuth

class ProfileAddAccountViewController: CustomPresentViewController {
    var avatar: UIImage!
    var avatarImage: UIImageView!
    var loggoutButton: UIButton!
    var createAccountButton: UIButton!
    var contentLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI() {
        avatarImage = UIImageView()
        avatarImage.image = avatar
        avatarImage.contentMode = .scaleToFill
        avatarImage.cornerRadius = 18
        avatarImage.clipsToBounds = true
        containerView.addSubview(avatarImage)
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        
        createAccountButton = UIButton(type: .system)
        createAccountButton.addTarget(self, action: #selector(addAccountButtonTapped), for: .touchUpInside)
        createAccountButton.setTitle("Thêm tài khoản", for: .normal)
        createAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        createAccountButton.setTitleColor(.white, for: .normal)
        createAccountButton.cornerRadius = 8
        createAccountButton.backgroundColor = UIColor(red: 31/255, green: 161/255, blue: 1, alpha: 1)
        containerView.addSubview(createAccountButton)
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentLabel = UILabel()
        contentLabel.text = "Thêm tài khoản hay đăng xuất đây người đẹp ?"
        contentLabel.textAlignment = .center
        contentLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        containerView.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let sepaView = UIView()
        sepaView.backgroundColor = .gray
        sepaView.alpha = 0.5
        containerView.addSubview(sepaView)
        sepaView.translatesAutoresizingMaskIntoConstraints = false
        
        loggoutButton = UIButton(type: .system)
        loggoutButton.setTitle("Đăng xuất", for: .normal)
        loggoutButton.setTitleColor(.red, for: .normal)
        containerView.addSubview(loggoutButton)
        loggoutButton.translatesAutoresizingMaskIntoConstraints = false
        loggoutButton.addTarget(self, action: #selector(logoutButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24 + 6 + 8),
            avatarImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            avatarImage.widthAnchor.constraint(equalToConstant: 36),
            avatarImage.heightAnchor.constraint(equalToConstant: 36),
            
            contentLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 24),
            contentLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            contentLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            
            createAccountButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 24),
            createAccountButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            createAccountButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 36),
            createAccountButton.heightAnchor.constraint(equalToConstant: 42),
            
            sepaView.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 24),
            sepaView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            sepaView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            sepaView.heightAnchor.constraint(equalToConstant: 1),
            
            loggoutButton.topAnchor.constraint(equalTo: sepaView.bottomAnchor),
            loggoutButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loggoutButton.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            loggoutButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
    }
    
    @objc func addAccountButtonTapped(_ sender: UIButton) {
        self.dismissByTap = true
        animateDismissView()
        
    }
    
    @objc func logoutButtonTapped(_ sender: UIButton) {
        AuthService.logOut()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(UINavigationController(rootViewController: LoginViewController()))
        
    }

}
