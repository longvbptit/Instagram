//
//  ProfileViewController.swift
//  Instegrem
//
//  Created by Bao Long on 19/05/2023.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ProfileViewController: UIViewController {
    //  MARK: - OUTLET
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var navBar: CustomNavigationBar!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var readMoreLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var barCollectionView: UICollectionView!
    @IBOutlet weak var horizontalContainerView: UIScrollView!
    
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var bottomBarViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var storySavedCollectionView: UICollectionView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
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
    
    var tapBioGesture: UITapGestureRecognizer!
    
    var firstLeftButton: UIButton!
        
    var user: User!
    
    var isOrigin: Bool = true
    
    var posts: [Post] = []

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
    
    deinit {
        print("DEBUG: DEINIT - Profile deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVC()
        settingUI()
        setUpBarColletion()
        layoutOverlayScrollView()
        horizontalContainerView.delegate = self
        setupStoryCollection()
        changeProfileButton.addTarget(self, action: #selector(changeProfileButtonTapped(_:)), for: .touchUpInside)
        
        if isOrigin {
            getCurrentUser()
        } else {
            getOtherUser()
        }
        
    }
    
    func getCurrentUser() {
        let tabbar = tabBarController as! TabBarController
        user = tabbar.user
        getOtherUser()
    }
    
    func getOtherUser() {
        self.avatarImage.sd_setImage(with: URL(string: self.user.avatar), placeholderImage: UIImage(named: "ic-avatar_default"))
        self.updateUI()
    }
    
    func getPosts() {
        HomeService.fetchUserPosts(user: user, completion: { [weak self] data, error in
            guard let strongSelf = self else { return }
            if let error = error {
                print("Cant get posts. Error: \(error)")
                return
            }
            
            strongSelf.posts = data
            for vc in strongSelf.childBottomVC {
                vc.posts = strongSelf.posts
                vc.delegate = strongSelf
            }
            
            self?.updateBottom()
        })
    }
    
    func updateBottom() {
        if let scrollView = childBottomVC[currentIndex].collectionView {
            scrollView.panGestureRecognizer.require(toFail: overlayScrollView.panGestureRecognizer)
        }
        updateOverlayScrollContentSize(with: childBottomVC[currentIndex].collectionView)
        
        isHorizontalBottomScroll = true
        
        if barCollectionView.numberOfItems(inSection: 0) > 0 {
            let indexPath = IndexPath(item: 0, section: 0)
            barCollectionView.delegate?.collectionView?(barCollectionView, didSelectItemAt: indexPath)
            //                previosSelectedIndexPath = indexPath
        }
        view.layoutIfNeeded()
    }
    
    func settingUI() {
        
        indicator = IGActivityIndicator(frame: avatarImage.frame, addWidthAndHeight: 4)
//        topView.layer.addSublayer(indicator)
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 40
        indicator.addAnimation()
        if isOrigin {
            setupNavBar()
        } else {
            setUpOtherUserNavBar()
        }
        
        horizontalContainerView.isPagingEnabled = true
        horizontalContainerView.bounces = true
        horizontalContainerView.alwaysBounceVertical = false
        horizontalContainerView.alwaysBounceHorizontal = true
        
    }
    
    func updateUI() {
        if isOrigin {
            firstLeftButton.setTitle(user.userName, for: .normal)
        }
        fullNameLabel.text = user.name
        bioLabel.text = user.bio
        bioLabel.numberOfLines = 0
        configBioLabel()
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
        firstLeftButton = UIButton(type: .system)
        firstLeftButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        firstLeftButton.setTitleColor(UIColor.black, for: .normal)
        firstLeftButton.addTarget(self, action: #selector(buttonUserTapped(_:)), for: .touchUpInside)
        
        let secondLeftButton = UIButton()
        secondLeftButton.setImage(UIImage(named: "ic-arrow_down"), for: .normal)
        
        let firstRightButton = UIButton(type: .system)
        firstRightButton.setImage(UIImage(named: "ic-more")?.withRenderingMode(.alwaysOriginal), for: .normal)
        firstRightButton.addTarget(self, action: #selector(buttonMoreTapped(_:)), for: .touchUpInside)
        
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 4
        let secondRightButton = UIButton(type: .system)
        secondRightButton.setImage(UIImage(named: "ic-create")?.withRenderingMode(.alwaysOriginal), for: .normal)
        secondRightButton.addTarget(self, action: #selector(buttonCreateTapped(_:)), for: .touchUpInside)
        secondLeftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        
        
        let naviBar = CustomNavigationBar(leftButtons: [firstLeftButton, secondLeftButton], rightButtons: [firstRightButton, secondRightButton], spacingRightButton: 24)
        naviBar.backgroundColor = UIColor.white
        navBar.addSubview(naviBar)
        naviBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            naviBar.topAnchor.constraint(equalTo: navBar.topAnchor),
            naviBar.bottomAnchor.constraint(equalTo: navBar.bottomAnchor),
            naviBar.leftAnchor.constraint(equalTo: navBar.leftAnchor),
            naviBar.rightAnchor.constraint(equalTo: navBar.rightAnchor)
        ])
    }
    
    func setUpOtherUserNavBar() {
        firstLeftButton = UIButton(type: .system)
        firstLeftButton.setImage(UIImage(named: "ic-back_small")?.withRenderingMode(.alwaysOriginal), for: .normal)
        firstLeftButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        
        let centerButton = UIButton()
        centerButton.setTitle(user.userName, for: .normal)
        centerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        centerButton.setTitleColor(UIColor.black, for: .normal)
        centerButton.isUserInteractionEnabled = false
        
        let naviBar = CustomNavigationBar(leftButtons: [firstLeftButton], centerButton: centerButton)
        naviBar.backgroundColor = UIColor.white
        navBar.addSubview(naviBar)
        naviBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            naviBar.topAnchor.constraint(equalTo: navBar.topAnchor),
            naviBar.bottomAnchor.constraint(equalTo: navBar.bottomAnchor),
            naviBar.leftAnchor.constraint(equalTo: navBar.leftAnchor),
            naviBar.rightAnchor.constraint(equalTo: navBar.rightAnchor)
        ])
    }
    
    func layoutOverlayScrollView() {
        overlayScrollView = UIScrollView()
        overlayScrollView.showsVerticalScrollIndicator = false
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

    }
    
    override func viewWillLayoutSubviews() {
        for (index, childVC) in childBottomVC.enumerated() {
            childVC.view.frame = CGRect(x: CGFloat(index) * view.bounds.width, y: 0, width: view.bounds.width, height:  horizontalContainerView.bounds.height)
            horizontalContainerView.addSubview(childVC.view)
            childVC.didMove(toParent: self)
        }
        getPosts()
        bottomBarViewWidthConstraint.constant = (view.frame.width - 3) / CGFloat(childBottomVC.count)
        
    }
    
    func configBioLabel() {
        if bioLabel.requiredHeight > 18*3 {
            bioLabel.numberOfLines = 3
            readMoreLabel.alpha = 1
            tapBioGesture = UITapGestureRecognizer(target: self, action: #selector(handleBioTapGesture(_:)))
            let tapReadmore = UITapGestureRecognizer(target: self, action: #selector(handleBioTapGesture(_:)))
            bioLabel.isUserInteractionEnabled = true
            readMoreLabel.isUserInteractionEnabled = true
            bioLabel.addGestureRecognizer(tapBioGesture)
            readMoreLabel.addGestureRecognizer(tapReadmore)
        }
    }
    
    func addChildVC() {
        childBottomVC = setupChildViewController()
        for childVC in childBottomVC {
            addChild(childVC)
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
        vc2.count = 2
        vc2.color = .green
        
        return [vc, vc1, vc2]
    }
    
    func updateOverlayScrollContentSize(with bottomView: UIView){
        self.overlayScrollView.contentSize = getContentSize(for: bottomView)
        self.containerScrollView.contentSize = self.overlayScrollView.contentSize
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
        let vc = ProfileCreateViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    @objc func buttonMoreTapped(_ sender: UIButton) {
        let vc = ProfileMoreViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    @objc func buttonUserTapped(_ sender: UIButton) {
        let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        let vc = ProfileAddAccountViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.avatar = avatarImage.image
        vc.completionHandler = {
            UIView.animate(withDuration: 0.3, animations: {
                self.tabBarController?.view.cornerRadius = 0
                self.tabBarController?.view.transform = CGAffineTransform.identity
            })
        }

        self.present(vc, animated: false) {
            UIView.animate(withDuration: 0.3, animations: {
                self.tabBarController?.view.transform = transform
                self.tabBarController?.view.cornerRadius = 48
                self.tabBarController?.view.clipsToBounds = true
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func handleBioTapGesture(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.1, animations: {
            self.bioLabel.numberOfLines = 0
            self.readMoreLabel.alpha = 0
        })
    }
    
    @objc func changeProfileButtonTapped(_ sender: UIButton) {
        let vc = ProfileChangeViewController()
        vc.user = user
        vc.avt = avatarImage.image
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true)
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
            if indexPath.row == 0 {
                cell.addStoryImage.isHidden = false
                cell.storyImage.sd_setImage(with: URL(string: user.avatar))
            } else {
                cell.storyImage.image = UIImage(named: story[indexPath.row].image)
                cell.addStoryImage.isHidden = true
            }
            cell.storyImage.cornerRadius = 28
            cell.widthAddStory.constant = 56/3
            cell.storyLabel.text = story[indexPath.row].title
            cell.storyImage.contentMode = .scaleAspectFill
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileBarCollectionViewCell", for: indexPath) as! ProfileBarCollectionViewCell
            let image = childBottomVC[indexPath.row].pageImage
            cell.image.image = UIImage(named: image ?? "ic-avt")
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
            }
            
            let offsetX = scrollView.contentOffset.x / scrollView.contentSize.width * view.frame.width
            UIView.animate(withDuration: 0.1, animations: {
                self.bottomBarView.frame.origin.x = offsetX
            })
        }
        
        if scrollView == overlayScrollView {
            contentOffsets[currentIndex] = scrollView.contentOffset.y
            let topHeight = bottomView.frame.minY
            if round(scrollView.contentOffset.y) < round(topHeight) {
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

extension ProfileViewController: UpdateUserInfoDelegate {
    func updateUserInfo(user: User, avatar: UIImage?) {
        if let avatar = avatar {
            self.avatarImage.image = avatar
        }
        self.user = user
        updateUI()
    }
}

extension ProfileViewController: PostProfileDelegate {
    func gotoDetaiPost(posts: [Post], type: String, indexPath: IndexPath) {
        let vc = DetailPostViewController()
        vc.posts = posts
        vc.type = type
        vc.indexPath = indexPath
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }
}
