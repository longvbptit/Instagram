//
//  DetailPostViewController.swift
//  Instegrem
//
//  Created by Bao Long on 06/06/2023.
//

import UIKit

class DetailPostViewController: UIViewController {
    var viewModel: HomeViewModel = HomeViewModel()
    var navigationBar: CustomNavigationBar!
    var collectionView: UICollectionView!
    var posts: [Post] = []
    var type: String!
    var indexPath: IndexPath!
    var user: User!
    var naviationBarTitle: String = ""
    override func viewDidLoad() {
        print("DEBUG: other viewDidLoad")
        getCurrentUser()
        super.viewDidLoad()
        view.backgroundColor = .white
        configUI()
    }
    
    deinit {
        print("DEBUG: DEINIT DetailPostViewController")
    }
    
    func getCurrentUser() {
        let tabbar = tabBarController as! TabBarController
        user = tabbar.user
    }
    
    func configUI() {
        let firstLeftButton = UIButton(type: .system)
        firstLeftButton.setImage(UIImage(named: "ic-back_small")?.withRenderingMode(.alwaysOriginal), for: .normal)
        firstLeftButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        
        let centerButton = UIButton()

        if naviationBarTitle == "" {
            let nameAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
            let titleAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]
            let myString = NSMutableAttributedString(string: self.posts[0].user.userName.uppercased(), attributes: nameAttribute )
            let attrString = NSAttributedString(string: "\n" + self.type, attributes: titleAttribute)
            myString.append(attrString)
            centerButton.setAttributedTitle(myString, for: .normal)
            centerButton.titleLabel?.numberOfLines = 2
        } else {
            centerButton.setTitle(naviationBarTitle, for: .normal)
            centerButton.setTitleColor(.black, for: .normal)
            centerButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        }
        centerButton.titleLabel?.textAlignment = .center
        centerButton.isUserInteractionEnabled = false
        
        navigationBar = CustomNavigationBar(leftButtons: [firstLeftButton], centerButton: centerButton)
        navigationBar.backgroundColor = UIColor.white
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let sepaView = UIView()
        sepaView.backgroundColor = .systemGray5
        view.addSubview(sepaView)
        sepaView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 4),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            sepaView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 4),
            sepaView.leftAnchor.constraint(equalTo: view.leftAnchor),
            sepaView.rightAnchor.constraint(equalTo: view.rightAnchor),
            sepaView.heightAnchor.constraint(equalToConstant: 0.7)
        
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("DEBUG: other viewWillAppear")
    }
    override func viewWillLayoutSubviews() {
        print("DEBUG: other viewWillLayoutSubviews")

    }
    override func viewDidLayoutSubviews() {
        print("DEBUG: other viewDidLayoutSubviews")
        if indexPath != nil {
            collectionView.scrollToItem(at: IndexPath(item: indexPath.item, section: 0), at: .top, animated: false)
            collectionView.layoutSubviews()
            indexPath = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("DEBUG: other viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("DEBUG: other viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("DEBUG: other viewDidDisappear")
    }
    
    func getPosts() {
        viewModel.getUserPost(user: user)
        viewModel.getUserPostCompletion = { [weak self] in
            self?.posts = self?.viewModel.userPosts ?? []
            self?.collectionView.reloadData()
        }
    }
    
    func createLayout() -> UICollectionViewLayout{
        let itemWidth = view.frame.width
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
        
    }

    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}

extension DetailPostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
        cell.indexPath = indexPath
        cell.post = posts[indexPath.row]
        cell.delegate = self
        return cell
    }
    
}

extension DetailPostViewController: PostDelegate {
    func gotoComment(indexPath: IndexPath) {
        let vc = CommentViewController()
        vc.post = posts[indexPath.row]
        vc.indexPath = indexPath
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoLike(indexPath: IndexPath) {
        let vc = LikeViewController()
        vc.idPost = posts[indexPath.row].idPost
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoProfile(user: User) {
        let vc = ProfileViewController()
        vc.isOrigin = false
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func likePost(indexPath: IndexPath, isLike: Bool, numberOfLike: Int) {
        let uid = user.uid
        if isLike {
            viewModel.likePost(idPost: posts[indexPath.row].idPost, uid: uid)
        } else {
            viewModel.unLikePost(idPost: posts[indexPath.row].idPost, uid: uid)
        }
        posts[indexPath.row].isLiked = isLike
        posts[indexPath.row].numberOfLike = numberOfLike
        UIView.performWithoutAnimation {
            collectionView.performBatchUpdates({
                collectionView.reloadItems(at: [indexPath])
            }, completion: nil)
        }
    }
}

extension DetailPostViewController: CommentPostDelegate {
    func updateNumberOfCommentButton(indexPath: IndexPath, numberOfComment: Int) {
        posts[indexPath.row].numberOfComment = numberOfComment
        UIView.performWithoutAnimation {
            collectionView.performBatchUpdates({
                collectionView.reloadItems(at: [indexPath])
            }, completion: nil)
        }
    }
}
