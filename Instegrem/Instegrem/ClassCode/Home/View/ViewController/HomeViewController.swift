//
//  HomeViewController.swift
//  Instegrem
//
//  Created by Bao Long on 19/05/2023.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    var navigationBar: CustomNavigationBar!
    var collectionView: UICollectionView!
    var user: User!
    var dataHome: [Post] = []
    lazy var refreshControl: UIRefreshControl = {
        let rfc = UIRefreshControl()
        
        return rfc
    }()
    var viewModel: HomeViewModel = HomeViewModel()
    var loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var story: [Story] = [Story(image: "ic-story0", title: "Tin của bạn"),
                          Story(image: "ic-story1", title: "Tin 1"),
                          Story(image: "ic-story2", title: "Tin 2"),
                          Story(image: "ic-story3", title: "Tin 3"),
                          Story(image: "ic-story4", title: "Tin 4"),
                          Story(image: "ic-story5", title: "Tin 5"),
                          Story(image: "ic-story6", title: "Tin 6"),
                          Story(image: "ic-story7", title: "Tin 7"),
                          Story(image: "ic-story8", title: "Tin 8"),
                          Story(image: "ic-story9", title: "Tin 9")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        getCurrentUser()
        bindingData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("PostNewStatus"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func bindingData() {
        fetchPosts()
    }
    
    func getCurrentUser() {
        let tabbar = tabBarController as! TabBarController
        user = tabbar.user
    }
    
    @objc func reloadData() {
        getCurrentUser()
        fetchPosts()
    }
    
    func configUI() {
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        collectionView.refreshControl = refreshControl
        view.addSubview(collectionView)
        collectionView.register(UINib(nibName: "StorySavedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StorySavedCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loadingView)
        loadingView.style = .large
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        let firstLeftButton = UIButton(type: .system)
        firstLeftButton.setImage(UIImage(named: "ic-logo_text")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        let secondLeftButton = UIButton()
        secondLeftButton.setImage(UIImage(named: "ic-arrow_down"), for: .normal)
        secondLeftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        
        let firstRightButton = UIButton(type: .system)
        firstRightButton.setImage(UIImage(named: "ic-messenger")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        firstRightButton.addTarget(self, action: #selector(buttonMoreTapped(_:)), for: .touchUpInside)
        
        let secondRightButton = UIButton(type: .system)
        secondRightButton.setImage(UIImage(named: "ic-heart")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        secondRightButton.addTarget(self, action: #selector(buttonCreateTapped(_:)), for: .touchUpInside)
        
        navigationBar = CustomNavigationBar(leftButtons: [firstLeftButton, secondLeftButton], spacingLeftButton: 4, rightButtons: [firstRightButton, secondRightButton], spacingRightButton: 24)
        navigationBar.backgroundColor = UIColor.white
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        ])
    }
    
    func createPostSection() -> NSCollectionLayoutSection{
        let itemWidth = view.frame.width
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        return section
        
    }
    
    func createStorySection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(84), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(84), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
        
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnviroment -> NSCollectionLayoutSection? in
            switch Section(rawValue: sectionIndex) {
            case .story:
                return self?.createStorySection()
            case .post:
                return self?.createPostSection()
            default:
                return nil
            }
        }
    }
    
    @objc func fetchPosts() {
        if self.dataHome.count == 0 {
            loadingView.startAnimating()
        }
        self.refreshControl.endRefreshing()
        viewModel.fetchHomePost(user: user)
        viewModel.completion = { [weak self] in
            self?.loadingView.stopAnimating()
            self?.dataHome = self?.viewModel.dataHome ?? []
            self?.collectionView.reloadData()
        }
    }
    
    deinit {
        print("DEBUG: DEINIT HomeViewController")
    }
}
