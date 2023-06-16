//
//  ExploreViewController.swift
//  Instegrem
//
//  Created by Bao Long on 14/06/2023.
//

import UIKit

class ExploreViewController: UIViewController {
    
    //MARK: - Attribute
    var loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
    var searchView: UIView!
    var searchBar: UISearchBar!
    var cancelButton: UIButton!
    var isSearching: Bool = false
    var cancelButtonLeftAnchor: NSLayoutConstraint!
    var collectionView: UICollectionView!
    var users: [User] = []
    var posts: [Post] = []
    var dataCollection: ([User], [Post]) = ([], [])
    var collectionViewBottomAnchor: NSLayoutConstraint!
    var viewModel: ExploreViewModel = ExploreViewModel()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configUI()
        getAllPost()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        setUpLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    deinit {
        print("DEBUG: DEINIT ExploreViewController")
    }
    
    func configUI() {
        
        searchView = UIView()
        searchView.backgroundColor = .systemBackground
        view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Tìm kiếm"
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.setContentHuggingPriority(UILayoutPriority(50), for: .horizontal)
        searchBar.setContentCompressionResistancePriority(UILayoutPriority(50), for: .horizontal)
        searchView.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Hủy", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        cancelButton.configuration = config
        
        searchView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButtonLeftAnchor = cancelButton.leftAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.bounces = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProfileBottomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileBottomCollectionViewCell")
        collectionView.register(UINib(nibName: "UserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserCollectionViewCell")
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionViewBottomAnchor = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            cancelButtonLeftAnchor,
            
            searchBar.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchBar.leftAnchor.constraint(equalTo: searchView.leftAnchor, constant: 4),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.rightAnchor.constraint(equalTo: cancelButton.leftAnchor, constant: -4),
            
            collectionView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionViewBottomAnchor
        ])
        
    }
    
    func setUpLoadingView() {
        view.addSubview(loadingView)
        loadingView.style = .medium
        loadingView.hidesWhenStopped = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 24),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func createUserSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(12 + 56))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(12 + 56))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
        
    }
    
    func createPostSection() -> NSCollectionLayoutSection {
        let itemWidth = (view.frame.width - 4.5) / 3
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(itemWidth))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(1.5)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
        
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnviroment -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                return self?.createUserSection()
            } else {
                return self?.createPostSection()
            }
        }
    }
    
    func searchUserbyName(key: String) {
        cancelButton.setTitle("", for: .normal)
        
        cancelButton.configuration?.showsActivityIndicator = true
        if users.isEmpty { loadingView.startAnimating() }
        viewModel.fetchUserByName(key: key)
        viewModel.fetchUserCompletion = { [weak self] in
            self?.users = self?.viewModel.dataUsers ?? []
            self?.dataCollection = (self?.users ?? [], [])
            self?.collectionView.reloadData()
            self?.loadingView.stopAnimating()
            self?.cancelButton.setTitle("Hủy", for: .normal)
            self?.cancelButton.configuration?.showsActivityIndicator = false
        }
    }
    
    func getAllPost() {
        loadingView.startAnimating()
        viewModel.fetchAllPost()
        viewModel.fetchPostCompletion = { [weak self] in
            self?.posts = self?.viewModel.dataPosts ?? []
            self?.dataCollection = ([], self?.posts ?? [])
            self?.collectionView.reloadData()
            self?.loadingView.stopAnimating()
        }
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        isSearching = false
        searchBar.searchTextField.text = ""
        dataCollection = ([], posts)
        collectionView.reloadData()
        UIView.animate(withDuration: 0.3, animations: {
            self.cancelButtonLeftAnchor.constant = 0
            self.view.layoutIfNeeded()
        })
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0
        UIView.animate(withDuration: duration, animations: {
            self.collectionViewBottomAnchor.constant = -keyboardSize.height
            self.view.layoutIfNeeded()
        })
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0
        UIView.animate(withDuration: duration, animations: {
            self.collectionViewBottomAnchor.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
}
