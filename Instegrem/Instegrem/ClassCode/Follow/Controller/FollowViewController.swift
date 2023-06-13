//
//  FollowViewController.swift
//  Instegrem
//
//  Created by Bao Long on 12/06/2023.
//

import UIKit
import FirebaseAuth

enum FollowType {
    case followers
    case following
    case none
}

class FollowViewController: UIViewController {

    var user: User!
    var follower: [User] = []
    var following: [User] = []
    var childBottomVC: [FollowBottomViewController]!
    var navigationBar: CustomNavigationBar!
    var barCollectionView: UICollectionView!
    var horizontalbarView: UIView!
    var horizontalScrollView: UIScrollView!
    var horizontalbarViewWidthConstraint: NSLayoutConstraint!
    var selectedIndex: Int!
    var isHorizontalBottomScroll: Bool = false
    var currentIndex: Int = 0
    var previosSelectedIndexPath: IndexPath?
    var bottomContentView: UIView!
    var isViewApear: Bool = false
    var numberOfFollowers: Int = 0
    var numberOfFollowing: Int = 0
    let currentUID = Auth.auth().currentUser?.uid ?? ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        numberOfFollowers = follower.count
        numberOfFollowing = following.count
        setUpNavBar()
        setUpBarColletionView()
        setUpHorizontalScrollView()
        addChildVC()
        addChildView()
    }
    
    deinit {
        print("DEBUG: DEINIT FollowViewController")
    }
    
    func setUpNavBar() {
        let firstLeftButton = UIButton(type: .system)
        firstLeftButton.setImage(UIImage(named: "ic-back_small")?.withRenderingMode(.alwaysOriginal), for: .normal)
        firstLeftButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        
        let centerButton = UIButton()
        centerButton.setTitle(user.userName, for: .normal)
        centerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        centerButton.setTitleColor(UIColor.black, for: .normal)
        centerButton.isUserInteractionEnabled = false
        
        navigationBar = CustomNavigationBar(leftButtons: [firstLeftButton], centerButton: centerButton)
        navigationBar.backgroundColor = UIColor.white
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func setUpBarColletionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        barCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        barCollectionView.isScrollEnabled = false
        view.addSubview(barCollectionView)
        barCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalbarView = UIView()
        horizontalbarView.backgroundColor = .black
        horizontalbarViewWidthConstraint = horizontalbarView.widthAnchor.constraint(equalToConstant: 100)
        view.addSubview(horizontalbarView)
        horizontalbarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            barCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            barCollectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            barCollectionView.heightAnchor.constraint(equalToConstant: 44),
            
            horizontalbarView.topAnchor.constraint(equalTo: barCollectionView.bottomAnchor),
//            horizontalbarView.leftAnchor.constraint(equalTo: view.leftAnchor),
            horizontalbarView.heightAnchor.constraint(equalToConstant: 1),
            horizontalbarViewWidthConstraint
        ])
        
        barCollectionView.delegate = self
        barCollectionView.dataSource = self
        barCollectionView.register(UINib(nibName: "ProfileBarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileBarCollectionViewCell")
        barCollectionView.isScrollEnabled = false
    }
    
    func setUpHorizontalScrollView() {
        horizontalScrollView = UIScrollView()
        horizontalScrollView.isPagingEnabled = true
        horizontalScrollView.showsHorizontalScrollIndicator = false
        horizontalScrollView.delegate = self
        view.addSubview(horizontalScrollView)
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalScrollView.topAnchor.constraint(equalTo: barCollectionView.bottomAnchor, constant: 4),
            horizontalScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            horizontalScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            horizontalScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupChildViewController() -> [FollowBottomViewController] {
        
        let vc = FollowBottomViewController()
        vc.user = user
        vc.users = follower
        vc.type = .followers
        if currentUID == user.uid {
            vc.delegate = self
        }
        
        let vc1 = FollowBottomViewController()
        vc1.user = user
        vc1.users = following
        vc1.type = .following
        if currentUID == user.uid {
            vc1.delegate = self
        }
        
        return [vc, vc1]
    }
    
    func addChildVC() {
        childBottomVC = setupChildViewController()
        for childVC in childBottomVC {
            addChild(childVC)
        }
    }
    
    func addChildView() {
        bottomContentView = UIView()
        bottomContentView.translatesAutoresizingMaskIntoConstraints = false
        horizontalScrollView.addSubview(bottomContentView)
        NSLayoutConstraint.activate([
            bottomContentView.topAnchor.constraint(equalTo: horizontalScrollView.topAnchor),
            bottomContentView.bottomAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor),
            bottomContentView.leftAnchor.constraint(equalTo: horizontalScrollView.leftAnchor),
            bottomContentView.rightAnchor.constraint(equalTo: horizontalScrollView.rightAnchor),
//            bottomContentView.widthAnchor.constraint(equalToConstant: view.frame.width * CGFloat(childBottomVC.count)),
        ])
        for (index, childVC) in childBottomVC.enumerated() {
            bottomContentView.addSubview(childVC.view)
            childVC.view.translatesAutoresizingMaskIntoConstraints = false
            childVC.didMove(toParent: self)
            NSLayoutConstraint.activate([
                childVC.view.topAnchor.constraint(equalTo: bottomContentView.topAnchor),
                childVC.view.bottomAnchor.constraint(equalTo: bottomContentView.bottomAnchor)
//                childVC.view.widthAnchor.constraint(equalToConstant: view.frame.width)
            ])
            if index == 0 {
                childVC.view.leftAnchor.constraint(equalTo: bottomContentView.leftAnchor).isActive = true
            } else {
                childVC.view.leftAnchor.constraint(equalTo: childBottomVC[index-1].view.rightAnchor).isActive = true
            }
        }
    }
    
    func updateBottom() {
//        isHorizontalBottomScroll = true
        if barCollectionView.numberOfItems(inSection: 0) > 0 {
            let indexPath = IndexPath(item: selectedIndex, section: 0)
            barCollectionView.delegate?.collectionView?(barCollectionView, didSelectItemAt: indexPath)
            previosSelectedIndexPath = indexPath
        }
//        view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {

        bottomContentView.widthAnchor.constraint(equalToConstant: view.frame.width * CGFloat(childBottomVC.count)).isActive = true
        bottomContentView.heightAnchor.constraint(equalToConstant: horizontalScrollView.frame.height).isActive = true

        for childVC in childBottomVC {
            childVC.view.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        }
        horizontalbarViewWidthConstraint.constant = view.frame.width / CGFloat(childBottomVC.count)
//        horizontalScrollView.layoutIfNeeded()
        updateBottom()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isViewApear = true
    }

}

