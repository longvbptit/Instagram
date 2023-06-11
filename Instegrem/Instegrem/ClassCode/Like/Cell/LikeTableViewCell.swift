//
//  LikeTableViewCell.swift
//  Instegrem
//
//  Created by Bao Long on 08/06/2023.
//

import UIKit

class LikeTableViewCell: UITableViewCell {

    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    weak var delegate: FollowUserDelegate!
    var indexPath: IndexPath!
    var user: User! {
        didSet {
//            avatarImage.sd_setImage(with: URL(string: user.avatar))
//            userNameLabel.text = user.userName
//            nameLabel.text = user.name
//            updateFollowButton()
        }
    }
    
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
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        delegate.followUser(uid: user.uid, indexPath: indexPath)
    }
    
}
