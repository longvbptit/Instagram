//
//  ProfileBottomViewController.swift
//  Instegrem
//
//  Created by Bao Long on 22/05/2023.
//

import UIKit

class ProfileBottomViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var pageIndex: Int = 0
    var pageTitle: String?
    var pageImage: String?
    var color: UIColor?
    var count = 0
    var sizeCell: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        collectionView.collectionViewLayout = createLayout()
        layoutCollection()
        collectionView.register(UINib(nibName: "ProfileBottomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileBottomCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func layoutCollection() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func createLayout() -> UICollectionViewLayout{
        print("Child\(view.frame)")
        let itemWidth = (view.frame.width - 3) / 3
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(itemWidth))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: <#T##CGFloat#>, bottom: <#T##CGFloat#>, trailing: <#T##CGFloat#>)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1
        let layout = UICollectionViewCompositionalLayout(section: section)
        view.layoutIfNeeded()
        return layout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileBottomCollectionViewCell", for: indexPath) as! ProfileBottomCollectionViewCell
//        cell.image.image = UIImage(named: "avt")
        cell.image.backgroundColor = color
        return cell
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.frame.width - 2) / 3
//
//        return CGSize(width: width, height: width)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(collectionView.frame)
//        print(view.frame)
    }
    
    
    

}


