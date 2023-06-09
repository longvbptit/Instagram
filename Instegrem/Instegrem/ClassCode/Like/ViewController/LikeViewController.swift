//
//  LikeViewController.swift
//  Instegrem
//
//  Created by Bao Long on 08/06/2023.
//

import UIKit

protocol FollowUserDelegate: NSObject {
    func followUser(uid: String, indexPath: IndexPath)
    func removeFollower(uid: String, indexPath: IndexPath)
}

extension FollowUserDelegate {
    func removeFollower(uid: String, indexPath: IndexPath) { }
}

class LikeViewController: UIViewController {
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
    var tableView: UITableView!
    var navigationBar: CustomNavigationBar!
    var idPost: String!
    var users: [User] = []
    var filteredUsers: [User] = []
    var searchBar: UISearchBar!
    var isSearching: Bool = false
    var viewModel: LikeViewModel = LikeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchBar()
        configUI()
        getUserLiked()
        setUpLoadingView()
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
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.tableHeaderView = searchBar
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
    
    func setUpLoadingView() {
        view.addSubview(loadingView)
        loadingView.style = .medium
        loadingView.hidesWhenStopped = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
        getUserLiked()
    }
    
    func getUserLiked() {

        if users.count == 0 {
            view.bringSubviewToFront(loadingView)
            loadingView.startAnimating()
        }
        HomeService.getUsersLikedPost(idPost: idPost, completion: { [weak self] users, error in
            self?.refreshControl.endRefreshing()
            self?.loadingView.stopAnimating()
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
        return isSearching ? filteredUsers.count : users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 12 + 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeTableViewCell", for: indexPath) as! LikeTableViewCell
        cell.user = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.updateFollowButton()
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

extension LikeViewController: FollowUserDelegate {
    func followUser(uid: String, indexPath: IndexPath) {
        if users[indexPath.row].isFollowByCurrentUser == .notFollowYet {
            viewModel.followUser(uid: uid, completion: { [weak self] result in
                if !result { return }
                self?.users[indexPath.row].isFollowByCurrentUser = .followed
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            })
        } else {
            viewModel.unFollowUser(uid: uid, completion: { [weak self] result in
                if !result { return }
                self?.users[indexPath.row].isFollowByCurrentUser = .notFollowYet
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            })
        }
    }
}

extension LikeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            getUserLiked()
            return
        }
        isSearching = true
        filteredUsers = users.filter { likedUser in
            likedUser.userName.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}
