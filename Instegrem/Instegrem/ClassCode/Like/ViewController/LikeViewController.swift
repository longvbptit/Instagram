//
//  LikeViewController.swift
//  Instegrem
//
//  Created by Bao Long on 08/06/2023.
//

import UIKit

protocol FollowUserDelegate: NSObject {
    func followUser(uid: String, indexPath: IndexPath)
}

class LikeViewController: UIViewController {

    var tableView: UITableView!
    var navigationBar: CustomNavigationBar!
    var idPost: String!
    var users: [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configUI()
        getUserLiked()
        // Do any additional setup after loading the view.
    }
    
    func configUI() {
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "ic-back_small"), for: .normal)
        leftButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        
        let centerButton = UIButton()
        centerButton.setTitle("Lượt thích", for: .normal)
        centerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        centerButton.setTitleColor(.black, for: .normal)
        centerButton.isUserInteractionEnabled = false
        
        navigationBar = CustomNavigationBar(leftButtons: [leftButton], centerButton: centerButton)
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LikeTableViewCell", bundle: nil), forCellReuseIdentifier: "LikeTableViewCell")
        
        addSeparatorNav()
    }
    
    func addSeparatorNav() {
        let sepa = UIView()
        view.addSubview(sepa)
        sepa.backgroundColor = .systemGray5
        sepa.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sepa.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -1),
            sepa.leftAnchor.constraint(equalTo: view.leftAnchor),
            sepa.rightAnchor.constraint(equalTo: view.rightAnchor),
            sepa.heightAnchor.constraint(equalToConstant: 0.7)
        ])
    }
    
    func getUserLiked() {
        HomeService.getUsersLikedPost(idPost: idPost, completion: { [weak self] users, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self?.users = users
            self?.tableView.reloadData()
        })
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}

extension LikeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 24 + 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeTableViewCell", for: indexPath) as! LikeTableViewCell
        cell.user = users[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.updateFollowButton()
        cell.updateData()
        cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.width/2, bottom: 0, right: tableView.frame.width/2)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProfileViewController()
        vc.isOrigin = false
        vc.user = users[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LikeViewController: FollowUserDelegate {
    func followUser(uid: String, indexPath: IndexPath) {
        if users[indexPath.row].isFollowByCurrentUser == .notFollowYet {
            UserService.followUser(uid: uid, completion: { [weak self] error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self?.users[indexPath.row].isFollowByCurrentUser = .followed
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            })
        } else {
            UserService.unfollowUser(uid: uid, completion: { [weak self] error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self?.users[indexPath.row].isFollowByCurrentUser = .notFollowYet
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            })
        }
    }
}
