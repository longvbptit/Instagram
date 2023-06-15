//
//  PostCollectionViewCell.swift
//  Instegrem
//
//  Created by Bao Long on 01/06/2023.
//

import UIKit
import SDWebImage

protocol PostDelegate: AnyObject {
    func gotoProfile(user: User)
    func likePost(indexPath: IndexPath, isLike: Bool, numberOfLike: Int)
    func gotoLike(indexPath: IndexPath)
    func gotoComment(indexPath: IndexPath)
}

class PostCollectionViewCell: UICollectionViewCell {
    var indexPath: IndexPath!
    static let identifier = "PostCollectionViewCell"
    weak var delegate: PostDelegate!
    var isSetData: Bool = false
    var postImageRattio: CGFloat = 1
    var post: Post! {
        didSet {
            if !isSetData {
                configUI()
                isSetData = true
            }
            configData()
        }
    }
    
    var formatter: DateFormatter!
    var userNameLabel: UILabel!
    var userNameButton: UIButton!
    var contentImageHeightConstraint: NSLayoutConstraint!
    var userNameButtonWidthConstraint: NSLayoutConstraint!
    var timeLabelBottomConstraint: NSLayoutConstraint!
    
    var topAnchorLike: NSLayoutConstraint!
    var heightLike: NSLayoutConstraint!
    
    var topAnchorStatus: NSLayoutConstraint!
    var heightStatus: NSLayoutConstraint!
    
    var heightComment: NSLayoutConstraint!
    var topAnchorTime: NSLayoutConstraint!
    
    lazy var avatarButton: UIButton = {
        let avatarButton = UIButton(type: .custom)
        avatarButton.imageView?.contentMode = .scaleToFill
        avatarButton.cornerRadius = 18
        avatarButton.clipsToBounds = true
        avatarButton.addTarget(self, action: #selector(gotoProfile(_:)), for: .touchUpInside)
        return avatarButton
    }()
    
    lazy var nameButton: UIButton = {
        let nameButton = UIButton(type: .system)
        nameButton.setTitleColor(.black, for: .normal)
        nameButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        nameButton.addTarget(self, action: #selector(gotoProfile(_:)), for: .touchUpInside)
        return nameButton
    }()
    
    lazy var optionButton: UIButton = {
        let optionButton = UIButton()
        optionButton.setImage(UIImage(named: "ic-option"), for: .normal)
        return optionButton
    }()
    
    lazy var contentImage: ISImageView = {
        let contentImage = ISImageView()
        contentImage.isInteractable = true
        // Double Tap
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapToLikePost(_:)))
        doubleTap.numberOfTapsRequired = 2
        contentImage.addGestureRecognizer(doubleTap)
        
        contentImage.contentMode = .scaleAspectFit
        contentImage.translatesAutoresizingMaskIntoConstraints = false
        return contentImage
    }()
    
    lazy var topBar: CustomNavigationBar = {
        let topBar = CustomNavigationBar(leftButtons: [avatarButton, nameButton],
                                         spacingLeftButton: 8,
                                         isFirstLeftButtonSettedSize: true,
                                         rightButtons: [optionButton])
        contentView.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        return topBar
    }()
    
