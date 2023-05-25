//
//  ProfileViewController.swift
//  Instegrem
//
//  Created by Bao Long on 19/05/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    //  MARK: - OUTLET
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var barCollectionView: UICollectionView!
    @IBOutlet weak var horizontalContainerView: UIScrollView!
    
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var bottomBarViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var storySavedCollectionView: UICollectionView!
    
    var overlayScrollView: UIScrollView!
    var currentIndex: Int = 0
    var indicator: IGActivityIndicator!
    var childBottomVC: [ProfileBottomViewController]!
    var contentOffsets: [Int: CGFloat] = [:]
    var childView: [Int: UIView] = [:] {
        didSet {
            if let scrollView = childView[currentIndex] as? UIScrollView {
                scrollView.panGestureRecognizer.require(toFail: overlayScrollView.panGestureRecognizer)
            }
        }
    }
    
    var isHorizontalBottomScroll: Bool = false
    var previosSelectedIndexPath: IndexPath?
    
    var window: UIWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUI()
        setUpBarColletion()
        layoutOverlayScrollView()
        horizontalContainerView.delegate = self
        setupStoryCollection()
//        tabBarController?.tabBar.isHidden = true
    }
    
    func settingUI() {
        
        indicator = IGActivityIndicator(frame: avatarImage.frame, addWidthAndHeight: 4)
//        topView.layer.addSublayer(indicator)
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 40
        indicator.addAnimation()
        setupNavBar()
        
        horizontalContainerView.isPagingEnabled = true
        horizontalContainerView.bounces = true
        horizontalContainerView.alwaysBounceVertical = false
        horizontalContainerView.alwaysBounceHorizontal = true
        
    }
    
    func setUpBarColletion() {
        barCollectionView.register(UINib(nibName: "ProfileBarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileBarCollectionViewCell")
        barCollectionView.delegate = self
        barCollectionView.dataSource = self
    }
    
    func setupStoryCollection() {
        storySavedCollectionView.delegate = self
        storySavedCollectionView.dataSource = self
        storySavedCollectionView.contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        storySavedCollectionView.register(UINib(nibName: "StorySavedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StorySavedCollectionViewCell")
        
    }
    
    func setupNavBar() {
        let firstLeftButton = UIButton(type: .system)
        firstLeftButton.setTitle("bao_longgg", for: .normal)
        firstLeftButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        firstLeftButton.setTitleColor(UIColor.black, for: .normal)
        firstLeftButton.addTarget(self, action: #selector(buttonUserTapped(_:)), for: .touchUpInside)
        
        let secondLeftButton = UIButton()
        secondLeftButton.setImage(UIImage(named: "ic-arrow_down"), for: .normal)
        
        let firstRightButton = UIButton(type: .system)
        firstRightButton.setImage(UIImage(named: "ic-more")?.withRenderingMode(.alwaysOriginal), for: .normal)
        firstRightButton.addTarget(self, action: #selector(buttonMoreTapped(_:)), for: .touchUpInside)
        
        let secondRightButton = UIButton(type: .system)
        secondRightButton.setImage(UIImage(named: "ic-create")?.withRenderingMode(.alwaysOriginal), for: .normal)
        secondRightButton.addTarget(self, action: #selector(buttonCreateTapped(_:)), for: .touchUpInside)
        
        let naviBar = CustomNavigationBar(leftButtons: [firstLeftButton, secondLeftButton], rightButtons: [firstRightButton, secondRightButton], spacingRightButton: 24)
        naviBar.backgroundColor = UIColor.white
        navBar.addSubview(naviBar)
        naviBar.frame = navBar.bounds
        
    }
    
    func layoutOverlayScrollView() {
        overlayScrollView = UIScrollView()
        view.addSubview(overlayScrollView)
        overlayScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayScrollView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            overlayScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            overlayScrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        view.bringSubviewToFront(containerScrollView)
        overlayScrollView.delegate = self
        containerScrollView.addGestureRecognizer(overlayScrollView.panGestureRecognizer)
        containerScrollView.alwaysBounceVertical = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        horizontalContainerView.contentSize = CGSize(width: view.frame.width * 3, height: horizontalContainerView.contentSize.height)
        addChildVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let scrollView = childBottomVC[currentIndex].collectionView {
            scrollView.panGestureRecognizer.require(toFail: overlayScrollView.panGestureRecognizer)
        }
        updateOverlayScrollContentSize(with: childBottomVC[currentIndex].collectionView)
    }
    
    func addChildVC() {
        childBottomVC = setupChildViewController()
        bottomBarViewWidthConstraint.constant = (view.frame.width - 3) / CGFloat(childBottomVC.count)
        for (index, childVC) in childBottomVC.enumerated() {
            childVC.view.frame = CGRect(x: CGFloat(index) * view.bounds.width, y: 0, width: view.bounds.width, height:  horizontalContainerView.bounds.height)
            print("ChildOrigin: \(childVC.view.frame)")
            addChild(childVC)
            childVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            horizontalContainerView.addSubview(childVC.view)
            childVC.didMove(toParent: self)
        }
    }
    
    func setupChildViewController() -> [ProfileBottomViewController] {
        
        let vc = ProfileBottomViewController()
        vc.pageIndex = 0
        vc.pageTitle = "Posts"
        vc.pageImage = "ic-posts"
        vc.count = 50
        vc.color = .black
        
        let vc1 = ProfileBottomViewController()
        vc1.pageIndex = 1
        vc1.pageTitle = "Reel"
        vc1.pageImage = "ic-reel"
        vc1.count = 20
        vc1.color = .red
        
        let vc2 = ProfileBottomViewController()
        vc2.pageIndex = 2
        vc2.pageTitle = "Tag"
        vc2.pageImage = "ic-tag"
        vc2.count = 30
        vc2.color = .green
        
        return [vc, vc1, vc2]
    }
    
    func updateOverlayScrollContentSize(with bottomView: UIView){
        self.overlayScrollView.contentSize = getContentSize(for: bottomView)
        self.containerScrollView.contentSize = self.overlayScrollView.contentSize
//        barCollectionView.reloadData()
    }
    
    func getContentSize(for bottomView: UIView) -> CGSize{
        if let scroll = bottomView as? UIScrollView {
            let bottomHeight = max(scroll.contentSize.height, containerScrollView.frame.height - topView.frame.height - barCollectionView.frame.height)
            return CGSize(width: view.frame.width, height: bottomHeight + topView.frame.height + barCollectionView.frame.height)
        } else {
            let bottomHeight = view.frame.height - topView.frame.height - barCollectionView.frame.height
            return CGSize(width: view.frame.width, height: bottomHeight + topView.frame.height + barCollectionView.frame.height)
        }
    }
    
    @objc func buttonCreateTapped(_ sender: UIButton) {
        print("create button tapped")
    }
    
    @objc func buttonMoreTapped(_ sender: UIButton) {
        print("more button tapped")
    }
    
    @objc func buttonUserTapped(_ sender: UIButton) {
        print("more user tapped")
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == storySavedCollectionView {
            return 10
        } else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == storySavedCollectionView {
            return CGSize(width: 76, height: collectionView.frame.height)
        } else {
            return CGSize(width: (collectionView.frame.width) / 3, height: collectionView.frame.height)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == storySavedCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StorySavedCollectionViewCell", for: indexPath) as! StorySavedCollectionViewCell
            if indexPath.row > 0 {
                cell.storyLabel.text = "Tin thứ \(indexPath.row)"
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileBarCollectionViewCell", for: indexPath) as! ProfileBarCollectionViewCell
            let image = childBottomVC[indexPath.row].pageImage
            cell.image.image = UIImage(named: image!)
            if indexPath.row > 0 {
                cell.image.alpha = 0.5
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == storySavedCollectionView {
            print("ahihi")
        } else {
            
            if isHorizontalBottomScroll {
                if let cell = collectionView.cellForItem(at: indexPath) as? ProfileBarCollectionViewCell {
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.image.alpha = 1
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
                if let offset = contentOffsets[indexPath.row]{
                    self.overlayScrollView.contentOffset.y = offset
                }else{
                    self.overlayScrollView.contentOffset.y = self.containerScrollView.contentOffset.y
                }
                UIView.animate(withDuration: 0.3, animations: {
                    self.horizontalContainerView.contentOffset.x = CGFloat(indexPath.row) * self.view.frame.width
                })
                updateOverlayScrollContentSize(with: childBottomVC[currentIndex].collectionView)
                childView[currentIndex] = childBottomVC[currentIndex].collectionView
                if let cell = collectionView.cellForItem(at: indexPath) as? ProfileBarCollectionViewCell {
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.image.alpha = 1
                    })
                }
                
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileBarCollectionViewCell {
            UIView.animate(withDuration: 0.1, animations: {
                cell.image.alpha = 0.5
            })
        }
    }
    
}

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == horizontalContainerView {
            isHorizontalBottomScroll = true
            let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
  
            if barCollectionView.numberOfItems(inSection: 0) > 0 {
                let indexPath = IndexPath(item: pageIndex, section: 0)
                barCollectionView.delegate?.collectionView?(barCollectionView, didSelectItemAt: indexPath)
//                previosSelectedIndexPath = indexPath
            }
            
            let offsetX = scrollView.contentOffset.x / scrollView.contentSize.width * view.frame.width
            UIView.animate(withDuration: 0.1, animations: {
                self.bottomBarView.frame.origin.x = offsetX
            })
        }
        
        if scrollView == overlayScrollView {
            contentOffsets[currentIndex] = scrollView.contentOffset.y
            let topHeight = bottomView.frame.minY
            if scrollView.contentOffset.y < topHeight {
                self.containerScrollView.contentOffset.y = scrollView.contentOffset.y
                for childVC in childBottomVC {
                    childVC.collectionView.contentOffset.y = 0
                }
                contentOffsets.removeAll()
            } else {
                self.containerScrollView.contentOffset.y = topHeight
                childBottomVC[currentIndex].collectionView.contentOffset.y = scrollView.contentOffset.y - self.containerScrollView.contentOffset.y
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == horizontalContainerView {
            let newIndex = scrollView.contentOffset.x / scrollView.contentSize.width * 3
            if Int(newIndex) != currentIndex {
                print("Content Offset: \(contentOffsets)")
                currentIndex = Int(newIndex)
                
                if let offset = contentOffsets[currentIndex] {
                    self.overlayScrollView.contentOffset.y = offset
                } else {
                    self.overlayScrollView.contentOffset.y = self.containerScrollView.contentOffset.y
                }
                updateOverlayScrollContentSize(with: childBottomVC[currentIndex].collectionView)
                childView[currentIndex] = childBottomVC[currentIndex].collectionView
            }
            
        }
    }
}
