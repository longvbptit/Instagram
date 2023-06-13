//
//  LikeTableViewCell.swift
//  Instegrem
//
//  Created by Bao Long on 08/06/2023.
//

import UIKit

class LikeTableViewCell: UITableViewCell {

    @IBOutlet weak var followUserNameButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var followButtonWidthConstraint: NSLayoutConstraint!
    weak var delegate: FollowUserDelegate!
    var indexPath: IndexPath!
    var inCurrentUser: Bool = true
    var user: User!
    var type: FollowType = .none
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell() {
        followButton.isHidden = true
        avatarImage.sd_setImage(with: URL(string: user.avatar))
        userNameLabel.text = user.userName
        nameLabel.text = user.name
    }
    
    func updateData() {
        avatarImage.sd_setImage(with: URL(string: user.avatar))
        userNameLabel.text = user.userName
        nameLabel.text = user.name
    }
    
    func updateFollowButton() {
        followUserNameButton.setTitle("", for: .normal)
        followUserNameButton.isHidden = true
        switch(user.isFollowByCurrentUser) {
        case .currenUser:
            followButton.isHidden = true
        case .notFollowYet:
            followButton.isHidden = false
            UIView.performWithoutAnimation {
                followButton.setTitle("Theo dõi", for: .normal)
                followButton.setTitleColor(.white, for: .normal)
                followButton.backgroundColor = UIColor(red: 41/255, green: 153/255, blue: 251/255, alpha: 1)
                followButton.layoutIfNeeded()
            }
            
        case .followed:
            followButton.isHidden = false
            UIView.performWithoutAnimation {
                followButton.setTitle("Đang theo dõi", for: .normal)
                followButton.setTitleColor(.black, for: .normal)
                followButton.backgroundColor = .systemGray6
                followButton.layoutIfNeeded()
            }
            
        }
    }
    
    func updateFollowUserNameButton() {
        if type == .followers && inCurrentUser {
            updateRemoveFollowerButtton()
            
            switch(user.isFollowByCurrentUser) {
            case .currenUser:
//                followButton.isHidden = true
                return
            case .notFollowYet:
//                followButton.isHidden = false
                UIView.performWithoutAnimation {
                    followUserNameButton.setTitle("Theo dõi", for: .normal)
                    followUserNameButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
                    followUserNameButton.setTitleColor(UIColor(red: 41/255, green: 153/255, blue: 251/255, alpha: 1), for: .normal)
                    followUserNameButton.layoutIfNeeded()
                }
                
            case .followed:
//                followButton.isHidden = false
                UIView.performWithoutAnimation {
                    followUserNameButton.setTitle("Đang theo dõi", for: .normal)
                    followUserNameButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
                    followUserNameButton.setTitleColor(.black, for: .normal)
                    followUserNameButton.layoutIfNeeded()
                }
            }
            
        }
    }
    
    func updateRemoveFollowerButtton() {
        followButtonWidthConstraint.constant = 48
        followButton.setTitle("Gỡ", for: .normal)
        followButton.setTitleColor(.black, for: .normal)
        followButton.backgroundColor = .systemGray6
    }
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        if type == .followers && inCurrentUser {
            delegate.removeFollower(uid: user.uid, indexPath: indexPath)
        } else {
            delegate.followUser(uid: user.uid, indexPath: indexPath)
        }
        
    }
    
    @IBAction func followUserNameButtonTapped(_ sender: UIButton) {
        delegate.followUser(uid: user.uid, indexPath: indexPath)
    }
}