    lazy var heartButton: UIButton = {
        let heartButton = UIButton()
        heartButton.addTarget(self, action: #selector(buttonLikeTapped(_:)), for: .touchUpInside)
        return heartButton
    }()
    
    lazy var reactionBar: CustomNavigationBar = {
        
        let commentButton = UIButton()
        commentButton.setImage(UIImage(named: "ic-comment"), for: .normal)
        commentButton.addTarget(self, action: #selector(gotoComment(_:)), for: .touchUpInside)
        
        let shareButton = UIButton(type: .system)
        shareButton.setImage(UIImage(named: "ic-share")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        let saveButton = UIButton(type: .system)
        saveButton.setImage(UIImage(named: "ic-save")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        let reactionBar = CustomNavigationBar(leftButtons: [heartButton, commentButton, shareButton],
                                              spacingLeftButton: 12,
                                              rightButtons: [saveButton] )
        reactionBar.translatesAutoresizingMaskIntoConstraints = false
        return reactionBar
    }()
    
    lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.addTarget(self, action: #selector(gotoLike(_:)), for: .touchUpInside)
        likeButton.contentHorizontalAlignment = .left
        likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        likeButton.setTitleColor(.black, for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        return likeButton
    }()
    
    lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.numberOfLines = 0
        statusLabel.lineBreakMode = .byWordWrapping
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
//        statusLabel.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
//        statusLabel.setContentCompressionResistancePriority(UILayoutPriority(751), for: .vertical)
        return statusLabel
    }()
    
    lazy var seeAllCommentButton: UIButton = {
        let seeAllCommentButton = UIButton(type: .system)
        seeAllCommentButton.addTarget(self, action: #selector(gotoComment(_:)), for: .touchUpInside)
        seeAllCommentButton.setTitleColor(UIColor.systemGray3, for: .normal)
        seeAllCommentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        seeAllCommentButton.contentHorizontalAlignment = .left
        contentView.addSubview(seeAllCommentButton)
        seeAllCommentButton.translatesAutoresizingMaskIntoConstraints = false
        return seeAllCommentButton
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy 'lúc' HH:mm"
        
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
//        timeLabel.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
//        timeLabel.setContentCompressionResistancePriority(UILayoutPriority(751), for: .vertical)
        return timeLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        contentView.addSubview(topBar)
        contentView.addSubview(contentImage)
        contentView.addSubview(reactionBar)
        contentView.addSubview(likeButton)
        contentView.addSubview(statusLabel)
        contentView.addSubview(seeAllCommentButton)
        contentView.addSubview(timeLabel)
        
        userNameLabel = UILabel()
        userNameLabel.text = self.post.user.userName
        userNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        userNameButton = UIButton(type: .system)
        userNameButton.addTarget(self, action: #selector(gotoProfile(_:)), for: .touchUpInside)
        contentView.addSubview(userNameButton)
        userNameButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentImageHeightConstraint = contentImage.heightAnchor.constraint(equalToConstant: contentView.frame.width / postImageRattio)
        userNameButtonWidthConstraint = userNameButton.widthAnchor.constraint(equalToConstant: 17)
        timeLabelBottomConstraint = timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        timeLabelBottomConstraint.priority = UILayoutPriority(999)
        
        topAnchorLike = likeButton.topAnchor.constraint(equalTo: reactionBar.bottomAnchor, constant: 6)
        heightLike = likeButton.heightAnchor.constraint(equalToConstant: 17)
        
        topAnchorStatus = statusLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 6)
        heightStatus = statusLabel.heightAnchor.constraint(equalToConstant: 0)
        
        heightComment = seeAllCommentButton.heightAnchor.constraint(equalToConstant: 0)
        topAnchorTime = timeLabel.topAnchor.constraint(equalTo: seeAllCommentButton.bottomAnchor, constant: 6)
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            topBar.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            topBar.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            //            topBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            contentImage.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            contentImage.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            contentImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            //            contentImageHeightConstraint,
            
            reactionBar.topAnchor.constraint(equalTo: contentImage.bottomAnchor, constant: 6),
            reactionBar.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            reactionBar.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            //            reactionBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
            
            topAnchorLike,
            likeButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            likeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            heightLike,
            
            topAnchorStatus,
            statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            
            seeAllCommentButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor),
            seeAllCommentButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            seeAllCommentButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            
            topAnchorTime,
            timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            timeLabelBottomConstraint,
            
            userNameButton.topAnchor.constraint(equalTo: statusLabel.topAnchor),
            userNameButton.leftAnchor.constraint(equalTo: statusLabel.leftAnchor),
            //            userNameButton.widthAnchor.constraint(equalToConstant: userNameLabel.intrinsicContentSize.width),
            userNameButton.heightAnchor.constraint(equalToConstant: userNameLabel.intrinsicContentSize.height)
            
        ])
        
    }
    
    func configData() {
        
        avatarButton.sd_setImage(with: URL(string: self.post.user.avatar), for: .normal)
        
        nameButton.setTitle(self.post.user.userName, for: .normal)
        
        contentImage.sd_setImage(with: URL(string: self.post.postImage.image))
        
        heartButton.setImage(post.isLiked ? UIImage(named: "ic-heart_liked") : UIImage(named: "ic-heart"), for: .normal)
        
//        if post.isLiked {
//            heartButton.setImage(UIImage(named: "ic-heart_liked"), for: .normal)
//        }
        
        updateLikeButton()
        updateStatusLabel()
        updateCommentButton()
        
        let nameAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold) ]
        let statusAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular) ]
        let myString = NSMutableAttributedString(string: self.post.user.userName, attributes: nameAttribute )
        let attrString = NSAttributedString(string: " " + self.post.status, attributes: statusAttribute)
        myString.append(attrString)
        statusLabel.attributedText = myString
        
