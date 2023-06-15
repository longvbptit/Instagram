//
//  FollowBottomViewController.swift
//  Instegrem
//
//  Created by Bao Long on 13/06/2023.
//

import UIKit
import FirebaseAuth

protocol UpDateFollowNumberDelegate: AnyObject {
    func updatefollower(num: Int)
    func updatefollowing(num: Int, fromFollower: Bool)
}

class FollowBottomViewController: UIViewController {
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var type: FollowType!
    var user: User!
    weak var delegate: UpDateFollowNumberDelegate?
    var users: [User] = []
    var filteredUsers: [User] = []
    var isSearching: Bool = false
    let currentUID = Auth.auth().currentUser?.uid ?? ""
    var viewModel: FollowViewModel = FollowViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        configUI()
    }
    
    func configUI() {
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.tableHeaderView = searchBar
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.register(UINib(nibName: "LikeTableViewCell", bundle: nil), forCellReuseIdentifier: "LikeTableViewCell")
    }
    
    func getData() {
        if type == .followers {
            getFollowers()
        } else if type == .following {
            getFollowing()
        }
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = false
        searchBar.delegate = self
    }
    
    @objc func reloadData() {
        filteredUsers.removeAll()
        isSearching = false
        searchBar.text = ""
        getData()
    }
    
    func getFollowers() {
        UserService.getAllFolowers(uid: user.uid, completion: { [weak self] followers, error in
            self?.refreshControl.endRefreshing()
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self?.delegate?.updatefollower(num: followers.count)
            self?.users = followers
            self?.tableView.reloadData()
        })
    }
    
    func getFollowing() {
        UserService.getAllFolowing(uid: user.uid, completion: { [weak self] following, error in
            self?.refreshControl.endRefreshing()
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self?.delegate?.updatefollowing(num: following.count, fromFollower: false)
            self?.users = following
            self?.tableView.reloadData()
        })
    }
}

extension FollowBottomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredUsers.count : users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 12 + 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeTableViewCell", for: indexPath) as! LikeTableViewCell
        cell.type = type
        cell.inCurrentUser = user.uid == currentUID
        cell.user = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        if user.uid == currentUID && type == .followers {
            cell.updateFollowUserNameButton()
        } else {
            cell.updateFollowButton()
        }
        cell.updateData()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProfileViewController()
        vc.isOrigin = false
        vc.user = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension FollowBottomViewController: FollowUserDelegate {
    func removeFollower(uid: String, indexPath: IndexPath) {
        viewModel.removeFollower(uid: uid, completion: { [weak self] result in
            if !result { return }
            if indexPath.row >= 0 && indexPath.row < self?.users.count ?? 0 {
                self?.users.remove(at: indexPath.row)
                self?.delegate?.updatefollower(num: self?.users.count ?? 0)
                self?.tableView.beginUpdates()
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                self?.tableView.endUpdates()
            }
        })
    }
    
    func followUser(uid: String, indexPath: IndexPath) {
        if users[indexPath.row].isFollowByCurrentUser == .notFollowYet {
            viewModel.followUser(uid: uid, completion: { [weak self] result in
                if !result { return }
                self?.delegate?.updatefollowing(num: 1, fromFollower: true)
                self?.users[indexPath.row].isFollowByCurrentUser = .followed
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            })
        } else {
            viewModel.unFollowUser(uid: uid, completion: { [weak self] result in
                if !result { return }
                self?.delegate?.updatefollowing(num: -1, fromFollower: true)
                self?.users[indexPath.row].isFollowByCurrentUser = .notFollowYet
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            })
        }
    }
}

extension FollowBottomViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            getData()
            return
        }
        isSearching = true
        filteredUsers = users.filter { followUser in
            followUser.userName.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}
