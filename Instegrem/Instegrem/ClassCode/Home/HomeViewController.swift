//
//  HomeViewController.swift
//  Instegrem
//
//  Created by Bao Long on 19/05/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    var navigationBar: CustomNavigationBar!
    var collectionView: UICollectionView!
    var dataHome: [Post] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func configUI() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.register(UINib(nibName: "StorySavedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StorySavedCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
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
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        ])
    }
    
    func createPostSection() -> NSCollectionLayoutSection{
        let itemWidth = view.frame.width
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.interItemSpacing = .fixed(1.5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
//        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return section
        
    }
    
    func createStorySection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(84), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(84), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.interItemSpacing = .fixed(1.5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
//        section.interGroupSpacing = 10
//        let layout = UICollectionViewCompositionalLayout(section: section)
        
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
    
    func fetchPosts() {
        HomeService.fetchPost(completion: { [weak self] data, error in
            if error != nil {
                self?.dataHome = []
            }
            self?.dataHome = data
        })
    }
    
    deinit {
        print("DEBUG: DEINIT HomeViewController")
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .story:
            return 10
        case .post:
            return dataHome.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .story:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StorySavedCollectionViewCell", for: indexPath) as! StorySavedCollectionViewCell
            cell.storyImage.cornerRadius = 32
            if indexPath.row > 0 {
                cell.storyLabel.text = "Ting thứ \(indexPath.row)"
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
            cell.post = dataHome[indexPath.row]
            return cell
        }
       
    }
    
    
}

enum Section: Int {
    case story
    case post
}
