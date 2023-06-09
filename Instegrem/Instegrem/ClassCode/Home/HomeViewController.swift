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
    var dataHome: [Post] = [] {
        didSet {
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
        }
    }
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
        getCurrentUser()
        fetchPosts()
        configUI()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("PostNewStatus"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func getCurrentUser() {
        let tabbar = tabBarController as! TabBarController
        user = tabbar.user
    }
    
    @objc func reloadData() {
        fetchPosts()
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
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
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
            if indexPath.row == 0 {
                cell.addStoryImage.isHidden = false
                cell.storyImage.sd_setImage(with: URL(string: user.avatar))
            } else {
                cell.storyImage.image = UIImage(named: story[indexPath.row].image)
                cell.addStoryImage.isHidden = true
            }
            
            cell.storyImage.cornerRadius = 32
            cell.widthAddStory.constant = 64/3
            cell.storyLabel.text = story[indexPath.row].title
            cell.storyImage.contentMode = .scaleAspectFill
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
            cell.indexPath = indexPath
            cell.post = dataHome[indexPath.row]
            cell.delegate = self
            return cell
        }
       
    }
    
}

enum Section: Int {
    case story
    case post
}

extension HomeViewController: PostDelegate {
    func gotoComment(indexPath: IndexPath) {
        let vc = CommentViewController()
        vc.post = dataHome[indexPath.row]
        vc.indexPath = indexPath
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoLike(indexPath: IndexPath) {
        let vc = LikeViewController()
        vc.idPost = dataHome[indexPath.row].idPost
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoProfile(user: User) {
        let vc = ProfileViewController()
        vc.isOrigin = false
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func likePost(indexPath: IndexPath, isLike: Bool, numberOfLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if isLike {
            HomeService.likeStatus(idPost: dataHome[indexPath.row].idPost, uid: uid, completion: { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            })
        } else {
            HomeService.unLikeStatus(idPost: dataHome[indexPath.row].idPost, uid: uid, completion: { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            })
        }
        dataHome[indexPath.row].isLiked = isLike
        dataHome[indexPath.row].numberOfLike = numberOfLike
        UIView.performWithoutAnimation {
            collectionView.performBatchUpdates({
                collectionView.reloadItems(at: [indexPath])
            }, completion: nil)
        }
    }

}

struct Story {
    var image: String = ""
    var title: String = ""
}

extension HomeViewController: CommentPostDelegate {
    func updateNumberOfCommentButton(indexPath: IndexPath, numberOfComment: Int) {
        dataHome[indexPath.row].numberOfComment = numberOfComment
        UIView.performWithoutAnimation {
            collectionView.performBatchUpdates({
                collectionView.reloadItems(at: [indexPath])
            }, completion: nil)
        }
    }
}
