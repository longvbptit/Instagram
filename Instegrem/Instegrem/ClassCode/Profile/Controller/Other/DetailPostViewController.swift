//
//  DetailPostViewController.swift
//  Instegrem
//
//  Created by Bao Long on 06/06/2023.
//

import UIKit

class DetailPostViewController: UIViewController {
    var navigationBar: CustomNavigationBar!
    var collectionView: UICollectionView!
    var posts: [Post] = []
    var type: String!
    var indexPath: IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configUI()
    }
    
    deinit {
        print("DEBUG: DEINIT DetailPostViewController")
    }
    
    func configUI() {
        let firstLeftButton = UIButton(type: .system)
        firstLeftButton.setImage(UIImage(named: "ic-back_small")?.withRenderingMode(.alwaysOriginal), for: .normal)
        firstLeftButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        
        let centerButton = UIButton()
        
        let nameAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let titleAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]
        let myString = NSMutableAttributedString(string: self.posts[0].user.userName.uppercased(), attributes: nameAttribute )
        let attrString = NSAttributedString(string: "\n" + self.type, attributes: titleAttribute)
        myString.append(attrString)
        centerButton.setAttributedTitle(myString, for: .normal)
        centerButton.titleLabel?.numberOfLines = 2
        centerButton.titleLabel?.textAlignment = .center
//        centerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
//        centerButton.setTitleColor(UIColor.black, for: .normal)
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
    
    override func viewDidLayoutSubviews() {
        if indexPath != nil {
            collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
            collectionView.layoutSubviews()
            indexPath = nil
        }
    }
    
    func createLayout() -> UICollectionViewLayout{
        let itemWidth = view.frame.width
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.interItemSpacing = .fixed(1.5)
        
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
        cell.post = posts[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
}

extension DetailPostViewController: PostDelegate {
    func gotoProfile(user: User) {
        let vc = ProfileViewController()
        vc.isOrigin = false
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }
}
