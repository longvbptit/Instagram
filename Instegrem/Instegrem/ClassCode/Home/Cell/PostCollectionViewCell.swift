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
}

class PostCollectionViewCell: UICollectionViewCell {
    
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
    var userNameButtonHeightConstraint: NSLayoutConstraint!
    var timeLabelBottomConstraint: NSLayoutConstraint!
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
    
    lazy var reactionBar: CustomNavigationBar = {
        let heartButton = UIButton()
        heartButton.setImage(UIImage(named: "ic-heart"), for: .normal)
        
        let commentButton = UIButton()
        commentButton.setImage(UIImage(named: "ic-comment"), for: .normal)
        
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
    
    lazy var likeLabel: UILabel = {
        let likeLabel = UILabel()
        likeLabel.text = "1234 lượt thích"
        likeLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        likeLabel.textColor = UIColor.black
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        return likeLabel
    }()
    
    lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.numberOfLines = 0
        statusLabel.lineBreakMode = .byWordWrapping
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        statusLabel.setContentCompressionResistancePriority(UILayoutPriority(751), for: .vertical)
        return statusLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        formatter = DateFormatter()
        formatter.dateStyle = .short
        
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        timeLabel.setContentCompressionResistancePriority(UILayoutPriority(751), for: .vertical)
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
        contentView.addSubview(likeLabel)
        contentView.addSubview(statusLabel)

        let seeAllCommentButton = UIButton(type: .system)
        seeAllCommentButton.setTitle("Xem tất cả 100 comment", for: .normal)
        seeAllCommentButton.setTitleColor(UIColor.systemGray3, for: .normal)
        seeAllCommentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        seeAllCommentButton.contentHorizontalAlignment = .left
        contentView.addSubview(seeAllCommentButton)
        seeAllCommentButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(timeLabel)
        
        userNameLabel = UILabel()
        userNameLabel.text = self.post.user.userName
        userNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        userNameButton = UIButton(type: .system)
        userNameButton.addTarget(self, action: #selector(gotoProfile(_:)), for: .touchUpInside)
        contentView.addSubview(userNameButton)
        userNameButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentImageHeightConstraint = contentImage.heightAnchor.constraint(equalToConstant: contentView.frame.width / postImageRattio)
        userNameButtonHeightConstraint = userNameButton.widthAnchor.constraint(equalToConstant: 17)
        timeLabelBottomConstraint = timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        timeLabelBottomConstraint.priority = UILayoutPriority(999)
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
            
            likeLabel.topAnchor.constraint(equalTo: reactionBar.bottomAnchor, constant: 6),
            likeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            likeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            likeLabel.heightAnchor.constraint(equalToConstant: 17),
            
            statusLabel.topAnchor.constraint(equalTo: likeLabel.bottomAnchor, constant: 6),
            statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),

            seeAllCommentButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor),
            seeAllCommentButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            seeAllCommentButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),

            timeLabel.topAnchor.constraint(equalTo: seeAllCommentButton.bottomAnchor),
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
        let nameAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold) ]
        let statusAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular) ]
        let myString = NSMutableAttributedString(string: self.post.user.userName, attributes: nameAttribute )
        let attrString = NSAttributedString(string: " " + self.post.status, attributes: statusAttribute)
        myString.append(attrString)
        statusLabel.attributedText = myString
        
        timeLabel.text = formatter.string(from: self.post.time)
        
        userNameLabel.text = self.post.user.userName
        
        contentImageHeightConstraint.isActive = false
        contentImageHeightConstraint = contentImage.heightAnchor.constraint(equalToConstant: contentView.frame.width / self.post.postImage.ratio)
        contentImageHeightConstraint.isActive = true
        userNameButtonHeightConstraint.isActive = false
        userNameButtonHeightConstraint = userNameButton.widthAnchor.constraint(equalToConstant: userNameLabel.intrinsicContentSize.width)
        userNameButtonHeightConstraint.isActive = true
    }
    
    @objc func gotoProfile(_ sender: UIButton) {
        delegate.gotoProfile(user: post.user)
    }
    
}