//        timeLabel.text = formatter.string(from: self.post.time)
        timeLabel.text = self.post.time.timeAgoDisplay()
        
        userNameLabel.text = self.post.user.userName
        
        contentImageHeightConstraint.isActive = false
        contentImageHeightConstraint = contentImage.heightAnchor.constraint(equalToConstant: contentView.frame.width / self.post.postImage.ratio)
        contentImageHeightConstraint.isActive = true
        userNameButtonWidthConstraint.isActive = false
        userNameButtonWidthConstraint = userNameButton.widthAnchor.constraint(equalToConstant: userNameLabel.intrinsicContentSize.width)
        userNameButtonWidthConstraint.isActive = true
    }
    
    @objc func buttonLikeTapped(_ sender: UIButton) {
        post.isLiked.toggle()

        if post.isLiked {
            post.numberOfLike += 1
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        } else {
            post.numberOfLike -= 1
        }
        delegate.likePost(indexPath: indexPath, isLike: post.isLiked, numberOfLike: post.numberOfLike)
        heartButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        //        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction], animations: {
        //            self.heartButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        //        }) {_ in
        //            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn, .allowUserInteraction], animations: {
        //                self.heartButton.transform = .identity
        //            })
        //        }
        
        UIView.animate(withDuration: 0.4, delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.3,
                       options: [.allowUserInteraction, .curveEaseIn],
                       animations: {
            self.heartButton.transform = .identity
        })
        
    }
    
    @objc func gotoProfile(_ sender: UIButton) {
        delegate.gotoProfile(user: post.user)
    }
    
    @objc func doubleTapToLikePost(_ sender: UITapGestureRecognizer) {
        if !post.isLiked {
            post.isLiked = true
            post.numberOfLike += 1
            
//            updateLikeButton()
            
            DispatchQueue.main.async {
                self.showBigHeart(completion: {})
            }
            
            delegate.likePost(indexPath: indexPath, isLike: post.isLiked, numberOfLike: post.numberOfLike)
        } else {
            showBigHeart(completion: {})
        }
        
    }
    
    func showBigHeart(completion: @escaping(() -> Void)) {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        heartButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.heartButton.transform = .identity
        })
        let heartImage = UIImageView(image: UIImage(named: "ic-heart_liked_image"), highlightedImage: nil)
        heartImage.center = contentImage.center
        contentView.addSubview(heartImage)
        heartImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.allowUserInteraction, .curveEaseIn], animations: {
            heartImage.transform = .identity
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                heartImage.transform = CGAffineTransform(scaleX: 0, y: 0)
            }) { _ in
                heartImage.removeFromSuperview()
                completion()
            }
        }
    }
    
    func updateLikeButton() {
        if post.numberOfLike > 0 {
            likeButton.setTitle("\(post.numberOfLike) lượt thích", for: .normal)
            topAnchorLike.isActive = false
            topAnchorLike = likeButton.topAnchor.constraint(equalTo: reactionBar.bottomAnchor, constant: 6)
            topAnchorLike.isActive = true
            heightLike.isActive = false
            heightLike = likeButton.heightAnchor.constraint(equalToConstant: 17)
            heightLike.isActive = true
        } else {
            likeButton.setTitle("", for: .normal)
            topAnchorLike.isActive = false
            topAnchorLike = likeButton.topAnchor.constraint(equalTo: reactionBar.bottomAnchor, constant: 0)
            topAnchorLike.isActive = true
            heightLike.isActive = false
            heightLike = likeButton.heightAnchor.constraint(equalToConstant: 0)
            heightLike.isActive = true
        }
    }
    
    func updateStatusLabel() {
        if post.status == "" {
            userNameButton.isHidden = true
            topAnchorStatus.isActive = false
            topAnchorStatus = statusLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 0)
            topAnchorStatus.isActive = true
            heightStatus.isActive = true
        } else {
            userNameButton.isHidden = false
            topAnchorStatus.isActive = false
            topAnchorStatus = statusLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 6)
            topAnchorStatus.isActive = true
            heightStatus.isActive = false
        }
    }
    
    func updateCommentButton() {
        if post.numberOfComment > 0 {
            if post.numberOfComment < 3 {
                seeAllCommentButton.setTitle("Xem \(post.numberOfComment) bình luận", for: .normal)
            } else {
                seeAllCommentButton.setTitle("Xem tất cả \(post.numberOfComment) bình luận", for: .normal)
            }
            topAnchorTime.isActive = false
            topAnchorTime = timeLabel.topAnchor.constraint(equalTo: seeAllCommentButton.bottomAnchor, constant: 0)
            topAnchorTime.isActive = true
            heightComment.isActive = false
        } else {
            seeAllCommentButton.setTitle("", for: .normal)
            topAnchorTime.isActive = false
            topAnchorTime = timeLabel.topAnchor.constraint(equalTo: seeAllCommentButton.bottomAnchor, constant: 6)
            topAnchorTime.isActive = true
            heightComment.isActive = true
        }
    }
    
    @objc func gotoLike(_ sender: UIButton) {
        delegate.gotoLike(indexPath: indexPath)
    }
    
    @objc func gotoComment(_ sender: UIButton) {
        delegate.gotoComment(indexPath: indexPath)
    }
    
}