extension FollowViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileBarCollectionViewCell", for: indexPath) as! ProfileBarCollectionViewCell
        cell.image.isHidden = true
        cell.label.isHidden = false
        cell.label.text = indexPath.row == 0 ? "\(numberOfFollowers) Người Theo Dõi" : "\(numberOfFollowing) Đang Theo Dõi"
        cell.label.alpha = 0.5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: didselected cell \(indexPath.row)")
        if isHorizontalBottomScroll {
            if let cell = collectionView.cellForItem(at: indexPath) as? ProfileBarCollectionViewCell {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.label.alpha = 1
                })
            }
            if let selectedIndexPath = previosSelectedIndexPath, selectedIndexPath != indexPath {
                // Manually call didDeselectItemAt for the previously selected cell
                collectionView.delegate?.collectionView?(collectionView, didDeselectItemAt: selectedIndexPath)
            }
            
            // Update the selected index path
            previosSelectedIndexPath = indexPath
            isHorizontalBottomScroll = false
        } else {
            currentIndex = indexPath.row
            if !isViewApear {
                self.horizontalScrollView.contentOffset.x = CGFloat(indexPath.row) * self.view.frame.width
                self.horizontalbarView.frame.origin.x = CGFloat(indexPath.row) * self.view.frame.width / 2
                view.layoutIfNeeded()
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.horizontalScrollView.contentOffset.x = CGFloat(indexPath.row) * self.view.frame.width
                })
            }
            
            if let cell = collectionView.cellForItem(at: indexPath) as? ProfileBarCollectionViewCell {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.label.alpha = 1
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileBarCollectionViewCell {
            UIView.animate(withDuration: 0.1, animations: {
                cell.label.alpha = 0.5
            })
        }
    }
}

extension FollowViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == horizontalScrollView {
            isHorizontalBottomScroll = true
            let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
            
            if barCollectionView.numberOfItems(inSection: 0) > 0 {
                let indexPath = IndexPath(item: pageIndex, section: 0)
                barCollectionView.delegate?.collectionView?(barCollectionView, didSelectItemAt: indexPath)
            }
            let offsetX = scrollView.contentOffset.x / scrollView.contentSize.width * view.frame.width
            
            if isViewApear {
                UIView.animate(withDuration: 0.1, animations: {
                    self.horizontalbarView.frame.origin.x = offsetX
                })
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == horizontalScrollView {
            let newIndex = scrollView.contentOffset.x / scrollView.contentSize.width * 2
            if Int(newIndex) != currentIndex {
                currentIndex = Int(newIndex)
            }
        }
    }
}

extension FollowViewController: UpDateFollowNumberDelegate {
    func updatefollower(num: Int) {
        numberOfFollowers = num
        barCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
    }
    
    func updatefollowing(num: Int, fromFollower: Bool) {
        if fromFollower {
            numberOfFollowing += num
        } else {
            numberOfFollowing = num
        }
        barCollectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
    }
}
